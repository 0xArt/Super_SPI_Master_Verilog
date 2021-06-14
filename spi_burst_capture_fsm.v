`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
// 
// Create Date: 03/15/2021 01:33:53 PM
// Design Name: 
// Module Name: spi_burst_capture_fsm
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


module spi_burst_capture_fsm(

        input wire i_clk,
        input wire i_rst,
        input wire [15:0]  i_burst_count,
        input wire         i_burst_data_valid,
        input wire         i_start,
        input wire [15:0]  i_spi_output_data,
        output reg         o_busy = 0,
        output reg         o_outbuf_we = 0,
        output reg [15:0]  o_outbuf_dat = 0,
        output reg [15:0]  o_outbuf_addr = 0

    );
    
    
    localparam     S_IDLE                    = 8'h00;
    localparam     S_CAPTURE                 = 8'h01;
    localparam     S_DONE                    = 8'h02;
    
    
    reg [7:0]  state = S_IDLE;
    reg [15:0] counter = 0;
    reg [15:0] burst_count = 0;
    reg [2:0]  burst_data_valid = 0;
    
    
    wire burst_data_valid_pos_edge;    

    //Stable edge detect
    assign burst_data_valid_pos_edge = (burst_data_valid[1] == 1  && burst_data_valid[2] == 0) ? 1 : 0;

    always @(posedge i_clk)begin
        if(i_rst)begin
            burst_data_valid <= 0;
        end
        else begin
            burst_data_valid[0] <= i_burst_data_valid;
            burst_data_valid[1] <= burst_data_valid[0];
            burst_data_valid[2] <= burst_data_valid[1];
        end
    end
    
    
    always@(posedge i_clk)begin
    
        if(i_rst)begin
            state <= S_IDLE;
            counter <= 0;
            burst_count <= 0;
            o_outbuf_addr <= 0;
            o_outbuf_dat <= 0;
            o_busy <= 0;
            o_outbuf_we <= 0;
        end
        else begin
            case(state)
            
                S_IDLE: begin
                    if(i_start)begin
                        burst_count <= i_burst_count;
                        o_busy <= 1;
                        state <= S_CAPTURE;
                    end
                end
                
                S_CAPTURE: begin
                    if(burst_data_valid_pos_edge)begin
                        o_outbuf_dat <= i_spi_output_data;
                        counter <= counter + 1;
                        o_outbuf_we <= 1;
                        if(counter >= (burst_count-1))begin
                            state <= S_DONE;
                        end
                    end
                    if(o_outbuf_we == 1)begin
                        o_outbuf_we <= 0;
                        o_outbuf_addr <= o_outbuf_addr + 1;
                    end
                end
                
                S_DONE: begin
                    o_outbuf_we <= 0;
                    o_outbuf_addr <= 0;
                    o_busy <= 0;
                    o_outbuf_dat <= 0;
                    counter <= 0;
                    state <= S_IDLE;
                end
                
            endcase
        
        
        end
    
    end
endmodule
