`ifndef SPI_MASTER_TRANS
`define SPI_MASTER_TRANS

class spi_master_trans extends uvm_sequence_item;

    //Variable declaration of rand and non-rand type 
    rand bit rw;
    bit res_bit = 0;

    //no_of_data variable is for depth of data variable -- It is the number of multiple data which we want to drive
    static rand bit [`NO_DATA_WIDTH-1:0] no_of_data;
    randc bit [`ADD_LEN-1:0] addr;
    randc bit [`DLY_LEN-1:0] delay;

    //[$] queue array is for multiple data indexes which comes from no_of_data
    rand bit [`DATA_LEN-1:0] data;

    //chip-select bit
    bit mosi;
    bit [`HDR_LEN-1:0] header;

    //local int
    static int current_trans = 1;
    enum bit {READ,WRITE} trans_kind_e;

    //constraint for randomization
    constraint RES_C{soft res_bit == 1'b0;}
    constraint DLY_C{delay == 15;}
    //constraint RW_C{rw == 1'b0;}
    constraint DATA_C{(rw == 1'b0) -> data == 0;}
    //constraint ADD_BOUND_C{soft addr inside {[1:2]};}
    constraint ADD_BOUND_C{soft addr inside {[1:10]};}
    //constraint ADD_BOUND_C1{(rw == 1'b0) -> addr == addr;}
    //constraint NDATA_C{soft no_of_data == 1;}
    //constraint DATA_QSIZE{data.size() == no_of_data; solve no_of_data before data;}

    //Factory registration & Data field registration
    `uvm_object_utils_begin(spi_master_trans)
        `uvm_field_int(current_trans, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(rw, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(res_bit, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(header, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(delay, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
    `uvm_object_utils_end

    function new(string name = "spi_master_trans");
        super.new(name);
    endfunction 

endclass : spi_master_trans

`endif