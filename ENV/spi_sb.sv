`ifndef SPI_SB
`define SPI_SB

class spi_sb extends uvm_scoreboard;

    `uvm_component_utils(spi_sb)

    spi_slave_trans trans_hs;
    spi_master_trans trans_hm;


    uvm_tlm_analysis_fifo #(spi_master_trans) mmon_analysis_fifo;
    uvm_tlm_analysis_fifo #(spi_slave_trans) smon_analysis_fifo;

    function new(string name = "spi_sb", uvm_component parent = null);
        super.new(name,parent);
        mmon_analysis_fifo = new("mmon_analysis_fifo",this);
        smon_analysis_fifo = new("smon_analysis_fifo",this);
    endfunction

    task run_phase(uvm_phase phase);
        forever
        begin
            trans_hs = spi_slave_trans :: type_id :: create("trans_hs",this);
            trans_hm = spi_master_trans :: type_id :: create("trans_hm",this);
            smon_analysis_fifo.get(trans_hs);
            `uvm_info(get_type_name(),$sformatf("\nSlave-Monitor to Scoreboard\n%s",trans_hs.sprint()),UVM_MEDIUM)
            mmon_analysis_fifo.get(trans_hm);
            `uvm_info(get_type_name(),$sformatf("\nMaster-Monitor to Scoreboard\n%s",trans_hm.sprint()),UVM_MEDIUM)
        end
    endtask

endclass : spi_sb

`endif