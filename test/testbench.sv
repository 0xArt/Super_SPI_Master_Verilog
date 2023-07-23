`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
// 
// Create Date:    07/21/2023
// Design Name: 
// Module Name:    testbench
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "./case_000/case_000.svh"
`include "./case_001/case_001.svh"
module testbench;

localparam  DATA_WIDTH      =   16;
localparam  ADDRESS_WIDTH   =   15;

real            clock_delay_50      = ((1/ (50e6))/2)*(1e9);
reg             clock               = 0;
reg             reset_n             = 1;
reg             enable              = 0;
reg             rw                  = 0;
reg     [7:0]   reg_addr            = 0;
reg     [14:0]  address             = 15'b001_0001_0001_0001;
reg     [15:0]  divider             = 16'h0003;
reg     [15:0]  data_to_write       = 16'h00;


wire                                    spi_master_clock;
wire                                    spi_master_reset_n;
wire    [DATA_WIDTH-1:0]                spi_master_data;
wire    [ADDRESS_WIDTH-1:0]             spi_master_address;
wire                                    spi_master_read_write;
wire                                    spi_master_enable;
wire                                    spi_master_burst_enable;
wire    [15:0]                          spi_master_burst_count;
wire    [15:0]                          spi_master_divider;
wire                                    spi_master_clock_phase;
wire                                    spi_master_clock_polarity;
wire                                    spi_master_master_in_slave_out;

wire                                    spi_master_serial_clock;
wire    [DATA_WIDTH-1:0]                spi_master_read_data;
wire                                    spi_master_busy;
wire                                    spi_master_slave_select;
wire                                    spi_master_master_out_slave_in;
wire    [DATA_WIDTH+ADDRESS_WIDTH:0]    spi_master_read_long_data;
wire                                    spi_master_burst_data_valid;
wire                                    spi_master_burst_data_ready;


spi_master #(.DATA_WIDTH(DATA_WIDTH),.ADDRESS_WIDTH(ADDRESS_WIDTH))
spi_master(
    .clock                  (spi_master_clock),
    .reset_n                (spi_master_reset_n),
    .data                   (spi_master_data),
    .address                (spi_master_address),
    .read_write             (spi_master_read_write),
    .enable                 (spi_master_enable),
    .burst_enable           (spi_master_burst_enable),
    .burst_count            (spi_master_burst_count),
    .divider                (spi_master_divider),
    .clock_phase            (spi_master_clock_phase),
    .clock_polarity         (spi_master_clock_polarity),
    .master_in_slave_out    (spi_master_master_in_slave_out),

    .serial_clock           (spi_master_serial_clock),
    .read_data              (spi_master_read_data),
    .busy                   (spi_master_busy),
    .slave_select           (spi_master_slave_select),
    .master_out_slave_in    (spi_master_master_out_slave_in),
    .read_long_data         (spi_master_read_long_data),
    .burst_data_valid       (spi_master_burst_data_valid),
    .burst_data_ready       (spi_master_burst_data_ready)
);


wire    spi_slave_sim_model_clock;
wire    spi_slave_sim_model_reset_n;
wire    spi_slave_sim_model_serial_clock;
wire    spi_slave_sim_model_chip_select;
wire    spi_slave_sim_model_serial_in;

wire    spi_slave_sim_model_serial_out;

spi_slave_sim_model spi_slave_sim_model(
    .clock                  (spi_slave_sim_model_clock),
    .reset_n                (spi_slave_sim_model_reset_n),
    .serial_clock           (spi_slave_sim_model_serial_clock),
    .chip_select            (spi_slave_sim_model_chip_select),
    .serial_in              (spi_slave_sim_model_serial_in),

    .serial_out             (spi_slave_sim_model_serial_out)
);


//clock generation
always begin
    #clock_delay_50;
    clock   = ~clock;
end


initial begin
    @(posedge clock)
    reset_n = 1;
    #100;
    @(posedge clock)
    reset_n = 0;
    #100;
    @(posedge clock)
    reset_n = 1;
    #100;

    $display("Running case 000");
    case_000();

    $display("Running case 001");
    case_001();

    $display("Tests have finsihed");
    $stop();
end


assign spi_master_clock                 =   clock;
assign spi_master_reset_n               =   reset_n;
assign spi_master_data                  =   data_to_write;
assign spi_master_address               =   address;
assign spi_master_read_write            =   rw;
assign spi_master_enable                =   enable;
assign spi_master_burst_enable          =   0;
assign spi_master_burst_count           =   0;
assign spi_master_divider               =   divider;
assign spi_master_clock_phase           =   0;
assign spi_master_clock_polarity        =   0;
assign spi_master_master_in_slave_out   =   spi_slave_sim_model_serial_out;

assign spi_slave_sim_model_clock        =   clock;
assign spi_slave_sim_model_reset_n      =   reset_n;
assign spi_slave_sim_model_serial_in    =   spi_master_master_out_slave_in;
assign spi_slave_sim_model_serial_clock =   spi_master_serial_clock;
assign spi_slave_sim_model_chip_select  =   spi_master_slave_select;


endmodule