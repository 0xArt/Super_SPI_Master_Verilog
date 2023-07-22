`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
// 
// Create Date: 07/21/2021
// Design Name: 
// Module Name: spi_slave_sim_model
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
module spi_slave_sim_model(
    input   wire    clock,
    input   wire    reset_n,
    input   wire    serial_clock,
    input   wire    chip_select,

    output  wire    serial_out
);

reg so = 0;
assign o_so = (i_cs == 0) ? so : 1'bZ;


logic           _serial_data;
reg             serial_data;
logic           _serial_clock_delay;
reg     [2:0]   serial_clock_delay;
logic           serial_clock_positive_edge;
logic           serial_clock_negative_edge;
reg     [4:0]   counter;
logic   [4:0]   _counter;
wire    [31:0]  data = 32'hACDC1112;

assign  serial_out  =   (!chip_select) ? serial_data : 1'bZ;

always_comb begin
    _counter                =   counter;
    _serial_data            =   serial_data;
    _serial_clock_delay[0]  =   serial_clock;
    _serial_clock_delay[1]  =   serial_clock_delay[0];
    _serial_clock_delay[2]  =   serial_clock_delay[1];

    serial_clock_positive_edge  =   !serial_clock_delay[1] && serial_clock_delay[0];
    serial_clock_negative_edge  =   serial_clock_delay[1]  && !serial_clock_delay[0];

    if (!chip_select) begin
        _serial_out         =   data[counter];
        if (serial_clock_positive_edge) begin
            _counter    =   counter + 1;
        end
    end
end

always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
        serial_data         <=  0;
        serial_clock_delay  <=  0;
        counter             <=  31;
        serial_data         <=  0;
    end
    else begin
        serial_data         <=  _serial_data;
        serial_clock_delay  <=  _serial_clock_delay;
        counter             <=  _counter;
        serial_data         <=  _serial_data;
    end
end

endmodule