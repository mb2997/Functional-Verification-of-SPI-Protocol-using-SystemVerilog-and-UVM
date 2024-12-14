`include "spi_inf.sv"

package spi_pkg;

    int no_of_trans = 3;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "spi_defs.sv"
    `include "spi_master_config.sv"
    `include "spi_slave_config.sv"

    `include "spi_master_trans.sv"
    `include "spi_slave_trans.sv"
    
    `include "spi_master_seqr.sv"
    `include "spi_slave_seqr.sv"
    
    `include "spi_master_seqs.sv"
    `include "spi_slave_seqs.sv"
    `include "spi_rw_b2b_mseqs_tc1.sv"
    `include "spi_rw_mseqs_tc2.sv"
    `include "spi_msb_lsb_mseqs_tc3.sv"
    `include "spi_lsb_msb_mseqs_tc4.sv"
    
    `include "spi_master_mon.sv"
    `include "spi_slave_mon.sv"

    `include "spi_master_drv.sv"
    `include "spi_slave_drv.sv"

    `include "spi_master_agent.sv"
    `include "spi_slave_reactive_agent.sv"

    `include "spi_sb.sv"

    `include "spi_env.sv"

    `include "spi_base_test.sv"
    `include "spi_rw_b2b_tc1.sv"
    `include "spi_rw_tc2.sv"
    `include "spi_msb_lsb_tc3.sv"
    `include "spi_lsb_msb_tc4.sv"
    
endpackage