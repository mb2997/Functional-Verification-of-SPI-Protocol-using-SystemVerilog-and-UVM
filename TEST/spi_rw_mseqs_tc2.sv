`ifndef SPI_RW_MSEQS_TC2
`define SPI_RW_MSEQS_TC2

class spi_rw_mseqs_tc2 extends spi_master_seqs;

    `uvm_object_utils(spi_rw_mseqs_tc2)

    function new(string name = "spi_rw_mseqs_tc2");
        super.new(name);
        trans_hm = spi_master_trans :: type_id :: create("trans_hm");
    endfunction

    task body();
        repeat(no_of_trans)
            begin
                $display("\n-------------------- Transaction : %0d --------------------\n",req.current_trans);
                assert(trans_hm.randomize() with {rw == 1; addr inside {[1:3]};});
                $cast(req,trans_hm.clone());
                start_item(req);
                req.header = {req.addr,req.res_bit,req.rw};
                `uvm_info(get_type_name(), $sformatf("Generated Data From Master SEQS = \n%s",req.sprint()),UVM_MEDIUM)
                finish_item(req);
                req.current_trans++;
            end

        repeat(no_of_trans)
            begin
                $display("\n-------------------- Transaction : %0d --------------------\n",req.current_trans);
                assert(trans_hm.randomize() with {rw == 0; addr inside {[1:3]};});
                $cast(req,trans_hm.clone());
                start_item(req);
                req.header = {req.addr,req.res_bit,req.rw};
                `uvm_info(get_type_name(), $sformatf("Generated Data From Master SEQS = \n%s",req.sprint()),UVM_MEDIUM)
                finish_item(req);
                req.current_trans++;
            end
    endtask

endclass : spi_rw_mseqs_tc2

`endif