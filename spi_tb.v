`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
// 
// Create Date: 06/02/2021 06:51:37 AM
// Design Name: 
// Module Name: spi_tb
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


module spi_tb(

    );
    
    
    
     real clockDelay50 = ((1/ (50e6))/2)*(1e9);
	 
	 reg main_clk = 0;
	 reg rst = 1;
		 
		 
	always begin
	  main_clk = 1'b0;
	  #clockDelay50;
	  main_clk = 1'b1;
	  #clockDelay50;
	end
    
    //SPI connections
    wire miso;
    wire mosi;
    wire sclk;
    wire ss;
    
    
    //SPI master control signals
    reg [15:0]  divider         = 16'h0003;
    reg [15:0]  data            = 16'h0;
    reg [14:0]  addr            = 15'h0;
    reg         rw              = 1'h0;
    reg         enable          = 1'h0;
    reg         burst_enable    = 1'h0;
    reg [15:0]  burst_count     = 16'h0;
    reg         cpha            = 1'h0;
    reg         cpol            = 1'h0;
    
    //SPI master status and outputs
    wire         busy;
    wire [15:0]  read_word;
    wire [31:0]  read_long_word;
    wire         burst_read_data_valid;
    wire         burst_write_word_request;
    
    //SPI burst fsm control
    reg     burst_read_capture_start = 0;
    wire    burst_read_capture_busy;
    
    //SPI burst memory
    wire        spi_burst_mem_we;
    wire [15:0] spi_burst_mem_dina;
    wire [15:0] spi_burst_mem_addra;
    
    wire [16:0] spi_burst_mem_addrb;
    wire [7:0]  spi_burst_mem_doutb;
    
    
    
    spi_master spi_master_inst(
                .i_clk(main_clk),
                .i_rst(rst),
                .i_data(data),
                .i_addr(addr),
                .i_rw(rw),
                .i_enable(enable),
                .i_burst_enable(burst_enable),
                .i_burst_count(burst_count),
                .i_divider(divider),
                .i_cpha(cpha),
                .i_cpol(cpol),
                .i_miso(miso),
                .o_sclk(sclk),
                .o_read_word(read_word),
                .o_busy(busy),        
                .o_ss(ss),
                .o_mosi(mosi),
                .o_read_long_word(read_long_word),        
                .o_burst_read_data_valid(burst_read_data_valid),
                .o_burst_write_word_request(burst_write_word_request)
        );
        
        
        
        spi_burst_capture_fsm spi_capture_fsm_inst(
            .i_clk(main_clk),
            .i_rst(rst),
            .i_burst_count(burst_count),
            .i_burst_data_valid(burst_read_data_valid),
            .i_start(burst_read_capture_start),
            .o_busy(burst_read_capture_busy),
            .o_outbuf_we(spi_burst_mem_we),
            .i_spi_output_data(read_word),
            .o_outbuf_dat(spi_burst_mem_dina),
            .o_outbuf_addr(spi_burst_mem_addra)
        );
        
        
        
        spi_burst_mem spi_burst_mem_inst(
             .clka(main_clk)
            , .addra(spi_burst_mem_addra)
            , .dina(spi_burst_mem_dina)
            , .wea(spi_burst_mem_we)
            , .clkb(main_clk)
            , .addrb(spi_burst_mem_addrb)
            , .doutb(spi_burst_mem_doutb)        
        );
        
        
        
    MAX31855_Model MAX31855_inst(
         .i_system_clk(main_clk)
        ,.i_sck(sclk)
        ,.i_cs(ss)
        ,.o_so(miso)
    );
        
        
        
        
    reg [15:0]  proc_cntr = 0;
    
    reg [15:0] words_to_write [15:0];
    
    initial begin
        words_to_write[0] = 16'h01;
        words_to_write[1] = 16'h02;
        words_to_write[2] = 16'h03;
    end
    
    //test bench state machine
	always@(posedge main_clk)begin
			  case (proc_cntr)
			  
			        0: begin
                         rst <= 1'b1;
                         proc_cntr <= proc_cntr + 1;
			        end
			        1: begin
			             rst <= 1'b0;
                         proc_cntr <= proc_cntr + 1;
                    end
                    
                    //set configration first
                    2: begin
                        rw <= 0; //write operation
                        addr <= 15'hAC; //writing to slave register 0
                        data <= 16'hDC; //data to be written
                        divider = 16'h0002; //divider value for spi serial clock
                        cpha <= 1'b0;
                        cpol <= 1'b0;
                        burst_count <= 16'h0;
                        burst_enable <= 1'b0;
                        proc_cntr <= proc_cntr + 1;
                    end
                    3: begin
                        //if master is not busy set enable high
                        if(busy == 0)begin
                            enable <= 1;
                            $display("Enabled write");
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    4: begin
                        //once busy set enable low
                        if(busy == 1)begin
                            enable <= 0;
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    5: begin
                        //as soon as busy is low again an operation has been completed
                        if(busy == 0) begin
                            proc_cntr <= proc_cntr + 1;
                            $display("Master done writing");
                            $stop;
                        end
                    end

                    //burst write test
                    6: begin
                        rw <= 0; //write operation
                        addr <= 15'hAC; //writing to slave register 0
                        data <= words_to_write[0]; //data to be written
                        divider = 16'h0002; //divider value for spi serial clock
                        proc_cntr <= proc_cntr + 1;
                        burst_count <= 1; 
                        burst_enable <= 1;
                        burst_count <= 16'h2;
                        burst_enable <= 1'b1;
                    end
                    7:begin
                        //if master is not busy set enable high
                        if(busy == 0)begin
                            enable <= 1;
                            $display("Enabled write");
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    8:begin
                        if(busy == 1)begin
                            proc_cntr <= proc_cntr + 1;
                            enable <= 0;
                            burst_enable <= 0;
                        end
                    end
                   //if master requests a new word, feed new word
                    9: begin
                        if(burst_write_word_request == 1)begin
                            proc_cntr <= proc_cntr +1;
                            data <= words_to_write[1];
                        end
                    end
                    10: begin
                        if(burst_write_word_request == 0)begin
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    11: begin
                        if(busy == 0)begin
                            $display("Burst write complete");
                            $stop;
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    
                    //setup parameters
                    12:begin
                        rw <= 1; //read operation
                        addr <= 15'hAC; //writing to slave register 0
                        data <= 16'hFFFF; //data to be written
                        divider = 16'h0001; //divider value for spi serial clock
                        proc_cntr <= proc_cntr + 1;
                        burst_count <= 16'h3; 
                        burst_enable <= 1'b1; //enable burst
                    end
                    13:begin
                        //start the capture fsm
                        if(burst_read_capture_busy == 0)begin
                            burst_read_capture_start <= 1;
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    14: begin
                        if(burst_read_capture_busy == 1)begin
                            burst_read_capture_start <= 0;
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    15: begin
                        if(busy == 0)begin
                            enable <= 1;
                            $display("Enabled burst read");
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    16: begin
                        if(busy == 1)begin
                            enable <= 0;
                            proc_cntr <= proc_cntr + 1;
                        end
                    end
                    17: begin
                        if(busy == 0)begin
                            $display("Burst read complete!");
                            $stop;
                        end
                    end
                    


					
			  endcase 
	
	end
    
endmodule
