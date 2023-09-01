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
`include "./case_002/case_002.svh"
`include "./case_003/case_003.svh"
module testbench;

localparam  DATA_WIDTH              =   16;
localparam  ADDRESS_WIDTH           =   15;
localparam  CLOCK_FREQUENCY         =   50_000_000;
localparam  CLOCK_PERIOD            =   1e9/CLOCK_FREQUENCY;

reg             clock               =   0;
reg             reset_n             =   1;
reg             enable              =   0;
reg             rw                  =   0;
reg     [7:0]   reg_addr            =   0;
reg     [14:0]  address             =   15'b001_0001_0001_0001;
reg     [15:0]  divider             =   16'h0003;
reg     [15:0]  data_to_write       =   16'h00;
reg     [15:0]  burst_count         =   16'h00;
reg             burst_enable        =   0;
reg             clock_phase         =   0;
reg             clock_polarity      =   0;

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
wire                                    spi_master_read_data_valid;
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
    .read_data_valid        (spi_master_read_data_valid),
    .burst_data_ready       (spi_master_burst_data_ready)
);

wire            spi_burst_receiver_clock;
wire            spi_burst_receiver_reset_n;
wire            spi_burst_receiver_enable;
wire    [15:0]  spi_burst_receiver_burst_count;
wire            spi_burst_receiver_data_enable;
wire    [15:0]  spi_burst_receiver_burst_data;

wire            spi_burst_receiver_busy;
wire            spi_burst_reciever_data_valid;
wire    [15:0]  spi_burst_receiver_memory_address;
wire    [15:0]  spi_burst_receiver_data;

spi_burst_receiver  spi_burst_receiver(
    .clock                  (spi_burst_receiver_clock),
    .reset_n                (spi_burst_receiver_reset_n),
    .enable                 (spi_burst_receiver_enable),
    .burst_count            (spi_burst_receiver_burst_count),
    .burst_data_enable      (spi_burst_receiver_data_enable),
    .burst_data             (spi_burst_receiver_burst_data),

    .busy                   (spi_burst_receiver_busy),
    .data_valid             (spi_burst_reciever_data_valid),
    .memory_address         (spi_burst_receiver_memory_address),
    .data                   (spi_burst_receiver_data)
);


wire    spi_slave_sim_model_clock;
wire    spi_slave_sim_model_reset_n;
wire    spi_slave_sim_model_serial_clock;
wire    spi_slave_sim_model_chip_select;
wire    spi_slave_sim_model_serial_in;
wire    spi_slave_sim_model_clock_polarity;
wire    spi_slave_sim_model_clock_phase;

wire    spi_slave_sim_model_serial_out;
wire    spi_slave_sim_model_read_data_valid;

spi_slave_sim_model spi_slave_sim_model(
    .clock                  (spi_slave_sim_model_clock),
    .reset_n                (spi_slave_sim_model_reset_n),
    .serial_clock           (spi_slave_sim_model_serial_clock),
    .chip_select            (spi_slave_sim_model_chip_select),
    .serial_in              (spi_slave_sim_model_serial_in),
    .clock_polarity         (spi_slave_sim_model_clock_polarity),
    .clock_phase            (spi_slave_sim_model_clock_phase),

    .serial_out             (spi_slave_sim_model_serial_out),
    .read_data_valid        (spi_slave_sim_model_read_data_valid)
);


//clock generation
initial begin
    clock   =   0;
    forever begin
        #(CLOCK_PERIOD/2);
        clock   =   ~clock;
    end
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

    $display("Setting clock polarity to zero");
    clock_polarity  = 0;
    $display("Setting clock phase to zero");
    clock_phase     = 0;
    case_000();
    case_001();
    case_002();
    case_003();

    $display("Setting clock polarity to one");
    clock_polarity  = 1;
    $display("Setting clock phase to zero");
    clock_phase     = 0;
    case_000();
    case_001();
    case_002();
    case_003();

    $display("Setting clock polarity to zero");
    clock_polarity  = 0;
    $display("Setting clock phase to one");
    clock_phase     = 1;
    case_000();
    case_001();
    case_002();
    case_003();

    $display("Setting clock polarity to one");
    clock_polarity  = 1;
    $display("Setting clock phase to one");
    clock_phase     = 1;
    case_001();
    case_002();

    $display("Tests have finsihed");
    $stop();
end


assign spi_master_clock                     =   clock;
assign spi_master_reset_n                   =   reset_n;
assign spi_master_data                      =   data_to_write;
assign spi_master_address                   =   address;
assign spi_master_read_write                =   rw;
assign spi_master_enable                    =   enable;
assign spi_master_burst_enable              =   burst_enable;
assign spi_master_burst_count               =   burst_count;
assign spi_master_divider                   =   divider;
assign spi_master_clock_phase               =   clock_phase;
assign spi_master_clock_polarity            =   clock_polarity;
assign spi_master_master_in_slave_out       =   spi_slave_sim_model_serial_out;

assign spi_slave_sim_model_clock            =   clock;
assign spi_slave_sim_model_reset_n          =   reset_n;
assign spi_slave_sim_model_serial_in        =   spi_master_master_out_slave_in;
assign spi_slave_sim_model_serial_clock     =   spi_master_serial_clock;
assign spi_slave_sim_model_chip_select      =   spi_master_slave_select;
assign spi_slave_sim_model_clock_polarity   =   clock_polarity;
assign spi_slave_sim_model_clock_phase      =   clock_phase;

assign spi_burst_receiver_clock             =   clock;
assign spi_burst_receiver_reset_n           =   reset_n;
assign spi_burst_receiver_enable            =   burst_enable && spi_master_read_write;
assign spi_burst_receiver_burst_count       =   burst_count;
assign spi_burst_receiver_data_enable       =   spi_master_read_data_valid;
assign spi_burst_receiver_burst_data        =   spi_master_read_data;


endmodule