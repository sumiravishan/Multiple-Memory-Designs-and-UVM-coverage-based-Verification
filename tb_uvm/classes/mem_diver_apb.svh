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

`ifndef _MEM_DRIVER_APB_SVH_
`define _MEM_DRIVER_APB_SVH_

class mem_driver_apb extends mem_driver_cam;
	`uvm_component_utils(mem_driver_apb)
	
	function new(string name , uvm_component parent);
		super.new(name,parent);
	endfunction 
	
	virtual task mem_write_drive();
		`_uvm_sim_task_enter_internal_dbg("mem_write_drive")
		if ( cfg.vif_apb != null ) begin 
			fork : mem_write
				begin 
					@(posedge cfg.vif_apb.PCLK);
					cfg.vif_apb.PSEL <= 1;
					cfg.vif_apb.PADDR <= pkt.addr;
					cfg.vif_apb.PWDATA <= pkt.data;
					cfg.vif_apb.PWRITE<= 1;
					@(posedge cfg.vif_apb.PCLK);
					cfg.vif_apb.PENABLE<= 1;
					@(posedge cfg.vif_apb.PCLK);
					`_uvm_sim_internal_dbg("Waiting for PREADY")
					wait(cfg.vif_apb.PREADY==1);
					cfg.vif_apb.PENABLE<= 0;
					cfg.vif_apb.PSEL<= 0;
				end
				begin 
					@( cfg.vif_apb.PRESETn == 0 );	
					`_uvm_sim_internal_dbg("PRESETn is zero")
				end 
			join_any
			disable mem_write;
		end else begin 
			`uvm_fatal(get_full_name(),"Interface is null")		
		end
		`_uvm_sim_task_exit_internal_dbg("mem_write_drive")
	endtask
	
	virtual task mem_read_drive();
		`_uvm_sim_task_enter_internal_dbg("mem_write_drive")
		if ( cfg.vif_apb != null ) begin 
			fork : mem_read
				begin 
					@(posedge cfg.vif_apb.PCLK);
					cfg.vif_apb.PSEL <= 1;
					cfg.vif_apb.PADDR <= pkt.addr;
					cfg.vif_apb.PWRITE= 0;
					@(posedge cfg.vif_apb.PCLK);
					cfg.vif_apb.PENABLE= 1;
					@(posedge cfg.vif_apb.PCLK);
					`_uvm_sim_internal_dbg("Waiting for PREADY")
					wait(cfg.vif_apb.PREADY==1);
					cfg.vif_apb.PENABLE<= 0;
					cfg.vif_apb.PSEL<= 0;
				end
				begin 
					@( cfg.vif_apb.PRESETn == 0 );	
					`_uvm_sim_internal_dbg("PRESETn is zero")
				end 
			join_any
			disable mem_read;
		end else begin 
			`uvm_fatal(get_full_name(),"Interface is null")		
		end 
		`_uvm_sim_task_exit_internal_dbg("mem_write_drive")
	endtask
	
endclass 

`endif 
