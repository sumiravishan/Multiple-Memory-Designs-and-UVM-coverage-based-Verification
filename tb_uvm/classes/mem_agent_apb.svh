/*///////////////////////////////////////////////////////////////////
////                                                             ////
////  Author: Sumira Fernando                                    ////
////          k.w.s.v.fernando@gmail.com                         ////
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

`ifndef _MEM_AGENT_APB_SVH_
`define _MEM_AGENT_APB_SVH_

class mem_agent_apb extends uvm_agent;
	`uvm_component_utils(mem_agent_apb)
	mem_driver_apb drv;
	mem_monitor_apb mon;
	mem_scoreboard_apb scb;
	mem_coverage_apb cov;
	mem_sequencer seqr;
	string cfg_str;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		drv = mem_driver_apb::type_id::create("drv",this);
		mon = mem_monitor_apb::type_id::create("mon",this);
		scb = mem_scoreboard_apb::type_id::create("scb",this);
		seqr = mem_sequencer::type_id::create("seqr",this);
		cov = mem_coverage_apb::type_id::create("cov",this);
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction 
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("connect_phase")
		drv.seq_item_port.connect(seqr.seq_item_export);
		mon.broadcast_port.connect(scb.broadcast_receive_port);
		mon.broadcast_port.connect(cov.analysis_export);
		`_uvm_sim_fn_exit_internal_dbg("connect_phase")
	endfunction 
	
endclass


`endif 
