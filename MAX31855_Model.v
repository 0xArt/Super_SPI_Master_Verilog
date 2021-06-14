`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2021 10:10:15 AM
// Design Name: 
// Module Name: MAX31855_Model
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


module MAX31855_Model(
        input wire i_system_clk,
        input wire i_sck,
        input wire i_cs,
        output wire o_so

    );

       reg so = 0;
       assign o_so = (i_cs == 0) ? so : 1'bZ;
       wire [31:0] data = 32'hACDC1112;
       reg [4:0] counter = 31;
       reg  [2:0] sck_sample = 0;
       wire i_sck_pos_edge;
       assign i_sck_pos_edge = (sck_sample[1] == 0 && sck_sample[0] == 1) ? 1 : 0;
       wire i_sck_neg_edge;
       assign i_sck_neg_edge = (sck_sample[1] == 1 && sck_sample[0] == 0) ? 1 : 0;
       reg [31:0] data_two = 32'hACDC1112;

       always @(posedge i_system_clk)begin
            sck_sample[0]      <= i_sck;
            sck_sample[1]      <= sck_sample[0];
            sck_sample[2]      <= sck_sample[1];
            if(~i_cs)begin
                so <= data_two[counter];
                if(i_sck_pos_edge)begin
                   counter <= counter - 1;
                end
            end
            else begin
                //counter <= 31;
                data_two <= data;
            end
            
       end
       
       
endmodule
