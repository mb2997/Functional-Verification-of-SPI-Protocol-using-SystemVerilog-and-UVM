`ifndef SPI_RW_B2B_TC1
`define SPI_RW_B2B_TC1

class spi_rw_b2b_tc1 extends spi_base_test;

    `uvm_component_utils(spi_rw_b2b_tc1)
    spi_rw_b2b_mseqs_tc1 mseqs_tc1;

    function new(string name = "spi_rw_b2b_tc1", uvm_component parent = null);
        super.new(name,parent);
        mseqs_tc1 = new();
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            mseqs_tc1.start(env_hm.agent_hm.seqr_hm);
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

endclass : spi_rw_b2b_tc1

`endif