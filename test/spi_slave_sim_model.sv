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
    input   wire    serial_in,
    input   wire    clock_polarity,
    input   wire    clock_phase,

    output  wire    serial_out,
    output  reg     read_data_valid
);


logic           _serial_data;
reg             serial_data;
logic   [2:0]   _serial_clock_delay;
reg     [2:0]   serial_clock_delay;
logic           serial_clock_positive_edge;
logic           serial_clock_negative_edge;
reg     [4:0]   counter;
logic   [4:0]   _counter;
wire    [31:0]  data;
logic   [31:0]  _read_data;
reg     [31:0]  read_data;
reg             skip;
logic           _skip;
logic           _read_data_valid;

assign  serial_out      =   (!chip_select) ? serial_data : 1'bZ;
assign  data            =   32'hACDC1112;

always_comb begin
    _counter                    =   counter;
    _serial_data                =   data[counter];
    _serial_clock_delay[0]      =   serial_clock;
    _serial_clock_delay[1]      =   serial_clock_delay[0];
    _serial_clock_delay[2]      =   serial_clock_delay[1];
    _skip                       =   skip;
    _read_data                  =   read_data;
    serial_clock_positive_edge  =   !serial_clock_delay[1] && serial_clock_delay[0];
    serial_clock_negative_edge  =   serial_clock_delay[1]  && !serial_clock_delay[0];
    _read_data_valid            =   0;

    if (!chip_select) begin
        if (clock_polarity == 0) begin
            if (clock_phase == 0) begin
                if (serial_clock_positive_edge) begin
                    _read_data = {read_data[30:0], serial_in};

                    if (counter == 16 || counter == 0) begin
                        _read_data_valid = 1;
                    end
                end
                if (serial_clock_negative_edge) begin
                    _counter    =   counter - 1;
                end
            end
            else begin
                if (serial_clock_negative_edge) begin
                    _read_data = {read_data[30:0], serial_in};

                    if (counter == 16 || counter == 0) begin
                        _read_data_valid = 1;
                    end
                end
                if (serial_clock_positive_edge) begin
                    if (skip) begin
                        _skip = 0;
                    end
                    else begin
                        _counter    =   counter - 1;
                    end
                end
            end
        end

        if (clock_polarity == 1) begin
            if (clock_phase == 0) begin
                if (serial_clock_negative_edge) begin
                    _read_data = {read_data[30:0], serial_in};

                    if (counter == 16 || counter == 0) begin
                        _read_data_valid = 1;
                    end
                end
                if (serial_clock_positive_edge) begin
                    _counter    =   counter - 1;
                end
            end
            else begin
                if (serial_clock_positive_edge) begin
                    _read_data = {read_data[30:0], serial_in};

                    if (counter == 16 || counter == 0) begin
                        _read_data_valid = 1;
                    end

                end
                if (serial_clock_negative_edge) begin
                    if (skip) begin
                        _skip       =   0;
                    end
                    else begin
                        _counter    =   counter - 1;
                    end
                end
            end
        end
    end
    else begin
        _skip       = 1;
        _counter    = 31;
    end
end

always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
        serial_data         <=  0;
        serial_clock_delay  <=  0;
        counter             <=  31;
        serial_data         <=  0;
        read_data           <=  0;
        skip                <=  1;
        read_data_valid     <=  0;
    end
    else begin
        serial_data         <=  _serial_data;
        serial_clock_delay  <=  _serial_clock_delay;
        counter             <=  _counter;
        serial_data         <=  _serial_data;
        read_data           <=  _read_data;
        skip                <=  _skip;
        read_data_valid     <=  _read_data_valid;
    end
end

endmodule