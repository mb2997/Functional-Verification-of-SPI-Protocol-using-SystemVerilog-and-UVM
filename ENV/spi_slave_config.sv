`ifndef SPI_SLAVE_CONFIG
`define SPI_SLAVE_CONFIG

class spi_slave_config extends uvm_object;

    `uvm_object_utils(spi_slave_config)

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    /*
    mode_p : Data Sampled from interface at Posedge (If Master drives data on negedge)
    mode_n : Data Sampled from interface at Negedge (If Master drives data on posedge)
    string select_mode_monitor = "mode_p";
    */
    
    function new(string name = "spi_slave_config");
        super.new(name);
    endfunction

endclass : spi_slave_config

`endif