clean:
	rm -rf xelab*
	rm -rf xsim*
	rm -rf work*
	rm -rf xvlog*
	rm -rf log.txt
	rm -rf rep1
	rm -rf xcrg.log
	rm -rf vivado*
	rm -rf tr_db*
	rm -rf dump.vcd


run_uvm_design_scenario1:
	xvlog -sv -L uvm -d param_scenario1 -f list.f 
	xelab -L uvm tb_uvm -debug all -timescale 1ns/1ns
	xsim tb_uvm -R | tee log.txt 
	xcrg -dir xsim.covdb -report_dir rep1 -report_format text

run_uvm_design_scenario2:
	xvlog -sv -L uvm -d param_scenario2 -f list.f 
	xelab -L uvm tb_uvm -debug all -timescale 1ns/1ns
	xsim tb_uvm -R | tee log.txt 
	xcrg -dir xsim.covdb -report_dir rep1 -report_format text

run_uvm_default_scenario:
	xvlog -sv -L uvm -f list.f 
	xelab -L uvm tb_uvm -debug all -timescale 1ns/1ns
	xsim tb_uvm -R | tee log.txt 
	xcrg -dir xsim.covdb -report_dir rep1 -report_format text

dbg:
	gtkwave dump.vcd
