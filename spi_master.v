`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
// 
// Create Date: 03/23/2021 05:51:00 PM
// Design Name: 
// Module Name: spi_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_master #(parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 15)
    (
        input  wire                                  i_clk,
        input  wire                                  i_rst,
        input  wire [DATA_WIDTH-1:0]                 i_data,
        input  wire [ADDR_WIDTH-1:0]                 i_addr,
        input  wire                                  i_rw,
        input  wire                                  i_enable,
        input  wire                                  i_burst_enable,
        input  wire  [15:0]                          i_burst_count,
        input  wire  [15:0]                          i_divider,
        input  wire                                  i_cpha,
        input  wire                                  i_cpol,
        input  wire                                  i_miso,
        output wire                                  o_sclk,
        output wire  [DATA_WIDTH-1:0]                o_read_word,
        output reg                                   o_busy = 0,        
        output reg                                   o_ss = 1,
        output reg                                   o_mosi = 0,
        output reg   [DATA_WIDTH+ADDR_WIDTH:0]       o_read_long_word = 0,        
        output reg                                   o_burst_read_data_valid = 0,
        output reg                                   o_burst_write_word_request = 0
    );
    
/*INSTANTATION TEMPLATE
spi_master spi_master_inst(
            .i_clk(),
            .i_rst(),
            .i_data(),
            .i_addr(),
            .i_rw(),
            .i_enable(),
            .i_burst_enable(),
            .i_burst_count(),
            .i_divider(),
            .i_cpha(),
            .i_cpol(),
            .i_miso(),
            .o_sclk(),
            .o_read_word(),
            .o_busy(),        
            .o_ss(),
            .o_mosi(),
            .o_read_long_word(),        
            .o_burst_read_data_valid(),
            .o_burst_write_word_request()
        );
*/
    
    
    localparam S_IDLE           =           8'h00;
    localparam S_SET_SS         =           8'h01;
    localparam S_TRANSMIT_ADDR  =           8'h02;
    localparam S_TRANSMIT_DATA  =           8'h03;
    localparam S_READ_DATA      =           8'h04;
    localparam S_STOP           =           8'h05;


    reg [7:0] state = 0;
    reg [7:0] proc_counter = 0;
    reg [7:0] bit_counter = 0;
    reg [DATA_WIDTH+ADDR_WIDTH:0] data_out = 0;
    reg [DATA_WIDTH+ADDR_WIDTH:0] read_data = 0;
    reg        burst_enable = 0;
    reg        rw = 0;
    reg        cpha = 0;
    reg        cpol = 0;
    reg        sclk = 0;
    reg [DATA_WIDTH+ADDR_WIDTH:0] read_word = 0;   
    reg [15:0] burst_count = 0;      
    
    
    assign o_read_word = read_data[DATA_WIDTH-1:0];
    
    assign o_sclk = (cpol == 0) ? sclk : ~sclk;
    
    reg [15:0] divider_counter = 0;
    //clock divider
    wire divider_tick;
    assign divider_tick = (divider_counter == i_divider) ? 1 : 0;
    //spi divider tick geneartor
    always@(posedge i_clk)begin
        if(i_rst)begin
            divider_counter <= 0;
        end
        else begin
            if(divider_counter == i_divider)begin
                divider_counter <= 0;
            end
            else begin
                divider_counter <= divider_counter + 1;
            end
        end
    end
    
    
    


    always@(posedge i_clk)begin
        if(i_rst)begin
            state <= S_IDLE;
            o_busy <= 0;
            burst_enable <= 0;
            rw <= 0;
            cpha <= 0;
            cpol <= 0;
            o_ss <= 1;
            o_mosi <= 0;
            sclk <= 0;
            read_word <= 0;
            read_data <= 0;
            o_burst_read_data_valid <= 0;
            burst_count <= 0;
            o_burst_write_word_request <= 0;
            o_read_long_word <= 0;
        end
        else begin
            if(divider_tick)begin
                case(state)
                    S_IDLE: begin
                        proc_counter <= 0;
                        burst_enable <= i_burst_enable;
                        rw <= i_rw;
                        cpha <= i_cpha;
                        cpol <= i_cpol;
                        burst_count <= i_burst_count;
                        if(i_enable)begin
                            o_busy <= 1;
                            state <= S_SET_SS;
                        end
                    end
                    
                    S_SET_SS: begin
                        state <= S_TRANSMIT_ADDR;
                        o_ss <= 0;
                        data_out <= {i_addr, i_rw, i_data};
                        if(cpha == 0)begin
                            //to meet setup requirements we must set now for cpha = 0
                            o_mosi <= i_addr[ADDR_WIDTH-1];
                        end
                    end
                    
                    //shift out addr portion of data_out
                    //reg in shifted in data from slave into read_data
                    S_TRANSMIT_ADDR: begin
                        case(proc_counter)
                            0: begin
                               proc_counter <= 1;
                               if(bit_counter > 0 && cpha == 1)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];
                               end
                               if(bit_counter == 0 && cpha == 0)begin
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                                if(cpha == 1)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];   
                               end
                            end
                            
                            1: begin
                               proc_counter <= 2;
                               if(cpha == 1)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               sclk <= 1;
                            end
                            
                            2: begin
                               proc_counter <= 3;
                               if(cpha == 0)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];          
                               end
                            end
                            
                            3: begin
                                sclk <= 0;
                                proc_counter <= 0;
                               if(cpha == 0)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               if(bit_counter == ADDR_WIDTH)begin
                                   if(rw == 0)begin
                                      state <= S_TRANSMIT_DATA;    
                                   end
                                   else begin
                                      state <= S_READ_DATA;
                                   end
                                   
                                   bit_counter <= 0;
                               end
                               else begin
                                   bit_counter <= bit_counter + 1;
                               end
                            end
                        endcase
                    end
                    
                    //shift out data portion of data_out
                    //reg in shifted in data from slave into read_data
                    S_TRANSMIT_DATA: begin
                        case(proc_counter)
                            0:begin
                                proc_counter <= 1;
                                if(bit_counter == (DATA_WIDTH-1) && burst_enable == 1 && burst_count > 1)begin
                                    //if in burst mode send out request for new data word
                                    o_burst_write_word_request <= 1;
                                end
                                if(cpha == 1)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];   
                               end
                            end
                            
                            1: begin
                               proc_counter <= 2;
                               if(cpha == 1)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               sclk <= 1;
                            end
                            
                            2: begin
                                proc_counter <= 3;
                                if(cpha == 0)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0]; 
                                end
                                if(o_burst_write_word_request == 1)begin
                                    o_burst_write_word_request <= 0;
                                    data_out[DATA_WIDTH+ADDR_WIDTH:ADDR_WIDTH+1] <= i_data;
                                end
                                


                            end
                            
                            3: begin
                               sclk <= 0;
                               proc_counter <= 0;
                               if(cpha == 0)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               if(bit_counter == (DATA_WIDTH-1))begin
                                  bit_counter <= 0;
                                  if(burst_enable)begin
                                        //if in burst mode decrement burst counter
                                        burst_count <= burst_count - 1;
                                        if(burst_count <= 1)begin
                                           state <= S_STOP;
                                        end
                                   end
                                   else begin
                                       state <= S_STOP;
                                   end
                               end
                               else begin
                                   bit_counter <= bit_counter + 1;
                               end
                            end
                        endcase
                    end
                    
                    //reg in shifted in data from slave into read_data
                    S_READ_DATA: begin
                        case(proc_counter)
                            0:begin
                                proc_counter <= 1;
                                o_burst_read_data_valid <= 0;
                                if(cpha == 1)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];   
                               end
                            end
                            
                            1: begin
                               proc_counter <= 2;
                               if(cpha == 1)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               sclk <= 1;
                            end
                            
                            2: begin
                                proc_counter <= 3;
                                if(cpha == 0)begin
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];
                                end
                            end
                            
                            3: begin
                               sclk <= 0;
                               proc_counter <= 0;
                               if(cpha == 0)begin
                                    o_mosi <= data_out[DATA_WIDTH+ADDR_WIDTH];
                                    data_out <= {data_out[DATA_WIDTH+ADDR_WIDTH-1:0], 1'b0};
                               end
                               if(bit_counter == (DATA_WIDTH-1))begin
                                   bit_counter <= 0;
                                   if(burst_enable)begin
                                        burst_count <= burst_count - 1;
                                        if(burst_count <= 1)begin
                                           state <= S_STOP;
                                        end
                                        o_burst_read_data_valid <= 1;
                                   end
                                   else begin
                                       state <= S_STOP;
                                       
                                   end
                               end
                               else begin
                                   bit_counter <= bit_counter + 1;
                               end
                            end
                        endcase
                    end
                    
                    S_STOP: begin
                    
                        case(proc_counter)
                            0:begin
                                proc_counter <= 1;
                                o_burst_read_data_valid <= 0;
                                if(cpha == 1)begin
                                    //read here to meet SPI timing requirements if cpha = 1
                                    read_data[0] <= i_miso;
                                    read_data[DATA_WIDTH+ADDR_WIDTH:1] <= read_data[DATA_WIDTH+ADDR_WIDTH-1:0];
                               end
                            end
                            
                            1: begin
                               //latch out read_data to o_read_long_word output
                               o_read_long_word <= read_data;
                               o_ss <= 1;
                               o_mosi <= 0;
                               proc_counter <= 2;
                            end
                            
                            2: begin
                                proc_counter <= 3;
                            end
                            
                            3: begin
                               proc_counter <= 0;
                               o_busy <= 0;
                               state <= S_IDLE;
                            end
                        endcase
                    end
                    
                    
                endcase
            end
        end
    
    end


endmodule