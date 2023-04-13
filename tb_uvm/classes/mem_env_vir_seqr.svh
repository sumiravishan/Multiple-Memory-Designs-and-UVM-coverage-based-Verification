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

`ifndef _MEM_ENV_VIR_SEQR_SVH_
`define _MEM_ENV_VIR_SEQR_SVH_
class mem_env_vir_seqr extends mem_env_base;
	`uvm_component_utils(mem_env_vir_seqr)
	mem_virtual_sequencer mem_vseqr;
	mem_agent_cam agt_cam;
	mem_agent_apb agt_apb;

	function new(string name , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		agt_cam = mem_agent_cam::type_id::create("agt_cam",this);
		agt_apb = mem_agent_apb::type_id::create("agt_apb",this);
		mem_vseqr = mem_virtual_sequencer::type_id::create("mem_vseqr",this);
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		`_uvm_sim_fn_enter_internal_dbg("connect_phase")
		super.connect_phase(phase);
		set_config_string_for_env();
		mem_vseqr.seqr_cam = agt_cam.seqr;
		mem_vseqr.seqr_apb = agt_apb.seqr;
		`_uvm_sim_fn_exit_internal_dbg("connect_phase")
	endfunction
	
	
	function void set_config_string_for_env();
		`_uvm_sim_fn_enter_internal_dbg("set_config_string_for_env")
		//config - cam
		agt_cam.cfg_str = cfg_str;
		agt_cam.drv.cfg_str = cfg_str;	
		agt_cam.mon.cfg_str = cfg_str;
		agt_cam.scb.print_received_pkt = cfg.scb_print_received_pkt;
		agt_cam.scb.print_pass_pkt = cfg.scb_print_pass_pkt;
		//config - apb mem
		agt_apb.cfg_str = cfg_str;
		agt_apb.drv.cfg_str = cfg_str;	
		agt_apb.mon.cfg_str = cfg_str;
		agt_apb.scb.print_received_pkt = cfg.scb_print_received_pkt;
		agt_apb.scb.print_pass_pkt = cfg.scb_print_pass_pkt;
		`_uvm_sim_fn_exit_internal_dbg("set_config_string_for_env")
	endfunction
	
endclass 

`endif 
