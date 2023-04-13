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

`ifndef _MEM_BASE_SEQUENCE_SVH_
`define _MEM_BASE_SEQUENCE_SVH_

class mem_base_sequence extends uvm_sequence#(mem_sequence_item);
	`uvm_object_utils(mem_base_sequence)

	mem_sequence_item pkt;
	bit end_seq;
	
	function new(string name = "");
		super.new(name);
		end_seq = 0;
	endfunction 

	task body();
		`_uvm_sim_task_enter_internal_dbg("body")
		forever begin
			packet_sending();
			if ( end_seq == 1 ) begin 
				break;
			end
		end
		`uvm_info(get_full_name(),"END : SEQ",UVM_LOW)
		`_uvm_sim_task_exit_internal_dbg("body")
	endtask
	
	virtual task packet_sending();
			`_uvm_sim_task_enter_internal_dbg("packet_sending")
			pkt = mem_sequence_item::type_id::create("pkt");
			assert(pkt.randomize());
			start_item(pkt);
			finish_item(pkt);
			`_uvm_sim_task_exit_internal_dbg("packet_sending")
	endtask
endclass

`endif 

`ifndef _MEM_WRITE_ONLY_SEQUENCE_SVH_
`define _MEM_WRITE_ONLY_SEQUENCE_SVH_

class mem_write_only_sequence extends mem_base_sequence;
	`uvm_object_utils(mem_write_only_sequence)

	function new(string name = "");
		super.new(name);
	endfunction 
	
	virtual task packet_sending();
			`_uvm_sim_task_enter_internal_dbg("packet_sending")
			pkt = mem_sequence_item::type_id::create("pkt");
			assert(pkt.randomize() with { mem_operation == mem_design_pkg::mem_write; });
			start_item(pkt);
			finish_item(pkt);
			`_uvm_sim_task_exit_internal_dbg("packet_sending")
	endtask
endclass

`endif 

`ifndef _MEM_READ_ONLY_SEQUENCE_SVH_
`define _MEM_READ_ONLY_SEQUENCE_SVH_

class mem_read_only_sequence extends mem_base_sequence;
	`uvm_object_utils(mem_read_only_sequence)

	function new(string name = "");
		super.new(name);
	endfunction 
	
	virtual task packet_sending();
			`_uvm_sim_task_enter_internal_dbg("packet_sending")
			pkt = mem_sequence_item::type_id::create("pkt");
			assert(pkt.randomize() with { mem_operation == mem_design_pkg::mem_read; });
			start_item(pkt);
			finish_item(pkt);
			`_uvm_sim_task_exit_internal_dbg("packet_sending")
	endtask
endclass

`endif 