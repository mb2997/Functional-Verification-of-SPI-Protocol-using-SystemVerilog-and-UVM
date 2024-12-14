`ifndef SPI_MASTER_MON
`define SPI_MASTER_MON

class spi_master_mon extends uvm_monitor;

    `uvm_component_utils(spi_master_mon)
    virtual spi_inf vif;

    spi_master_trans trans_hm;

    uvm_analysis_port #(spi_master_trans) master_mon2_sb;

    function new(string name = "spi_master_mon", uvm_component parent = null);
        super.new(name,parent);
        master_mon2_sb = new("master_mon2_sb",this);
    endfunction

    task data_from_inf();
        begin
            trans_hm = spi_master_trans :: type_id :: create("trans_hm");
            for(int i=0; i<$size(trans_hm.data); i++)
            begin
                @(negedge vif.sclk);
                trans_hm.data[i] = vif.miso;
                `uvm_info(get_type_name(),$sformatf("\nData-Bit Received at Master-Monitor \Data(Bit) = %b\n",trans_hm.data[i]),UVM_DEBUG)
            end
            `uvm_info(get_type_name(),$sformatf("\nData Received at Master-Monitor \nData(Hex) = %0h\n",trans_hm.data),UVM_MEDIUM)
        end
    endtask

    task data_to_sb();
        master_mon2_sb.write(trans_hm);
    endtask

    task run_phase(uvm_phase phase);
        forever
        begin
            data_from_inf();
            data_to_sb();
        end
    endtask

endclass : spi_master_mon

`endif