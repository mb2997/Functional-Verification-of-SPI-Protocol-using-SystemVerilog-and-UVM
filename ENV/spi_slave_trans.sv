`ifndef SPI_SLAVE_TRANS
`define SPI_SLAVE_TRANS

class spi_slave_trans extends uvm_sequence_item;

    //Variable declaration of rand and non-rand type 
    bit [`ADD_LEN-1:0] addr;
    bit [`HDR_LEN-1:0] header;
    bit [`DATA_LEN-1:0] data;
    bit cs;
    logic [(`DATA_LEN + `HDR_LEN)-1:0] packet;
    //bit mosi;

    //enum for rw bit.
    enum bit {READ,WRITE}trans_kind_e;
    //memory model
    static bit [`DATA_LEN-1:0]mem_model[int];

    //Factory registration & Data field registration
    `uvm_object_utils_begin(spi_slave_trans)
        `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(header, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
    `uvm_object_utils_end

    function new(string name = "spi_slave_trans");
        super.new(name);
    endfunction 

endclass : spi_slave_trans

`endif