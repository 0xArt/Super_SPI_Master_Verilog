//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   11/09/2026
// Design Name:
// Module Name:   case_004
// Project Name:
// Target Devices:
// Tool versions:
// Description:   Changing the divider mid transaction must not affect the transfer.
//                The master used to compare its divider counter against the live
//                divider port, so lowering the divider below the running count sent
//                the counter through a full 16 bit wrap and stalled the wire for
//                65536 clocks.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef _case_004_svh_
`define _case_004_svh_

task case_004();
    integer start_time;
    integer duration;
    $display("Running case 004");
    $display(" Writing value 16'h1357 to address h1234 while the divider changes mid transaction");
    $display("Configuring master");
    @(posedge testbench.clock);
    testbench.rw                = 0;            //write operation
    testbench.address           = 15'h1234;
    testbench.data_to_write     = 16'h1357;
    testbench.divider           = 16'h06;       //divider value for serial clock
    testbench.burst_enable      = 0;
    @(posedge testbench.clock);
    $display("Enabling master");
    testbench.enable        = 1;
    @(posedge testbench.spi_master_busy)
    start_time              = $time;
    $display("Master has started writing");
    testbench.enable        = 0;
    repeat (40) @(posedge testbench.clock);
    $display("Lowering the divider mid transaction");
    testbench.divider       = 16'h00;
    repeat (40) @(posedge testbench.clock);
    $display("Raising the divider mid transaction");
    testbench.divider       = 16'hFFFF;
    @(negedge testbench.spi_master_busy);
    duration                = ($time - start_time) / testbench.CLOCK_PERIOD;
    $display("Master has finished writing in %0d clocks", duration);
    testbench.divider       = 16'h03;
    //32 bits at four divider ticks per bit and seven clocks per tick is 896 clocks
    assert (duration < 1500) $display ("Divider change mid transaction had no effect on the transfer");
        else $error("The transfer took %0d clocks, the master is using the live divider", duration);
    assert (testbench.spi_slave_sim_model.read_data == {testbench.address, testbench.rw, testbench.data_to_write}) $display ("Slaved received correct data from master");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", {testbench.address, testbench.rw, testbench.data_to_write}, testbench.spi_slave_sim_model.read_data);
endtask: case_004

`endif
