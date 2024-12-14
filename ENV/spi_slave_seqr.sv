`ifndef SPI_SLAVE_SEQR
`define SPI_SLAVE_SEQR

class spi_slave_seqr extends uvm_sequencer #(spi_slave_trans);

    `uvm_component_utils(spi_slave_seqr)

    uvm_tlm_analysis_fifo #(spi_slave_trans) item_request_export;

    function new(string name = "spi_slave_seqr", uvm_component parent = null);
        super.new(name,parent);
        item_request_export = new("item_request_export",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

endclass : spi_slave_seqr

`endif