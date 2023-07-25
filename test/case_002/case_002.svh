//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   7/23/2020
// Design Name:
// Module Name:    case_002
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
`ifndef _case_002_svh_
`define _case_002_svh_

task case_002();
    $display("Doing a burst write of size three starting from address h7777");
    $display("Configuring master");
    @(posedge testbench.clock);
    testbench.rw                = 0;            //write operation
    testbench.address           = 15'h7777;
    testbench.data_to_write     = 16'hBEEF;
    testbench.divider           = 16'h03;       //divider value for serial clock
    testbench.burst_count       = 16'h03;       //triple round burst
    testbench.burst_enable      = 16'h01;
    @(posedge testbench.clock);
    $display("Enabling master");
    testbench.enable        = 1;
    @(posedge testbench.spi_master_busy);
    $display("Master has started reading");
    testbench.enable        = 0;
    @(posedge testbench.spi_master_burst_data_ready);
    testbench.data_to_write     = 16'hF00D;
    @(posedge testbench.spi_master_burst_data_ready);
    testbench.data_to_write     = 16'hACDC;
    @(negedge testbench.spi_master_burst_data_ready);
    assert (testbench.spi_slave_sim_model.read_data == 32'hBEEFF00D) $display ("Slaved received correct data from master");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", 16'hBEEFF00D, testbench.spi_slave_sim_model.read_data);
    @(negedge testbench.spi_master_busy);
    $display("Master has finsihed reading");
    assert (testbench.spi_slave_sim_model.read_data == 32'hF00DACDC) $display ("Slaved received correct data from master");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", 32'hF00DACDC, testbench.spi_slave_sim_model.read_data);
    assert (testbench.spi_master.read_shift_register == 32'hACDC1112) $display ("Mater received correct data from slave");
        else $error("The data master read does not match what the slave put out. Expected %h but got %h", 32'hACDC1112, testbench.spi_slave_sim_model.read_data);
endtask: case_002

`endif