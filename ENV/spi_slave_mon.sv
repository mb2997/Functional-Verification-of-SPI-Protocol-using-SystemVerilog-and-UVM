`ifndef SPI_SLAVE_MON
`define SPI_SLAVE_MON

class spi_slave_mon extends uvm_monitor;

    `uvm_component_utils(spi_slave_mon)

    virtual spi_inf vif;
    spi_slave_config config_hs;
    spi_slave_trans trans_hs;
    bit[`ADD_LEN-1:0] wr_addr;



    //For waveform
    bit [`HDR_LEN-1:0] header_s;
    bit [`DATA_LEN-1:0] data_s;
    bit [`ADD_LEN-1:0] addr_s;

    uvm_analysis_port #(spi_slave_trans) item_request_port;
    uvm_analysis_port #(spi_slave_trans) slave_mon2_sb;

    function new(string name = "spi_slave_mon", uvm_component parent = null);
        super.new(name,parent);
        item_request_port = new("item_request_port",this);
        slave_mon2_sb = new("slave_mon2_sb",this);
        trans_hs = spi_slave_trans :: type_id :: create("trans_hs");
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(spi_slave_config) :: get(this,"","spi_slave_config",config_hs))
            `uvm_fatal(get_type_name(),"Failed to get spi_config... Have you set it ?") 
    endfunction

    task send_to_sb();
        slave_mon2_sb.write(trans_hs);
    endtask

    task run_phase(uvm_phase phase);
        forever
        begin
            data_from_inf(); 
            `uvm_info(get_type_name(),$sformatf("Data Received at Slave-Monitor is =\n%s",trans_hs.sprint()),UVM_FULL)
            memory_model_write_logic();
            write_method();
            send_to_sb();
        end
    endtask

    task write_method();
        begin
            if(trans_hs.trans_kind_e.name == "READ")
            begin
                item_request_port.write(trans_hs);
                `uvm_info(get_type_name(),$sformatf("\nWrite to Analysis FIFO \nHeader(Hex) = %0h\n",trans_hs.header),UVM_MEDIUM)
            end
        end
    endtask

    task memory_model_write_logic();
        //wr_addr = trans_hs.header[`HDR_LEN-1:2];
        `uvm_info(get_type_name(),$sformatf("Write : wr_addr = %0d",wr_addr),UVM_DEBUG)
        if(trans_hs.trans_kind_e.name == "WRITE")
        begin
            trans_hs.mem_model[wr_addr] = trans_hs.data;
            `uvm_info(get_type_name(),$sformatf("\n%0h Data has been written at \n%0h location of memory model\n",trans_hs.data,wr_addr),UVM_MEDIUM)
        end
    endtask

    task casting_of_rw_enum();
        if(!$cast(trans_hs.trans_kind_e,trans_hs.header[0]))
            `uvm_fatal(get_type_name(),"Read-Write Enum Casting Failed...!!!")
    endtask

    task data_from_inf();
        begin
            #(`CYCLE/4);
            for(int i=0; i<$size(trans_hs.header); i++)
            begin
                @(negedge vif.sclk);
                trans_hs.header[i] = vif.mosi;
                `uvm_info(get_type_name(),$sformatf("\nHeader-Bit from MOSI to Slave-Monitor [i = %0d] = %b\n",i,trans_hs.header[i]),UVM_DEBUG)
            end

            header_s = trans_hs.header;
            trans_hs.addr = header_s[`HDR_LEN-1:2];
            addr_s = trans_hs.addr;
            wr_addr = addr_s;
            `uvm_info(get_type_name(),$sformatf("\nReceving header at Slave-Monitor \nHeader(Hex)) = %0h\n",trans_hs.header),UVM_MEDIUM)

            casting_of_rw_enum();

            if(trans_hs.trans_kind_e.name == "WRITE")
            begin
                begin
                    for(int i=0; i<$size(trans_hs.data); i++)
                    begin
                        @(negedge vif.sclk);
                        trans_hs.data[i] = vif.mosi;
                        `uvm_info(get_type_name(),$sformatf("\nData-Bit from MOSI to Slave-Monitor [i = %0d] = %b\n",i,trans_hs.header[i]),UVM_DEBUG)
                    end
                    data_s = trans_hs.data;
                    `uvm_info(get_type_name(),$sformatf("\nReceving Data at Slave-Monitor \nData(Hex)) = %0h\n",trans_hs.data),UVM_MEDIUM)
                end
                trans_hs.packet = {trans_hs.header,trans_hs.data};
            end
        end
    endtask

endclass : spi_slave_mon

`endif