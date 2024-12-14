`ifndef SPI_SLAVE_SEQS
`define SPI_SLAVE_SEQS

class spi_slave_seqs extends uvm_sequence #(spi_slave_trans);

    `uvm_object_utils(spi_slave_seqs)
    spi_slave_trans trans_hs;
    spi_slave_seqr seqr_hs;
    `uvm_declare_p_sequencer(spi_slave_seqr)
    
    function new(string name = "spi_slave_seqs");
        super.new(name);
    endfunction

    task body();
        if(!$cast(p_sequencer,m_sequencer))
            `uvm_fatal(get_type_name(),"Sequencer Casting Failed...!!!")

        forever
            begin
                trans_hs = spi_slave_trans :: type_id :: create("trans_hs");
                `uvm_info(get_type_name(),"\nTrying to get data from FIFO.....................\n",UVM_MEDIUM)
                p_sequencer.item_request_export.get(trans_hs);
                `uvm_info(get_type_name(),"\nData got from FIFO.....................\n",UVM_MEDIUM)
                `uvm_info(get_type_name(),$sformatf("\nRead from Analysis FIFO\nHeader(Hex) = %0h\n",trans_hs.header),UVM_MEDIUM)
                `uvm_info(get_type_name(),"\nWaiting for an Event...\n",UVM_MEDIUM)
                start_item(trans_hs);
                finish_item(trans_hs);
                `uvm_info(get_type_name(),$sformatf("\nHeader Sent to Slave-Driver \nHeader(Hex) = %0h\n",trans_hs.header),UVM_MEDIUM)
                `uvm_info(get_type_name(),$sformatf("\nData Sent to Slave-Driver \nData(Hex) = %0h\n",trans_hs.data),UVM_MEDIUM)
                `uvm_info(get_type_name(),$sformatf("Data Sent to Slave-Driver : \n%s",trans_hs.sprint()),UVM_FULL)
            end
    endtask

endclass : spi_slave_seqs

`endif