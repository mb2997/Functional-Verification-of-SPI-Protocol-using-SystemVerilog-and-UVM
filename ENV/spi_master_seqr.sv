`ifndef SPI_MASTER_SEQR
`define SPI_MASTER_SEQR

class spi_master_seqr extends uvm_sequencer #(spi_master_trans);

    `uvm_component_utils(spi_master_seqr)

    function new(string name = "spi_master_seqr", uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass : spi_master_seqr

`endif