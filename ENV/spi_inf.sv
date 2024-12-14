`define HDR_LEN 16
`define ADD_LEN 14
`define DLY_LEN 2
`define DATA_LEN 32

`ifndef SPI_INF
`define SPI_INF

interface spi_inf();

    logic miso;
    logic mosi;
    logic cs;
    logic sclk;

    /*
    clocking drv_cb@(posedge sclk);
        default input #1 output #1;
        output sclk, mosi, cs;
    endclocking 

    clocking mon_cb@(posedge sclk);
        default input #1 output #1;
        input sclk, miso, mosi, cs;
    endclocking 

    modport DRV_MP(clocking drv_cb);
    modport MON_MP(clocking mon_cb);
    */
    
endinterface : spi_inf

`endif