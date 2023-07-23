`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     www.circuitden.com
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
// 
// Create Date: 07/22/2023
// Design Name: 
// Module Name: spi_burst_receiver
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
module spi_burst_receiver(
    input   wire            clock,
    input   wire            reset_n,
    input   wire            enable,
    input   wire    [15:0]  burst_count,
    input   wire            burst_data_enable,
    input   wire    [15:0]  burst_data,

    output  reg             busy,
    output  reg             data_valid,
    output  reg     [15:0]  memory_address,
    output  reg     [15:0]  data
);

typedef enum
{
    S_IDLE,
    S_CAPTURE,
    S_DONE
} state_type;

state_type      _state;
state_type      state;
reg     [15:0]  counter;
logic   [15:0]  _counter;
reg     [2:0]   burst_data_enable_delay;
logic   [2:0]   _burst_data_enable_delay;
reg             burst_data_valid_positive_edge;
logic           _busy;
logic           _data_valid;
logic   [15:0]  _memory_address;
logic   [15:0]  _data;

always_comb begin
    _busy                           =   busy;
    _data                           =   data;
    _counter                        =   counter;
    _burst_data_enable_delay[0]     =   burst_data_enable;
    _burst_data_enable_delay[1]     =   burst_data_enable_delay[0];
    _burst_data_enable_delay[2]     =   burst_data_enable_delay[1];
    burst_data_valid_positive_edge  =   burst_data_enable_delay[1] && !burst_data_enable_delay[2];
    _data_valid                     =   0;

    if (data_valid) begin
        _memory_address = memory_address + 1;
    end
    else begin
        _memory_address                 =   memory_address;
    end

    case (state)
        S_IDLE: begin
            _memory_address = 0;

            if (enable) begin
                _counter    =   burst_count;
                _busy       =   1;
                _state      =   S_CAPTURE;
            end
        end
        S_CAPTURE: begin
            if (burst_data_valid_positive_edge) begin
                _data       = burst_data;
                _data_valid =   1;
                _counter    =   counter - 1;
            end

            if (counter == 0) begin
                _busy  = 0;
                _state = S_IDLE;
            end
        end
    endcase

end
    
always_ff @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
        state                           <=  S_IDLE;
        counter                         <=  0;
        burst_data_enable_delay         <=  0;
        memory_address                  <=  0;
        busy                            <=  0;
        data_valid                      <=  0;
    end
    else begin
        state                           <=  _state;
        counter                         <=  _counter;
        burst_data_enable_delay         <=  _burst_data_enable_delay;
        memory_address                  <=  _memory_address;
        busy                            <=  _busy;
        data_valid                      <=  _data_valid;
    end
end

endmodule