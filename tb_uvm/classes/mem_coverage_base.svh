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

`ifndef _MEM_COVERAGE_BASE_SVH_
`define _MEM_COVERAGE_BASE_SVH_ 

class mem_coverage_base extends uvm_subscriber#(mem_monitor_transaction);
	`uvm_component_utils(mem_coverage_base)
	
	bit read_write;
	
	mem_monitor_transaction t_cov;

	mem_uvm_pkg::write_operation_coverage wr_din_cov[tb_param_pkg::param_WIDTH_DATA-1:0];
	mem_uvm_pkg::read_operation_coverage wr_dout_cov[tb_param_pkg::param_WIDTH_DATA-1:0];
	mem_uvm_pkg::signal_cov cg_addr[tb_param_pkg::param_WIDTH_ADDR-1:0];
	

	function new(string name, uvm_component parent);
		super.new(name,parent);
		t_cov = mem_monitor_transaction::type_id::create("t_cov");
		foreach( wr_din_cov[i] )
			wr_din_cov[i] = new(t_cov.din[i],t_cov.mem_operation);

		foreach( wr_dout_cov[i] )
			wr_dout_cov[i] = new(t_cov.dout[i],t_cov.mem_operation);
			
		foreach( cg_addr[i] )
			cg_addr[i] = new(t_cov.addr[i]);
	endfunction
	
	virtual function void write(mem_monitor_transaction t);
		`_uvm_sim_fn_enter_internal_dbg("write")
		t_cov.copy(t);
		read_write = t.mem_operation;
		functional_coverage_sample();
		`_uvm_sim_fn_exit_internal_dbg("write")
	endfunction 

	function void functional_coverage_sample();
		`_uvm_sim_fn_enter_internal_dbg("functional_coverage_sample")
		foreach( wr_din_cov[i] )
			wr_din_cov[i].sample();

		foreach( wr_dout_cov[i] )
			wr_dout_cov[i].sample();
			
		foreach( cg_addr[i] )
			cg_addr[i].sample();
		`_uvm_sim_fn_exit_internal_dbg("functional_coverage_sample")
	endfunction 

endclass 

`endif 
