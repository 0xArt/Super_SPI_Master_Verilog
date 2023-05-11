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
module spi_master #(parameter DATA_WIDTH = 16, parameter ADDRESS_WIDTH = 15)
(
    input   wire                            clock,
    input   wire                            reset_n,
    input   wire    [DATA_WIDTH-1:0]        data,
    input   wire    [ADDRESS_WIDTH-1:0]     address,
    input   wire                            read_write,
    input   wire                            enable,
    input   wire                            burst_enable,
    input   wire    [15:0]                  burst_count,
    input   wire    [15:0]                  divider,
    input   wire                            clock_phase,
    input   wire                            clock_polarity,
    input   wire                            master_in_slave_out,

    output  reg                             serial_clock,
    output  reg  [DATA_WIDTH-1:0]           read_data,
    output  reg                             busy,
    output  reg                             slave_select,
    output  reg                             master_out_slave_in,
    output  reg [DATA_WIDTH+ADDR_WIDTH:0]   read_long_data,
    output  reg                             burst_data_valid,
    output  reg                             burst_data_ready
);

typedef enum
{
    S_IDLE,
    S_SET_SS,
    S_TRANSMIT_ADDRESS,
    S_TRANSMIT_DATA,
    S_UPDATE_TABLE,
    S_READ_DATA,
    S_STOP
} state_type;


state_type                                      _state;
state_type                                      state;
logic                                           _serial_clock;
logic       [DATA_WIDTH-1:0]                    _read_data;
logic                                           _busy;
logic                                           _slave_select;
logic                                           _master_out_slave_in;
logic       [DATA_WIDTH+ADDR_WIDTH:0]           _read_long_data;
logic                                           _burst_data_valid;
logic                                           _burst_data_ready;


endmodule