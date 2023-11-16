onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_bench/clk
add wave -noupdate -radix unsigned /test_bench/rst_n
add wave -noupdate -radix unsigned /test_bench/frame_start
add wave -noupdate -radix unsigned /test_bench/frame_end
add wave -noupdate -radix unsigned /test_bench/line_end
add wave -noupdate /test_bench/data_in_valid
add wave -noupdate /test_bench/data_out_valid
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/LCDI_state
add wave -noupdate -radix unsigned /test_bench/data0_in
add wave -noupdate -radix unsigned /test_bench/data1_in
add wave -noupdate -radix unsigned /test_bench/data2_in
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/col_count
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/row_count
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index1_inst/data0_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index1_inst/data1_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index1_inst/data2_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index1_inst/index
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/write_enable
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/data0_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/data1_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/data2_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter1_inst/data3_out
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/index0
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/index1
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/index2
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/index3
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/G0
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/G1
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/index2_inst/index
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data0_in
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data1_in
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data2_in
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data0_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data1_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data2_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/data3_out
add wave -noupdate -radix unsigned /test_bench/LCDI_inst/inter2_ins/index
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {6251803425 ps} 0} {{Cursor 2} {6782065218 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 142
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6451232768 ps}
