onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_top/sclk
add wave -noupdate /spi_top/inf/sclk
add wave -noupdate /spi_top/inf/cs
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/trans_kind_e
add wave -noupdate /spi_top/inf/mosi
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/str_temp
add wave -noupdate /spi_top/inf/miso
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/mon_hs/wr_addr
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/drv_hs/rd_addr
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/addr_m
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/header_m
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/data_m
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/mon_hs/addr_s
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/mon_hs/header_s
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/mon_hs/data_s
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hs/drv_hs/data_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {590 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 122
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1627 ns} {2754 ns}
