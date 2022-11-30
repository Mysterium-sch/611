onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simtop/dut/cpu1/clk
add wave -noupdate /simtop/dut/cpu1/rst_n
add wave -noupdate /simtop/dut/cpu1/instr_EX_1
add wave -noupdate /simtop/dut/cpu1/instr_EX_2
add wave -noupdate /simtop/dut/cpu1/regfile1/writeaddr_1
add wave -noupdate /simtop/dut/cpu1/regfile1/writeaddr_2
add wave -noupdate /simtop/dut/cpu1/regfile1/readdata2_buf_2
add wave -noupdate /simtop/dut/cpu1/regfile1/readdata1_buf_2
add wave -noupdate /simtop/dut/cpu1/regfile1/readdata1_buf_1
add wave -noupdate /simtop/dut/cpu1/regfile1/readdata2_buf_1
add wave -noupdate /simtop/dut/cpu1/readdata1_1
add wave -noupdate /simtop/dut/cpu1/readdata2_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {195 ns}
