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

`ifndef _MEM_ENV_BASE_SVH_
`define _MEM_ENV_BASE_SVH_

virtual class mem_env_base extends uvm_env;
	`uvm_component_utils(mem_env_base)

	string cfg_str;
	mem_global_config cfg;
	
	function new(string name , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		cfg = mem_global_config::type_id::create("cfg");
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction 
	
	virtual function void connect_phase(uvm_phase phase);
		`_uvm_sim_fn_enter_internal_dbg("connect_phase")
		super.connect_phase(phase);
		if ( ! uvm_config_db#(mem_global_config)::get(null, "",cfg_str, cfg) ) begin 
			`uvm_fatal(get_full_name(),$sformatf("Unable to get the Configuration %0s",cfg_str))
		end
		`_uvm_sim_fn_exit_internal_dbg("connect_phase")
	endfunction

endclass 


`endif
