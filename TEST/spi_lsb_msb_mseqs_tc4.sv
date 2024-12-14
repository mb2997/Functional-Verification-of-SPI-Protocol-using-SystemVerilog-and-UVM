`ifndef SPI_LSB_MSB_MSEQS_TC4
`define SPI_LSB_MSB_MSEQS_TC4

class spi_lsb_msb_mseqs_tc4 extends spi_master_seqs;

    `uvm_object_utils(spi_lsb_msb_mseqs_tc4)

    function new(string name = "spi_lsb_msb_mseqs_tc4");
        super.new(name);
        trans_hm = spi_master_trans :: type_id :: create("trans_hm");
    endfunction

    task body();

        repeat(no_of_trans)
        begin
            begin
                $display("\n-------------------- Transaction : %0d --------------------\n",req.current_trans);
                assert(trans_hm.randomize() with {rw == 1;});
                $cast(req,trans_hm.clone());
                start_item(req);
                req.header = {req.addr,req.res_bit,req.rw};
                `uvm_info(get_type_name(), $sformatf("Generated Data From Master SEQS = \n%s",req.sprint()),UVM_MEDIUM)
                finish_item(req);
                req.current_trans++;
            end

            begin
                $display("\n-------------------- Transaction : %0d --------------------\n",req.current_trans);
                //assert(trans_hm.randomize() with {rw == 0; addr == 2;});
                //$cast(req,trans_hm.clone());
                trans_hm.rw = 0;
                trans_hm.addr = req.addr;
                start_item(trans_hm);
                trans_hm.header = {trans_hm.addr,trans_hm.res_bit,trans_hm.rw};
                `uvm_info(get_type_name(), $sformatf("Generated Data From Master SEQS = \n%s",trans_hm.sprint()),UVM_MEDIUM)
                finish_item(trans_hm);
                trans_hm.current_trans++;
            end
        end
    endtask

endclass : spi_lsb_msb_mseqs_tc4

`endif