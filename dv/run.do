vlog -f tb.f
vsim -voptargs=+acc work.uart_tb_top +UVM_TESTNAME=uart_test_seq1_seq2 +UVM_VERBOSITY=UVM_LOW
add wave -position insertpoint sim:/uart_tb_top/vif/*
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
run -all
