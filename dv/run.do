vlog -f tb.f
vsim -voptargs=+acc work.uart_tb_top
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
run -all
