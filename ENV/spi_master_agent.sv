`ifndef SPI_MASTER_AGENT
`define SPI_MASTER_AGENT

class spi_master_agent extends uvm_monitor;

    `uvm_component_utils(spi_master_agent)

    spi_master_seqr seqr_hm;
    spi_master_drv drv_hm;
    spi_master_mon mon_hm;
    spi_master_config config_hm;
    virtual spi_inf vif;

    function new(string name = "spi_master_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        $display("------- Executing Build-Phase in Agent ---------");
        super.build_phase(phase);
        if(!uvm_config_db #(spi_master_config) :: get(this,"","spi_master_config",config_hm))
            `uvm_fatal(get_type_name(), "Failed to get spi_config... Have you set it ?")

        if(!uvm_config_db #(virtual spi_inf) :: get(this,"","spi_inf",vif))
            `uvm_fatal(get_type_name(), "Failed to get vif... Have you set it ?")
        
        mon_hm = spi_master_mon :: type_id :: create("mon_hm",this);

        if(config_hm.is_active == UVM_ACTIVE)
        begin
            $display("-------------------*************-----------------------");
            drv_hm = spi_master_drv :: type_id :: create("drv_hm",this);
            seqr_hm = spi_master_seqr :: type_id :: create("seqr_hm",this);
        end
        $display("------ Execution Done Build-Phase in Agent -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("------- Executing Connect-Phase in Agent ---------");
        if(config_hm.is_active == UVM_ACTIVE)
        begin
            drv_hm.seq_item_port.connect(seqr_hm.seq_item_export);
            drv_hm.vif = vif;
            mon_hm.vif = vif;
        end
        $display("------- Execution Completed of Connect-Phase in Agent ---------");
    endfunction

endclass : spi_master_agent

`endif