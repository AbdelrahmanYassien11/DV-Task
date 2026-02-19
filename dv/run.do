vlog -f tb.f
vsim -voptargs=+acc work.uart_tb_top +UVM_TESTNAME=uart_test_seq1_seq2 +UVM_VERBOSITY=UVM_LOW +TX_DATA_WIDTH=10 \
+START_BITS_WIDTH=3 +STOP_BITS_WIDTH=2
add wave -position insertpoint sim:/uart_tb_top/vif/*
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
run -all
