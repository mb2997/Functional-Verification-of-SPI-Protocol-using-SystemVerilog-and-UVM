import spi_pkg::*;

module spi_top();

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    bit sclk;
    spi_inf inf();
    spi_base_test test_hm;

initial
begin
    uvm_config_db#(virtual spi_inf) :: set(null,"*","spi_inf",inf);
    run_test("spi_base_test");  
end

endmodule : spi_top