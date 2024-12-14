`ifndef SPI_ENV
`define SPI_ENV

class spi_env extends uvm_env;

    `uvm_component_utils(spi_env)

    spi_master_agent agent_hm;
    spi_slave_reactive_agent agent_hs;
    spi_sb sb_hm;

    function new(string name = "spi_env", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_hm = spi_master_agent :: type_id :: create("agent_hm",this);
        agent_hs = spi_slave_reactive_agent :: type_id :: create("agent_hs",this);
        sb_hm = spi_sb :: type_id :: create("sb_hm",this);
        $display("------ Execution Done Build-Phase in ENV -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        agent_hm.mon_hm.master_mon2_sb.connect(sb_hm.mmon_analysis_fifo.analysis_export);
        agent_hs.mon_hs.slave_mon2_sb.connect(sb_hm.smon_analysis_fifo.analysis_export);
    endfunction

endclass : spi_env

`endif