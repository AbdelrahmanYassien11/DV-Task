vlog -f tb.f
vsim -voptargs=+acc work.uart_tb_top +UVM_TESTNAME=task2_1_test +UVM_VERBOSITY=UVM_LOW +TX_DATA_WIDTH=8 \
+START_BITS_WIDTH=1 +STOP_BITS_WIDTH=1 +REG_DATA_MSB_IDX=7 +REG_DATA_LSB_IDX=4 +ADDR_MSB_IDX=3 +ADDR_LSB_IDX=1
add wave -position insertpoint sim:/uart_tb_top/vif/*
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
run -all
