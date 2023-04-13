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

`ifndef _MEM_SCOREBOARD_APB_SVH_
`define _MEM_SCOREBOARD_APB_SVH_

class mem_scoreboard_apb extends mem_scoreboard_base;
	`uvm_component_utils(mem_scoreboard_apb)
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction 

	function void validate_based_on_model(mem_monitor_transaction t);
		`_uvm_sim_fn_enter_internal_dbg("validate_based_on_model")
		if ( print_received_pkt == 1 ) begin 
			`uvm_info(get_full_name(),"\n------------Printing received packet-------------",UVM_LOW)
			t.print();
		end		
	
		if ( t.mem_operation == mem_design_pkg::mem_write ) begin 
			 
			if ( ( t.din == 0 ) && ( data_mem_model.exists(t.addr) == 1 ) ) begin 
				data_mem_model.delete(t.addr);
				`uvm_info(get_full_name(), $sformatf("Removed Entry for Addr = %0h",t.addr),UVM_DEBUG)
			end else if ( data_mem_model.exists(t.addr) == 1 ) begin 
				data_mem_model[t.addr] = t.din; //Replace old entry
				`uvm_info(get_full_name(), $sformatf("Updated Entry for Addr = %0h",t.addr),UVM_DEBUG)
			end else if ( ( t.din != 0 ) && ( t.addr != 0 ) ) begin 
				if ( t.addr < tb_param_pkg::param_SIZE ) begin 
					data_mem_model[t.addr] = t.din; // New Entry
					`uvm_info(get_full_name(), $sformatf("Added new Entry for Addr = %0h",t.addr),UVM_DEBUG)
				end else begin 
					`uvm_info(get_full_name(), $sformatf("Address = %0h , is not in the reange",t.addr),UVM_DEBUG)
				end 
			end else if ( t.addr == 0 ) begin 
				mem_0 = t.din;
				`uvm_info(get_full_name(), $sformatf("Updated new Entry for Addr 0 with value = %0h",t.din),UVM_DEBUG)
			end else begin
				`uvm_info(get_full_name(), $sformatf("Expected no memory update addr =%0h din = %0h",t.addr,t.din),UVM_DEBUG)
			end 
			
		end else begin 
			if ( t.addr == 0 ) begin 
				if ( mem_0 != t.dout ) begin 
					`uvm_fatal(get_full_name(), $sformatf("Unexpected memory read data expected = %0h , received = %0h , addr = 0 ", mem_0,t.dout ) )
				end
			end else if ( data_mem_model.exists(t.addr) == 1 ) begin
				if ( data_mem_model[t.addr] != t.dout ) begin 
					`uvm_fatal(get_full_name(), $sformatf("Unexpected memory read data expected = %0h , received = %0h , addr = %0h", data_mem_model[t.addr],t.dout, t.addr ) )
				end 
			end else if ( t.dout != {tb_param_pkg::param_WIDTH_DATA{1'b0}} ) begin 
				`uvm_fatal(get_full_name(), $sformatf("Unexpected memory read data expected = %0h , received = %0h , addr = %0h", data_mem_model[t.addr],t.dout, t.addr ) )
			end 
		end 
		
		if ( print_pass_pkt == 1 ) begin 
			`uvm_info(get_full_name(),"Transaction validated -> PASS", UVM_LOW);
		end 
		`_uvm_sim_fn_exit_internal_dbg("validate_based_on_model")
	endfunction

endclass




`endif 
