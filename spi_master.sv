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
reg         [7:0]                               process_counter;
logic       [7:0]                               _process_counter;
reg         [7:0]                               bit_counter;
logic       [7:0]                               _bit_counter;
reg                                             saved_clock_phase;
logic                                           _saved_clock_phase;
reg                                             saved_clock_polarity;
logic                                           _saved_clock_polarity;
reg                                             saved_read_write;
logic                                           _saved_read_write;
reg         [15:0]                              saved_burst_count;
logic       [15:0]                              _saved_burst_count;
reg         [15:0]                              divider_counter;
logic       [15:0]                              _divider_counter;
reg                                             divider_tick;
logic                                           _divider_tick;


always_comb begin
    _state                  =   state;
    _process_counter        =   process_counter;
    _serial_clock           =   serial_clock;
    _read_data              =   read_data;
    _busy                   =   busy;
    _slave_select           =   slave_select;
    _master_out_slave_in    =   master_out_slave_in;
    _bit_counter            =   bit_counter;
    _saved_clock_phase      =   saved_clock_phase;
    _saved_clock_polarity   =   saved_clock_polarity;
    _saved_read_write       =   saved_read_write;
    _saved_burst_count      =   saved_burst_count;
    _divider_counter        =   divider_counter;
    _divider_tick           =   divider_tick;

    if (divider_counter == divider) begin
        _divider_counter    =   0;
        divider_tick        =   1;
    end
    else begin
        _divider_counter    =   divider_counter + 1;
        divider_tick        =   0;
    end

    case (state)
        S_IDLE: begin

        end
    endcase

end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        state                           <=  S_IDLE;
        process_counter                 <=  0;
        serial_clock                    <=  0;
        read_data                       <=  0;
        busy                            <=  0;
        slave_select                    <=  0;
        master_out_slave_in             <=  0;
        bit_counter                     <=  0;
        saved_clock_phase               <=  0;
        saved_clock_polarity            <=  0;
        divider_counter                 <=  0;
        divider_tick                    <=  0;
        saved_read_write                <=  0;
        saved_burst_count               <=  0;
    end
    else begin
        state                           <=  _state;
        process_counter                 <=  _process_counter;
        serial_clock                    <=  _serial_clock;
        read_data                       <=  _read_data;
        busy                            <=  _busy;
        slave_select                    <=  _slave_select;
        master_out_slave_in             <=  _master_out_slave_in;
        bit_counter                     <=  _bit_counter;
        saved_clock_phase               <=  _saved_clock_phase;
        saved_clock_polarity            <=  _saved_clock_polarity;
        divider_counter                 <=  _divider_counter;
        divider_tick                    <=  _divider_tick;
        saved_read_write                <=  _saved_read_write;
        saved_burst_count               <=  _saved_burst_count;
    end
end


endmodule