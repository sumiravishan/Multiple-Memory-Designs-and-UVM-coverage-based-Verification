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

`ifndef _MEM_SEQUENCE_ITEM_SVH_
`define _MEM_SEQUENCE_ITEM_SVH_

class mem_sequence_item extends uvm_sequence_item;
	rand mem_design_pkg::mem_op mem_operation;
	rand bit [tb_param_pkg::param_WIDTH_ADDR-1:0] addr; // Max( param_WIDTH_ADDR ) is 32
	rand bit [tb_param_pkg::param_WIDTH_DATA-1:0] data; // Max( param_WIDTH_ADDR ) is 32
	
	`uvm_object_utils_begin(mem_sequence_item)
		`uvm_field_enum(mem_design_pkg::mem_op,mem_operation,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(data,UVM_ALL_ON)
	`uvm_object_utils_end

	constraint addr_cond {
		addr >= 0;
		addr < {tb_param_pkg::param_WIDTH_ADDR{1'b1}};
	}

	function new(string name = "");
		super.new(name);
	endfunction 

endclass

`endif 

