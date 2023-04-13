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

`ifndef _MEM_MONITOR_APB_SVH_
`define _MEM_MONITOR_APB_SVH_

class mem_monitor_apb extends mem_monitor_base;
	`uvm_component_utils(mem_monitor_apb)
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual task get_mem_pkt();
		`_uvm_sim_task_enter_internal_dbg("get_mem_pkt")
		fork 
			begin 
				`_uvm_sim_internal_dbg("Wait for valid req")
				wait( ( cfg.vif_apb.PENABLE == 1 ) && ( cfg.vif_apb.PSEL == 1 ) ) ;
				pkt = mem_monitor_transaction::type_id::create("pkt");
				`_uvm_sim_internal_dbg("Collect data after for valid req")
				packet_created = 1;
				pkt.addr = cfg.vif_apb.PADDR;
				pkt.din = cfg.vif_apb.PWDATA;
				pkt.mem_operation = cfg.vif_apb.PWRITE ? mem_design_pkg::mem_write : mem_design_pkg::mem_read;
				`_uvm_sim_internal_dbg("Wait for memory processing")
				@(posedge cfg.vif_apb.PCLK);
				wait( cfg.vif_apb.PREADY ==  1 );
				`_uvm_sim_internal_dbg("Detected memory processing")
				if ( pkt.mem_operation == mem_design_pkg::mem_read ) begin 
					`_uvm_sim_internal_dbg("Collecting valid read data")
					pkt.dout = cfg.vif_apb.PRDATA;
				end
				@(posedge cfg.vif_apb.PCLK);
				`_uvm_sim_internal_dbg("Done collecting other signal")
			end 
			begin 
				wait( cfg.vif_apb.PRESETn == 0 );
				reset_occured = 1;	
				consecative_timeout_count = 0; // reset is a fresh start
				`_uvm_sim_internal_dbg("Reset Occured")
			end 
			begin 
				repeat(cfg.timeout) @(posedge cfg.vif_apb.PCLK);
				timeout_logic();
			end
		join_any 
		disable fork;
		`_uvm_sim_task_exit_internal_dbg("get_mem_pkt")
	endtask 

endclass 


`endif
