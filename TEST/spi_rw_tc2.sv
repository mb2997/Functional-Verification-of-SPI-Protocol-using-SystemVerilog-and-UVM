`ifndef SPI_RW_TC2
`define SPI_RW_TC2

class spi_rw_tc2 extends spi_base_test;

    `uvm_component_utils(spi_rw_tc2)
    spi_rw_mseqs_tc2 mseqs_tc2;

    function new(string name = "spi_rw_tc2", uvm_component parent = null);
        super.new(name,parent);
        mseqs_tc2 = new();
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            mseqs_tc2.start(env_hm.agent_hm.seqr_hm);
            seqs_hs.start(env_hm.agent_hs.seqr_hs);
        join_any
        if(config_hm.is_active == UVM_PASSIVE)
        begin
            #3000;
        end
        //#100; //Add delay if required
        phase.drop_objection(this);
        $display("------ Execution Done Run-Phase in Test -------");
    endtask

endclass : spi_rw_tc2

`endif