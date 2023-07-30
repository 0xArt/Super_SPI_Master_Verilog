//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   7/25/2020
// Design Name:
// Module Name:   case_003
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
`ifndef _case_003_svh_
`define _case_003_svh_

task case_003();
    $display("Running case 003");
    $display("Doing a burst read of size three starting from address h8888");
    $display("Configuring master");
    @(posedge testbench.clock);
    testbench.rw                = 1;            //read operation
    testbench.address           = 15'h8888;
    testbench.data_to_write     = 16'hF000;
    testbench.divider           = 16'h03;       //divider value for serial clock
    testbench.burst_count       = 16'h03;       //triple round burst
    testbench.burst_enable      = 1;
    @(posedge testbench.clock);
    $display("Enabling master");
    testbench.enable        = 1;
    @(posedge testbench.spi_master_busy);
    $display("Master has started reading");
    testbench.enable        = 0;
    testbench.burst_enable  = 0;
    @(posedge testbench.spi_master_read_data_valid);
    assert (testbench.spi_master_read_data == 16'h1112) $display ("Master received correct data from slave");
        else $error("The data master read does not match what the slave put out. Expected %h but got %h", 16'h1112, testbench.spi_master_read_data);
    @(posedge testbench.spi_master_read_data_valid);
    assert (testbench.spi_master_read_data == 16'hACDC) $display ("Master received correct data from slave");
        else $error("The data master read does not match what the slave put out. Expected %h but got %h", 16'hACDC, testbench.spi_master_read_data);
    @(posedge testbench.spi_master_read_data_valid);
    assert (testbench.spi_master_read_data == 16'h1112) $display ("Master received correct data from slave");
        else $error("The data master read does not match what the slave put out. Expected %h but got %h", 16'h1112, testbench.spi_master_read_data);
    @(negedge testbench.spi_master_busy);
    $display("Master has finished reading");
endtask: case_003

`endif