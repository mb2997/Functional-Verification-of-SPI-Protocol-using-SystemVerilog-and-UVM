`ifndef SPI_BASE_TEST
`define SPI_BASE_TEST

class spi_base_test extends uvm_test;

    `uvm_component_utils(spi_base_test)

    spi_env env_hm;
    spi_master_seqs seqs_hm;
    spi_slave_seqs seqs_hs;
    spi_master_config config_hm;
    spi_slave_config config_hs;

    function new(string name = "spi_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        config_hm = spi_master_config :: type_id :: create("config_hm");
        config_hs = spi_slave_config :: type_id :: create("config_hs");
        env_hm = spi_env :: type_id :: create("env_hm",this);
        seqs_hm = spi_master_seqs :: type_id :: create("seqs_hm",this);
        seqs_hs = spi_slave_seqs :: type_id :: create("seqs_hs",this);
        config_hm.is_active = UVM_ACTIVE;
        config_hm.select_mode_driver = config_hm.MODE_0;
        uvm_config_db #(spi_master_config) :: set(this,"*","spi_master_config",config_hm);
        uvm_config_db #(spi_slave_config) :: set(this,"*","spi_slave_config",config_hs);
        $display("------ Execution Done Build-Phase in Test -------");
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
        $display("------ Execution Done End-of_ELB in Test -------");
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            seqs_hm.start(env_hm.agent_hm.seqr_hm);
            seqs_hs.start(env_hm.agent_hs.seqr_hs);
        join_any
        if(config_hm.is_active == UVM_PASSIVE)
        begin
            #3000;
        end
        phase.drop_objection(this);
        $display("------ Execution Done Run-Phase in Test -------");
    endtask

endclass : spi_base_test

`endif