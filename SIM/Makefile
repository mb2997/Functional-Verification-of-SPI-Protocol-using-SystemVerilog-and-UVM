#Makefile
TB=../TOP/spi_top.sv
TBModule=spi_top
PKG=../TEST/spi_pkg.sv


help:
	@echo =================================================================================
	@echo " lib   		=>  Make work directory"                            			
	@echo " cmp   		=>  Compile the whole code"
	@echo " sim    		=>  Simulate and run the code"
	@echo " run-all    		=>  Run above all targets sequencially"
	@echo " run-tc1    		=>  Run TESTCASE-1 for back-to-back Read-Write"
	@echo " run-tc2    		=>  Run TESTCASE-2 for multiple Read-Write"
	@echo " run-tc3    		=>  Run TESTCASE-3 for MSB-to-LSB Data Transaction"
	@echo " run-tc3    		=>  Run TESTCASE-4 for LSB-to-MSB Data Transaction"
	@echo =================================================================================

lib :
	vlib work
	
cmp :
	vlog $(PKG) $(TB) +incdir+../ENV +incdir+../TEST

sim :
	vsim -vopt $(TBModule) -c -do "run -all; exit"

sim_tc1 :
	vsim -novopt $(TBModule) -c -do "run -all; exit" +UVM_TESTNAME=spi_rw_b2b_tc1

sim_tc2 :
	vsim -novopt $(TBModule) -c -do "run -all; exit" +UVM_TESTNAME=spi_rw_tc2

sim_tc3 :
	vsim -novopt $(TBModule) -c -do "run -all; exit" +UVM_TESTNAME=spi_msb_lsb_tc3

sim_tc4 :
	vsim -novopt $(TBModule) -c -do "run -all; exit" +UVM_TESTNAME=spi_lsb_msb_tc4

run-all : lib cmp sim

run-tc1 : lib cmp sim_tc1

run-tc2 : lib cmp sim_tc2

run-tc3 : lib cmp sim_tc3

run-tc4 : lib cmp sim_tc4