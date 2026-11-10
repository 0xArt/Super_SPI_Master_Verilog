//////////////////////////////////////////////////////////////////////////////////
// Company:       www.circuitden.com
// Engineer:      Artin Isagholian
//                artinisagholian@gmail.com
//
// Create Date:   11/09/2026
// Design Name:
// Module Name:   case_005
// Project Name:
// Target Devices:
// Tool versions:
// Description:   With clock polarity one, the serial clock must idle high through
//                and out of reset. The master used to reset its saved polarity to
//                zero, so the serial clock sat low during reset and then rose once
//                reset released, a spurious edge at the wrong idle level.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef _case_005_svh_
`define _case_005_svh_

task case_005();
    integer wrong_level_count;
    $display("Running case 005");
    $display(" Resetting the master with clock polarity one");
    @(posedge testbench.clock);
    testbench.clock_polarity    = 1;
    repeat (4) @(posedge testbench.clock);
    $display("Asserting reset");
    testbench.reset_n           = 0;
    @(posedge testbench.clock);
    wrong_level_count           = 0;
    repeat (8) begin
        @(negedge testbench.clock);
        if (testbench.spi_master_serial_clock !== 1) begin
            wrong_level_count = wrong_level_count + 1;
        end
    end
    $display("Releasing reset");
    testbench.reset_n           = 1;
    repeat (8) begin
        @(negedge testbench.clock);
        if (testbench.spi_master_serial_clock !== 1) begin
            wrong_level_count = wrong_level_count + 1;
        end
    end
    assert (wrong_level_count == 0) $display ("Serial clock held its idle level through reset");
        else $error("Serial clock was not at the clock polarity one idle level for %0d samples around reset", wrong_level_count);
    testbench.clock_polarity    = 0;
endtask: case_005

`endif
