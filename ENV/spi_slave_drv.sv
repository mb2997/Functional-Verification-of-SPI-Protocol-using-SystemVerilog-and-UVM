`ifndef SPI_SLAVE_DRV
`define SPI_SLAVE_DRV

class spi_slave_drv extends uvm_driver #(spi_slave_trans);

    //Factory registration
    `uvm_component_utils(spi_slave_drv)
    spi_slave_trans trans_hs, trans_hs_temp;
    virtual spi_inf vif;

    event data_done;

    //Local header-bit to concatination of rw,res_bit,addr
    bit [`HDR_LEN-1:0] header;
    bit [`ADD_LEN-1:0] rd_addr;

    function new(string name = "spi_slave_drv", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task memory_model_read_logic();
        
        if(trans_hs.trans_kind_e.name == "READ")
        begin
            rd_addr = trans_hs.addr;
            `uvm_info(get_type_name(),$sformatf("Read : rd_addr = %0d",rd_addr),UVM_MEDIUM);
            if(trans_hs.mem_model.exists(rd_addr))
            begin
                trans_hs.data = trans_hs.mem_model[rd_addr];
                `uvm_info(get_type_name(),$sformatf("\n%0h Data has read from\n%0h location of memory model\n",trans_hs.data,rd_addr),UVM_MEDIUM)
            end
            else
            begin
                `uvm_info(get_type_name(),$sformatf("\nData has not written at\n%0h location of memory model\n",rd_addr),UVM_MEDIUM)   
            end
        end
        ->data_done;
    endtask

    task drive_to_master(spi_slave_trans trans_hs);
        wait(data_done.triggered);
        for(int i=0; i<$size(trans_hs.data); i++)
            begin
                @(posedge vif.sclk);
                vif.miso = trans_hs.data[i];
                `uvm_info(get_type_name(),$sformatf("\nData-Bit from Slave-Driver to MISO [i = %0d] = %b\n",i,vif.miso),UVM_DEBUG)
            end
        `uvm_info(get_type_name(),$sformatf("Data Drives from Slave-Driver to MISO\nData(Hex) = %0h",trans_hs.data),UVM_HIGH)
    endtask

    task run_phase(uvm_phase phase);
        forever
            begin
                `uvm_info(get_type_name(),"\nRequest from get_next_item.....................\n",UVM_MEDIUM)
                seq_item_port.get_next_item(trans_hs);
                $display("\n*************** addr = %0d ******************\n",trans_hs.addr);
                fork
                    memory_model_read_logic();
                    drive_to_master(trans_hs);
                join
                `uvm_info(get_type_name(),$sformatf("\nData Received at Slave-Driver \nData(Hex) = %0h\n",trans_hs.data),UVM_MEDIUM)
                seq_item_port.item_done();
               
                `uvm_info(get_type_name(),$sformatf("\nHeader Sent from Slave-Driver to Master-Monitor \nHeader(Hex) = %0h\n",trans_hs.header),UVM_MEDIUM)
                `uvm_info(get_type_name(),$sformatf("\nData Sent from Slave-Driver to Master-Monitor \nData(Hex) = %0h\n",trans_hs.data),UVM_MEDIUM)
                `uvm_info(get_type_name(),$sformatf("Data Sent from Slave-Driver is =\n%s",trans_hs.sprint()),UVM_FULL)
            end
    endtask

/*
    function void final_phase(uvm_phase phase);
        foreach(trans_hs.mem_model[i])
        begin
            $display("mem_model[%0d] = %0h",i,trans_hs.mem_model[i]);
        end
    endfunction
*/
endclass : spi_slave_drv

`endif