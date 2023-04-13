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

`ifndef _MEM_COVERAGE_CAM_SVH_
`define _MEM_COVERAGE_CAM_SVH_ 

class mem_coverage_cam extends mem_coverage_base;
	`uvm_component_utils(mem_coverage_cam)
	
	mem_uvm_pkg::signal_cov cg_full;
	mem_uvm_pkg::signal_cov cg_almost_full;
	mem_uvm_pkg::signal_cov cg_read_write;
	mem_uvm_pkg::signal_level_cov cg_write_error;
	

	function new(string name, uvm_component parent);
		super.new(name,parent);
		cg_full = new(t_cov.full);
		cg_read_write = new(read_write);
		cg_almost_full = new(t_cov.almost_full);
		cg_write_error = new(t_cov.write_error);
	endfunction
	
	virtual function void write(mem_monitor_transaction t);
		`_uvm_sim_fn_enter_internal_dbg("write")
		t_cov.copy(t);
		read_write = t.mem_operation;
		functional_coverage_sample();
		`_uvm_sim_fn_exit_internal_dbg("write")
	endfunction 

	function void functional_coverage_sample();
		super.functional_coverage_sample();
		`_uvm_sim_fn_enter_internal_dbg("functional_coverage_sample")
		cg_full.sample();
		cg_read_write.sample();
		cg_almost_full.sample();
		cg_write_error.sample();
		`_uvm_sim_fn_exit_internal_dbg("functional_coverage_sample")
	endfunction 

endclass 

`endif 
