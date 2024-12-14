`ifndef SPI_MASTER_CONFIG
`define SPI_MASTER_CONFIG

class spi_master_config extends uvm_object;

    `uvm_object_utils(spi_master_config)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    bit initial_clk_set = 0;

    /*
    mode_0 : Initial Clock = 0
	         Data Sampled at Posedge

    mode_1 : Initial Clock = 0
	         Data Sampled at Negedge

    mode_2 : Initial Clock = 1
	         Data Sampled at Posedge

    mode_3 : Initial Clock = 1
	         Data Sampled at Negedge
    */
    enum bit [1:0] {MODE_0,MODE_1,MODE_2,MODE_3} select_mode_driver;

    /*
    mode_p : Data Sampled from interface at Posedge (If data drives on negedge)
    mode_n : Data Sampled from interface at Negedge (If data drives on posedge)
    */
    //string select_mode_monitor = "mode_p";

    //0 - LSB to MSB, 1 - MSB to LSB
    bit select_lsb_msb = 0;
    
    function new(string name = "spi_master_config");
        super.new(name);
    endfunction

endclass : spi_master_config

`endif