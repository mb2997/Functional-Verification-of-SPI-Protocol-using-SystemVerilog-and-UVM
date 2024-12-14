`ifndef SPI_MSB_LSB_TC3
`define SPI_MSB_LSB_TC3

class spi_msb_lsb_tc3 extends spi_base_test;

    `uvm_component_utils(spi_msb_lsb_tc3)
    spi_msb_lsb_mseqs_tc3 mseqs_tc3;

    function new(string name = "spi_msb_lsb_tc3", uvm_component parent = null);
        super.new(name,parent);
        mseqs_tc3 = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        config_hm = spi_master_config :: type_id :: create("config_hm");
        config_hs = spi_slave_config :: type_id :: create("config_hs");
        seqs_hm = spi_master_seqs :: type_id :: create("seqs_hm",this);
        seqs_hs = spi_slave_seqs :: type_id :: create("seqs_hs",this);
        config_hm.is_active = UVM_ACTIVE;
        config_hm.select_lsb_msb = 1;
        uvm_config_db #(spi_master_config) :: set(this,"*","spi_master_config",config_hm);
        uvm_config_db #(spi_slave_config) :: set(this,"*","spi_slave_config",config_hs);
        $display("------ Execution Done Build-Phase in Test -------");
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            mseqs_tc3.start(env_hm.agent_hm.seqr_hm);
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

endclass : spi_msb_lsb_tc3

`endif