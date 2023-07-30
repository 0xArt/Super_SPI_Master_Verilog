//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   7/22/2020
// Design Name:
// Module Name:   case_001
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
`ifndef _case_001_svh_
`define _case_001_svh_

task case_001();
    $display("Running case 001");
    $display(" Reading from address h7ABC");
    $display("Configuring master");
    @(posedge testbench.clock);
    testbench.rw                = 1;            //read operation
    testbench.address           = 15'h7ABC;
    testbench.data_to_write     = 16'hBEEF;
    testbench.divider           = 16'h03;       //divider value for serial clock
    @(posedge testbench.clock);
    $display("Enabling master");
    testbench.enable        = 1;
    @(posedge testbench.spi_master_busy)
    $display("Master has started reading");
    testbench.enable        = 0;
    @(negedge testbench.spi_master_busy);
    $display("Master has finsihed reading");
    assert (testbench.spi_slave_sim_model.read_data == {testbench.address, testbench.rw, testbench.data_to_write}) $display ("Slaved received correct data from master");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", {testbench.address, testbench.rw, testbench.data_to_write}, testbench.spi_slave_sim_model.read_data);
    assert (testbench.spi_master_read_long_data == 32'hACDC1112) $display ("Mater received correct data from slave");
        else $error("The data master read does not match what the slave put out. Expected %h but got %h", 32'hACDC1112, testbench.spi_slave_sim_model.read_data);
endtask: case_001

`endif