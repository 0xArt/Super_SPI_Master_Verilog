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
    input   wire                                    clock,
    input   wire                                    reset_n,
    input   wire    [DATA_WIDTH-1:0]                data,
    input   wire    [ADDRESS_WIDTH-1:0]             address,
    input   wire                                    read_write,
    input   wire                                    enable,
    input   wire                                    burst_enable,
    input   wire    [15:0]                          burst_count,
    input   wire    [15:0]                          divider,
    input   wire                                    clock_phase,
    input   wire                                    clock_polarity,
    input   wire                                    master_in_slave_out,

    output  reg                                     serial_clock,
    output  reg     [DATA_WIDTH-1:0]                read_data,
    output  reg                                     busy,
    output  reg                                     slave_select,
    output  reg                                     master_out_slave_in,
    output  reg     [DATA_WIDTH+ADDRESS_WIDTH:0]    read_long_data,
    output  reg                                     read_data_valid,
    output  reg                                     burst_data_ready
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
logic       [DATA_WIDTH+ADDRESS_WIDTH:0]        _read_long_data;
logic                                           _read_data_valid;
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
logic                                           divider_tick;
reg         [ADDRESS_WIDTH-1:0]                 saved_address;
logic       [ADDRESS_WIDTH-1:0]                 _saved_address;
reg         [DATA_WIDTH-1:0]                    saved_data;
logic       [DATA_WIDTH-1:0]                    _saved_data;
reg                                             saved_burst_enable;
logic                                           _saved_burst_enable;
reg         [DATA_WIDTH+ADDRESS_WIDTH:0]        write_shift_register;
logic       [DATA_WIDTH+ADDRESS_WIDTH:0]        _write_shift_register;
reg         [DATA_WIDTH+ADDRESS_WIDTH:0]        read_shift_register;
logic       [DATA_WIDTH+ADDRESS_WIDTH:0]        _read_shift_register;

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
    _saved_address          =   saved_address;
    _saved_data             =   saved_data;
    _saved_burst_enable     =   saved_burst_enable;
    _write_shift_register   =   write_shift_register;
    _read_shift_register    =   read_shift_register;
    _read_long_data         =   read_long_data;
    _burst_data_ready       =   burst_data_ready;
    _read_data_valid        =   0;

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
            _saved_clock_phase      =   clock_phase;
            _saved_clock_polarity   =   clock_polarity;
            _saved_read_write       =   read_write;
            _saved_burst_count      =   burst_count;
            _saved_burst_enable     =   burst_enable;
            _saved_address          =   address;
            _saved_data             =   data;
            _busy                   =   busy;
            _write_shift_register   =   write_shift_register;
            _read_shift_register    =   read_shift_register;

            if (enable) begin
                _busy   =   1;
                _state  =   S_SET_SS;
            end
        end
        S_SET_SS: begin
            if (divider_tick) begin
                _slave_select           =   0;
                _write_shift_register   =   {saved_address, saved_read_write, saved_data};
                _state                  =   S_TRANSMIT_ADDRESS;

                if (saved_clock_phase == 0) begin
                    _master_out_slave_in    =   saved_address[ADDRESS_WIDTH-1];
                end
            end
        end
        S_TRANSMIT_ADDRESS: begin
            if (divider_tick) begin
                case (process_counter)
                    0: begin
                        _process_counter    =   1;

                        if (bit_counter != 0 && saved_clock_phase == 1) begin
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                        end
                        if (bit_counter == 0 && saved_clock_phase == 0) begin
                            _write_shift_register = {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                    end
                    1: begin
                        _serial_clock       =   1;
                        _process_counter    =   2;

                        if (saved_clock_phase == 1) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                    end
                    2: begin
                        _process_counter    =   3;

                        if (saved_clock_phase == 0) begin
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                        end
                    end
                    3: begin
                        _serial_clock       =   0;
                        _process_counter    =   0;

                        if (saved_clock_phase == 0) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                        if (bit_counter == ADDRESS_WIDTH) begin
                            _bit_counter    =   0;

                            if (saved_read_write == 0) begin
                                _state  =   S_TRANSMIT_DATA;
                            end
                            else begin
                                _state  =   S_READ_DATA;
                            end
                        end
                        else begin
                            _bit_counter = bit_counter + 1;
                        end
                    end
                endcase
            end
        end
        S_TRANSMIT_DATA: begin
            if (divider_tick) begin
                case (process_counter)
                    0: begin
                        _process_counter    =   1;

                        if (bit_counter == (DATA_WIDTH - 1) && saved_burst_enable == 1 && saved_burst_count > 1) begin
                            _burst_data_ready = 1;
                        end
                        if (saved_clock_phase == 1) begin
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                        end
                    end
                    1: begin
                        _process_counter    =   2;
                        _serial_clock       =   1;

                        if (saved_clock_phase == 1) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                    end
                    2: begin
                        _process_counter    =   3;

                        if (saved_clock_phase == 0) begin
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};

                        end
                        if (burst_data_ready == 1) begin
                            _burst_data_ready                                                   = 0;
                            _write_shift_register[DATA_WIDTH+ADDRESS_WIDTH:ADDRESS_WIDTH+1]     = data;
                        end
                    end
                    3: begin
                        _process_counter    =   0;
                        _serial_clock       =   0;

                        if (saved_clock_phase == 0) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                        if (bit_counter == (DATA_WIDTH-1)) begin
                            _bit_counter    =   0;
                            if (saved_burst_enable == 1) begin
                                _saved_burst_count = saved_burst_count - 1;

                                if (saved_burst_count <= 1) begin
                                    _state = S_STOP;
                                end
                            end
                            else begin
                                _state = S_STOP;
                            end
                        end
                        else begin
                            _bit_counter = bit_counter + 1;
                        end
                    end
                endcase
            end
        end
        S_READ_DATA: begin
            if (divider_tick) begin
                case (process_counter)
                    0: begin
                        _process_counter    =   1;
                        _burst_data_ready   =   0;

                        if (saved_clock_phase == 1) begin
                            if (saved_clock_phase == 0) begin
                                _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                            end
                        end
                    end
                    1: begin
                        _process_counter    =   2;
                        _serial_clock       =   1;

                        if (saved_clock_phase == 1) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end
                    end
                    2: begin
                        _process_counter    =   3;

                        if (saved_clock_phase == 0) begin
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                        end
                    end
                    3: begin
                        _process_counter    =   0;
                        _serial_clock       =   0;

                        if (saved_clock_phase == 0) begin
                            _master_out_slave_in    =   write_shift_register[DATA_WIDTH+ADDRESS_WIDTH];
                            _write_shift_register   =   {write_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0], 1'b0};
                        end

                        if (bit_counter == DATA_WIDTH - 1) begin
                            _bit_counter    =   0;

                            if (saved_burst_enable) begin
                                _saved_burst_count  =   saved_burst_count - 1;
                                _read_long_data     = read_shift_register;
                                _read_data          = read_shift_register[DATA_WIDTH-1:0];
                                _read_data_valid    =   1;

                                if (saved_burst_count <= 1) begin
                                    _state = S_STOP;
                                end
                            end
                            else begin
                                _state  =   S_STOP;
                            end
                        end
                        else begin
                            _bit_counter    =   bit_counter + 1;
                        end
                    end
                endcase
            end
        end
        S_STOP: begin
            if (divider_tick) begin
                case (process_counter)
                    0: begin
                        _process_counter    =   1;

                        if (saved_clock_phase == 1) begin
                            //read here to meet SPI timing requirements if cpha = 1
                            _read_shift_register  = {read_shift_register[DATA_WIDTH+ADDRESS_WIDTH-1:0],master_in_slave_out};
                        end
                    end
                    1: begin
                        _read_long_data         = read_shift_register;
                        _read_data              = read_shift_register[DATA_WIDTH-1:0];
                        _read_data_valid        = 1;
                        _slave_select           = 1;
                        _master_out_slave_in    = 0;
                        _process_counter        = 2;
                    end
                    2: begin
                        _process_counter        = 3;
                    end
                    3: begin
                        _process_counter        = 0;
                        _busy                   = 0;
                        _state                  = S_IDLE;
                    end
                endcase
            end
        end
    endcase
end

always_ff @(posedge clock or negedge reset_n) begin
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
        saved_read_write                <=  0;
        saved_burst_count               <=  0;
        saved_address                   <=  0;
        saved_data                      <=  0;
        read_shift_register             <=  0;
        write_shift_register            <=  0;
        saved_burst_enable              <=  0;
        read_data_valid                 <=  0;
        read_long_data                  <=  0;
        burst_data_ready                <=  0;
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
        saved_read_write                <=  _saved_read_write;
        saved_burst_count               <=  _saved_burst_count;
        saved_address                   <=  _saved_address;
        saved_data                      <=  _saved_data;
        read_shift_register             <=  _read_shift_register;
        write_shift_register            <=  _write_shift_register;
        saved_burst_enable              <=  _saved_burst_enable;
        read_data_valid                 <=  _read_data_valid;
        read_long_data                  <=  _read_long_data;
        burst_data_ready                <=  _burst_data_ready;
    end
end


endmodule