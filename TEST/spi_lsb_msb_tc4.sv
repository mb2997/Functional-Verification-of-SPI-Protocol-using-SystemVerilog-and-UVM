`ifndef SPI_LSB_MSB_TC4
`define SPI_LSB_MSB_TC4

class spi_lsb_msb_tc4 extends spi_base_test;

    `uvm_component_utils(spi_lsb_msb_tc4)
    spi_lsb_msb_mseqs_tc4 mseqs_tc4;

    function new (string name = "spi_lsb_msb_tc4", uvm_component parent = null);
        super.new(name,parent);
        mseqs_tc4 = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        config_hm = spi_master_config :: type_id :: create("config_hm");
        config_hs = spi_slave_config :: type_id :: create("config_hs");
        seqs_hm = spi_master_seqs :: type_id :: create("seqs_hm",this);
        seqs_hs = spi_slave_seqs :: type_id :: create("seqs_hs",this);
        config_hm.is_active = UVM_ACTIVE;
        config_hm.select_lsb_msb = 0;
        
        uvm_config_db #(spi_master_config) :: set(this,"*","spi_master_config",config_hm);
        uvm_config_db #(spi_slave_config) :: set(this,"*","spi_slave_config",config_hs);
        $display("------ Execution Done Build-Phase in Test -------");
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            mseqs_tc4.start(env_hm.agent_hm.seqr_hm);
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

endclass : spi_lsb_msb_tc4

`endif