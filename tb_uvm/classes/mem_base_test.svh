/*///////////////////////////////////////////////////////////////////
////                                                             ////
////  Author: Sumira Fernando                                    ////
////          k.w.s.v.fernanfo@gmail.com                         ////
////                                                             ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2023                                          ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
//// This source file is free software; you can redistribute it  ////
//// and/or modify it under the terms of the GNU Lesser General  ////
//// Public License as published by the Free Software Foundation.////
////                                                             ////
//// This source is distributed in the hope that it will be      ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied  ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     ////
//// PURPOSE.  See the GNU Lesser General Public License for more////
//// details. http://www.gnu.org/licenses/lgpl.html              ////
////                                                             ////
///////////////////////////////////////////////////////////////////*/

`ifndef _MEM_BASE_TEST_SVT_
`define _MEM_BASE_TEST_SVT_

class mem_base_test extends uvm_test;
	`uvm_component_utils(mem_base_test)
	
	mem_global_config cfg0;
	uvm_report_server svr;
	
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_config();
		`_uvm_sim_fn_enter_internal_dbg("build_config")
		cfg0 = mem_global_config::type_id::create("cfg0");
		
		if ( ! uvm_config_db#(virtual mem_drive_interface_cam)::get(this, "",$sformatf("mem_drive_interface_cam%0d",0), cfg0.vif_cam) ) begin 
			`uvm_fatal(get_full_name(),$sformatf("Unable to get the CAM mem Interface %0d",0))
		end 

		if ( ! uvm_config_db#(virtual mem_drive_interface_apb)::get(this, "",$sformatf("mem_drive_interface_apb%0d",0), cfg0.vif_apb) ) begin 
			`uvm_fatal(get_full_name(),$sformatf("Unable to get the APB mem Interface %0d",0))
		end 
		
		cfg0.timeout = tb_param_pkg::param_SIZE + tb_param_pkg::rst_duration + 10;
		cfg0.max_consecative_timeout_count = 1;
		
		//Scoreboard print configuration
		cfg0.scb_print_received_pkt = 0;
		cfg0.scb_print_pass_pkt = 1;
		
		//Monitor print configuration
		cfg0.monitor_print_pkt = 0;
		cfg0.cust_rpt_monitor = mem_uvm_pkg::report_all;
		cfg0.cust_rpt_time_monitor = mem_uvm_pkg::report_all_time;
		cfg0.report_addr = 6;
		cfg0.report_time_start = 309;
		cfg0.report_time_end = 333;
		
		//Driver print configuration
		cfg0.driver_print_pkt = 0;
		cfg0.cust_rpt_driver = mem_uvm_pkg::report_all;
		cfg0.cust_rpt_time_driver = mem_uvm_pkg::report_all_time;
		
		uvm_config_db#(mem_global_config)::set(null, "*", "cfg0", cfg0);
		`_uvm_sim_fn_exit_internal_dbg("build_config")
	endfunction
	
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("report_phase")
		svr = uvm_report_server::get_server();
		if ( 0 == svr.get_severity_count(UVM_ERROR)) begin 
			if ( 0 == svr.get_severity_count(UVM_WARNING) ) begin 
				`uvm_info(get_full_name(),"------------Test Pass--------------------",UVM_LOW)
			end else begin 
				`uvm_info(get_full_name(),"------------Test Pass - Please check the warnings",UVM_LOW)
			end 
		end else begin 
			`uvm_info(get_full_name(),"------------!!!!!Test Fail------------",UVM_LOW)
		end 
		`_uvm_sim_fn_exit_internal_dbg("report_phase")
	endfunction

endclass 

`endif 

