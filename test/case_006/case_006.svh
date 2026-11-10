//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   11/09/2026
// Design Name:
// Module Name:   case_006
// Project Name:
// Target Devices:
// Tool versions:
// Description:   A burst write whose host misses a word boundary must end cleanly at
//                that boundary and report burst_underflow, instead of silently
//                resending the previous word. The flag must hold through idle and
//                clear when the next transaction starts.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef _case_006_svh_
`define _case_006_svh_

task case_006();
    $display("Running case 006");
    $display(" Burst write of size three from address h2222 where the host supplies only two words");
    $display("Configuring master");
    @(posedge testbench.clock);
    testbench.rw                = 0;            //write operation
    testbench.address           = 15'h2222;
    testbench.data_to_write     = 16'h1111;
    testbench.divider           = 16'h00;       //fastest serial clock, the tightest host timing
    testbench.burst_count       = 16'h03;       //triple round burst
    testbench.burst_enable      = 1;
    @(posedge testbench.clock);
    $display("Enabling master");
    testbench.enable        = 1;
    @(posedge testbench.spi_master_busy);
    $display("Master has started writing");
    testbench.enable        = 0;
    testbench.burst_enable  = 0;
    //the host is late for the second word but still inside its window: ready rises at
    //select and the word is only needed at the end of the first data word
    repeat (40) @(posedge testbench.clock);
    testbench.send_burst_word(16'h2222);
    //the third word never comes
    @(negedge testbench.spi_master_busy);
    $display("Master has finished writing");
    assert (testbench.spi_master_burst_underflow) $display ("Burst underflow was reported");
        else $error("The cut burst did not report an underflow");
    assert (testbench.spi_slave_sim_model.read_data == 32'h11112222) $display ("Slaved received the two supplied words and nothing after them");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", 32'h11112222, testbench.spi_slave_sim_model.read_data);

    repeat (20) @(posedge testbench.clock);
    assert (testbench.spi_master_burst_underflow) $display ("Burst underflow held through idle");
        else $error("The burst underflow flag did not hold through idle");

    $display("Starting a single word write, which must clear the flag");
    @(posedge testbench.clock);
    testbench.address           = 15'h3333;
    testbench.data_to_write     = 16'h4444;
    testbench.divider           = 16'h03;
    testbench.enable            = 1;
    @(posedge testbench.spi_master_busy);
    testbench.enable            = 0;
    assert (!testbench.spi_master_burst_underflow) $display ("Starting a transaction cleared the underflow flag");
        else $error("Starting a transaction did not clear the burst underflow flag");
    @(negedge testbench.spi_master_busy);
    assert (testbench.spi_slave_sim_model.read_data == {testbench.address, testbench.rw, testbench.data_to_write}) $display ("Slaved received correct data from master");
        else $error("The data slave read does not match what the master put out. Expected %h but got %h", {testbench.address, testbench.rw, testbench.data_to_write}, testbench.spi_slave_sim_model.read_data);
endtask: case_006

`endif
