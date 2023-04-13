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

`ifndef _MEM_MONITOR_TRANSACTION_SVH_
`define _MEM_MONITOR_TRANSACTION_SVH_

class mem_monitor_transaction extends uvm_transaction;
	mem_design_pkg::mem_op mem_operation;
	bit [tb_param_pkg::param_WIDTH_ADDR-1:0] addr; // Max( param_WIDTH_ADDR ) is 32
	bit [tb_param_pkg::param_WIDTH_DATA-1:0] din; // Max( param_WIDTH_ADDR ) is 32
	bit [tb_param_pkg::param_WIDTH_DATA-1:0] dout; // Max( param_WIDTH_ADDR ) is 32
	bit full;
	bit almost_full;
	bit write_error;
	bit invalid_write_state;
	
	`uvm_object_utils_begin(mem_monitor_transaction)
		`uvm_field_enum(mem_design_pkg::mem_op,mem_operation,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(din,UVM_ALL_ON)
		`uvm_field_int(dout,UVM_ALL_ON)
		`uvm_field_int(full,UVM_ALL_ON)
		`uvm_field_int(almost_full,UVM_ALL_ON)
		`uvm_field_int(write_error,UVM_ALL_ON)
		`uvm_field_int(invalid_write_state,UVM_ALL_ON)
	`uvm_object_utils_end
	
	function new(string name = "");
		super.new(name);
	endfunction


endclass


`endif 