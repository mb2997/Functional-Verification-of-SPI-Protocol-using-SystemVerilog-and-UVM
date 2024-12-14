`ifndef SPI_SLAVE_REACTIVE_AGENT
`define SPI_SLAVE_REACTIVE_AGENT

class spi_slave_reactive_agent extends uvm_monitor;

    `uvm_component_utils(spi_slave_reactive_agent)

    spi_slave_seqr seqr_hs;
    spi_slave_drv drv_hs;
    spi_slave_mon mon_hs;
    spi_slave_config config_hs;
    virtual spi_inf vif;

    function new(string name = "spi_slave_reactive_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        $display("------- Executing Build-Phase in Agent ---------");
        super.build_phase(phase);
        if(!uvm_config_db #(spi_slave_config) :: get(this,"","spi_slave_config",config_hs))
            `uvm_fatal(get_type_name(), "Failed to get spi_config... Have you set it ?")

        if(!uvm_config_db #(virtual spi_inf) :: get(this,"","spi_inf",vif))
            `uvm_fatal(get_type_name(), "Failed to get vif... Have you set it ?")
        
        mon_hs = spi_slave_mon :: type_id :: create("mon_hs",this);

        if(config_hs.is_active == UVM_ACTIVE)
        begin
            $display("-------------------*************-----------------------");
            drv_hs = spi_slave_drv :: type_id :: create("drv_hs",this);
            seqr_hs = spi_slave_seqr :: type_id :: create("seqr_hs",this);
        end
        $display("------ Execution Done Build-Phase in Agent -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("------- Executing Connect-Phase in Agent ---------");
        if(config_hs.is_active == UVM_ACTIVE)
        begin
            drv_hs.seq_item_port.connect(seqr_hs.seq_item_export);
            drv_hs.vif = vif;
            mon_hs.vif = vif;
        end
        mon_hs.item_request_port.connect(seqr_hs.item_request_export.analysis_export);
        $display("------- Execution Completed of Connect-Phase in Agent ---------");
    endfunction

endclass : spi_slave_reactive_agent

`endif