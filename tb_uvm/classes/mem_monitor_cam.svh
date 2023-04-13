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

`ifndef _MEM_MONITOR_CAM_SVH_
`define _MEM_MONITOR_CAM_SVH_

class mem_monitor_cam extends mem_monitor_base;
	`uvm_component_utils(mem_monitor_cam)
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual task get_mem_pkt();
		`_uvm_sim_task_enter_internal_dbg("get_mem_pkt")
		fork 
			begin 
				`_uvm_sim_internal_dbg("Wait for valid req")
				wait( ( cfg.vif_cam.req == 1 ) && ( cfg.vif_cam.busy == 0 ) ) ;
				pkt = mem_monitor_transaction::type_id::create("pkt");
				`_uvm_sim_internal_dbg("Collect data after for valid req")
				packet_created = 1;
				pkt.addr = cfg.vif_cam.addr;
				pkt.din = cfg.vif_cam.din;
				pkt.mem_operation = cfg.vif_cam.wr_nrd ? mem_design_pkg::mem_write : mem_design_pkg::mem_read;
				`_uvm_sim_internal_dbg("Wait for memory processing")
				wait( cfg.vif_cam.busy ==  1 );
				`_uvm_sim_internal_dbg("Detected memory processing")
				`_uvm_sim_internal_dbg("Decide operation")
				if ( pkt.mem_operation == mem_design_pkg::mem_read ) begin 
					`_uvm_sim_internal_dbg("Waiting for valid read data")
					wait( cfg.vif_cam.read_valid == 1 );
					`_uvm_sim_internal_dbg("Collecting valid read data")
					pkt.dout = cfg.vif_cam.dout;
				end
				`_uvm_sim_internal_dbg("Wait for other signal")
				wait( cfg.vif_cam.busy ==  0 );
				`_uvm_sim_internal_dbg("Collecting other signal")
				pkt.full = cfg.vif_cam.full;
				pkt.almost_full = cfg.vif_cam.almost_full;
				pkt.write_error = cfg.vif_cam.write_error;
				pkt.invalid_write_state = cfg.vif_cam.invalid_write_state;
				`_uvm_sim_internal_dbg("Done collecting other signal")
			end 
			begin 
				wait( cfg.vif_cam.rst == 1 );
				reset_occured = 1;	
				consecative_timeout_count = 0; // reset is a fresh start
				`_uvm_sim_internal_dbg("Reset Occured")
			end 
			begin 
				repeat(cfg.timeout) @(posedge cfg.vif_cam.clk);
				timeout_logic();
			end
		join_any 
		disable fork;
		`_uvm_sim_task_exit_internal_dbg("get_mem_pkt")
	endtask 

endclass 


`endif
