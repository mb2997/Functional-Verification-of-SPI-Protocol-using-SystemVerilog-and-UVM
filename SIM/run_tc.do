set TESTNAME "$1"
echo TESTNAME
vlog ../TEST/spi_pkg.sv ../TOP/spi_top.sv +incdir+../ENV +incdir+../TEST
vsim -novopt spi_top +UVM_TESTNAME=$TESTNAME
run 0ns
log -r /uvm_root/*
do wave.do
run -all