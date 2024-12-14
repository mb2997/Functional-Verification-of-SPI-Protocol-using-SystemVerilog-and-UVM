`ifndef SPI_MASTER_SEQS
`define SPI_MASTER_SEQS

class spi_master_seqs extends uvm_sequence #(spi_master_trans);

    `uvm_object_utils(spi_master_seqs)
    spi_master_trans trans_hm;

    function new(string name = "spi_master_seqs");
        super.new(name);
    endfunction

    task body();
        trans_hm = spi_master_trans :: type_id :: create("trans_hm");
        repeat(no_of_trans)
            begin
                $display("\n-------------------- Transaction : %0d --------------------\n",req.current_trans);
                assert(trans_hm.randomize());
                $cast(req,trans_hm.clone());
                start_item(req);
                `uvm_info(get_type_name(), $sformatf("Generated Data From Master SEQS = \n%s",req.sprint()),UVM_MEDIUM)
                finish_item(req);
                req.current_trans++;
            end
    endtask

endclass : spi_master_seqs

`endif