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

`ifndef _MEM_SCOREBOARD_BASE_SVH_
`define _MEM_SCOREBOARD_BASE_SVH_

class mem_scoreboard_base extends uvm_scoreboard;
	`uvm_component_utils(mem_scoreboard_base)
	
	uvm_analysis_imp #(mem_monitor_transaction,mem_scoreboard_base) broadcast_receive_port;
	
	bit print_received_pkt = 1;
	bit print_pass_pkt = 1;
	
	bit [tb_param_pkg::param_WIDTH_DATA-1:0] mem_0;
	bit [tb_param_pkg::param_WIDTH_DATA-1:0] data_mem_model [int unsigned];
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		broadcast_receive_port = new("broadcast_receive_port",this);
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction 

	virtual function void write(mem_monitor_transaction t);
		`_uvm_sim_fn_enter_internal_dbg("write")
			validate_based_on_model(t);
			`uvm_info(get_full_name(), $sformatf("data_mem_model current filled size %0h",data_mem_model.size()), UVM_DEBUG)
		`_uvm_sim_fn_exit_internal_dbg("write")
	endfunction 

	virtual function void validate_based_on_model(mem_monitor_transaction t);
		`_uvm_sim_fn_enter_internal_dbg("validate_based_on_model")
		`_uvm_sim_fn_exit_internal_dbg("validate_based_on_model")
	endfunction

endclass




`endif 
