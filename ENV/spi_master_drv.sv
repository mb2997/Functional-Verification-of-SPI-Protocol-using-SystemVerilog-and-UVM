`ifndef SPI_MASTER_DRV
`define SPI_MASTER_DRV

class spi_master_drv extends uvm_driver #(spi_master_trans);

    //Factory registration
    `uvm_component_utils(spi_master_drv)
    string str_temp;
    virtual spi_inf vif;
    spi_master_config config_hm;
    spi_master_trans trans_hm;
    bit clock_disable;

    //Waveform variables
    bit [`HDR_LEN-1:0]header_m;
    bit [`DATA_LEN-1:0]data_m;
    bit [`ADD_LEN-1:0]addr_m;
    enum bit {READ,WRITE} trans_kind_e;

    function new(string name = "spi_master_drv", uvm_component parent = null);
        super.new(name,parent);
        trans_hm = new("trans_hm");
    endfunction

    function void build_phase(uvm_phase phase);
        //get method of config_db to get config class property
        if(!uvm_config_db #(spi_master_config) :: get(this,"","spi_master_config",config_hm))
            `uvm_fatal(get_type_name(),"Failed to get spi_config... Have you set it ?") 
    endfunction

    task run_phase(uvm_phase phase);

    //Initialize value of "cs"
    vif.cs = 0;
    fork
        //Call task to generate clock before requesting the data from seqs
        clock_generation();
    join_none

    forever
    begin
        seq_item_port.get_next_item(req);
        //Drive packet to slave
        drive_to_slave(req);
        seq_item_port.item_done();

        //make "cs" HIGH and make it LOW before new packet/transaction
        vif.cs = 1;
        //$display("cs becomes %0d at time %0t",vif.cs,$time);
        `uvm_info(get_type_name(), $sformatf("Data Driven from Master-Driver is = \n%s",req.sprint()),UVM_HIGH) 
        //Delay between two transactions
        #100; 
        vif.cs = 0;
        //$display("cs becomes %0d at time %0t",vif.cs,$time);
    end
    $display("------ Execution Done Run-Phase in Driver -------");
    endtask

    //String task to display in waveform
    task string_display(input string message);
        str_temp = message;
    endtask

    /*
    Drive to slave task - There are three task which we will drive to slave sequentially
    1) Header 2) Delay 3) Data
    */
    task drive_to_slave(spi_master_trans req);
        begin 
            drive_header(req);
            drive_delay();
            drive_data(req);
            //for display in waveform
            string_display("NEXT-TRANS");
        end
    endtask
    
    task clock_generation();
        //Clock initial value setting by case statement

        case(config_hm.select_mode_driver)
            config_hm.MODE_0, config_hm.MODE_1     :   vif.sclk = 0;
            config_hm.MODE_2, config_hm.MODE_3     :   vif.sclk = 1;
        endcase

        forever
            begin
                //If cs=0 then clock will be generated
                if(vif.cs == 0 && clock_disable == 0)
                    #(`CYCLE/2) vif.sclk = ~vif.sclk;
                //If cs=0 then clock will not be generated and hold its value
                if(vif.cs == 1 || clock_disable == 1)
                    #(`CYCLE/2) vif.sclk = vif.sclk;
            end
    endtask

    task triggering_mode();
        case(config_hm.select_mode_driver)
            config_hm.MODE_0, config_hm.MODE_2     :   @(posedge vif.sclk);
            config_hm.MODE_1, config_hm.MODE_3     :   @(negedge vif.sclk);
        endcase
    endtask

    task drive_header(spi_master_trans req);

        //Header bit is combination of (1) rw-bit (2) reserve-bit (3) address-bit
        req.header = {req.addr,req.res_bit,req.rw};
        $cast(trans_hm.trans_kind_e,req.rw);
        $cast(trans_kind_e,req.rw);
        string_display("HEADER");

        //Driving Header
        for(int i=0; i<$size(req.header); i++)
        begin
            //Logic of mode selection
            triggering_mode();
            vif.mosi = req.header[i];
            `uvm_info(get_type_name(),$sformatf("\nHeader-Bit to MOSI from Master-Driver [i = %0d] = %b\n",i,req.header[i]),UVM_DEBUG)
        end
        header_m = req.header;
        addr_m = header_m[`HDR_LEN-1:2];
        `uvm_info(get_type_name(),$sformatf("\nDriving header from Master-Driver \nHeader(Hex) = %0h",req.header),UVM_FULL);

    endtask

    task drive_delay();
        //When we drives the delay then we have to make high "cs" signal
        string_display("DELAY");
        //Make 'clock_disable' HIGH to disable clock then drive delay and make 'cs' LOW to enable clock
        clock_disable = 1;
        #(req.delay);
        clock_disable = 0;
    endtask

    task drive_data(spi_master_trans req);
        if(trans_hm.trans_kind_e.name == "WRITE")
        begin
            //For LSB to MSB selection
            if(config_hm.select_lsb_msb == 0)
            begin
                //2-D Array driving and send bits to MOSI with nested...for loop
                //foreach(req.data[i])
                //for(int i=0; i<$size(req.data); i++)
                begin
                    for(int n=0; n<$size(req.data); n++)
                    begin
                        //Logic of mode selection
                        triggering_mode();
                        string_display($sformatf("DATA"));
                        vif.mosi = req.data[n];
                        `uvm_info(get_type_name(),$sformatf("\nData-Bit to MOSI from Master-Driver [i = %0d] = %b\n",n,req.data[n]),UVM_DEBUG)
                    end
                    data_m = req.data;
                    `uvm_info(get_type_name(),$sformatf("\nDriving data from Master-Driver \nData(Hex) = %0h",req.data),UVM_FULL);
                end
            end

            //For MSB to LSB selection
            if(config_hm.select_lsb_msb == 1)
            begin
                //2-D Array driving and send bits to MOSI with nested...for loop
                //for(int i=0; i<$size(req.data); i++)
                begin
                    for(int n=($size(req.data)-1); n>=0; n--)
                    begin
                        //Logic of mode selection
                        triggering_mode();
                        string_display($sformatf("DATA"));
                        vif.mosi = req.data[n];
                        `uvm_info(get_type_name(),$sformatf("\nData-Bit to MOSI from Master-Driver [i = %0d] = %b\n",n,req.data[n]),UVM_DEBUG)
                    end
                    data_m = req.data;
                    `uvm_info(get_type_name(),$sformatf("\nDriving data from Master-Driver \nData(Hex) = %0h",req.data),UVM_FULL);
                end
            end
        end
    endtask

endclass : spi_master_drv

`endif