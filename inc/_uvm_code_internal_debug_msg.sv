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

//`define _uvm_sim_internal_dbg_general 
//`define _uvm_sim_internal_dbg_time_gt
//`define _uvm_sim_internal_dbg_time_btw

`define _uvm_sim_internal_dbg_time_start 0
`define _uvm_sim_internal_dbg_time_end 215


`define _uvm_sim_fn_enter_internal_dbg(str) \
	`ifdef _uvm_sim_internal_dbg_general  \
		`uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Entered \t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_gt \
		if ( $time >= `_uvm_sim_internal_dbg_time_start ) `uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Entered \t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_btw \
		if ( ( $time <= `_uvm_sim_internal_dbg_time_end ) && ( $time >= `_uvm_sim_internal_dbg_time_start ) ) `uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Entered \t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`endif
	
`define _uvm_sim_fn_exit_internal_dbg(str) \
	`ifdef _uvm_sim_internal_dbg_general  \
		`uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Exit \t\t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_gt \
		if ( $time >= `_uvm_sim_internal_dbg_time_start ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Exit \t\t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_btw \
		if ( ( $time <= `_uvm_sim_internal_dbg_time_end ) && ( $time >= `_uvm_sim_internal_dbg_time_start ) ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] FUNCTION : %0t \t Exit \t\t %0s \t\t\t\t in %m",$time,``str``),UVM_LOW) \
	`endif
	
`define _uvm_sim_task_enter_internal_dbg(str) \
	`ifdef _uvm_sim_internal_dbg_general  \
		`uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] TASK : %0t \t Entered \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_gt \
		if ( $time >= `_uvm_sim_internal_dbg_time_start ) `uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] TASK : %0t \t Entered \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_btw \
		if ( ( $time <= `_uvm_sim_internal_dbg_time_end ) && ( $time >= `_uvm_sim_internal_dbg_time_start ) ) `uvm_info(get_full_name(),$sformatf("(+) [INTERNAL:DEBUG][UVM] TASK : %0t \t Entered \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`endif
	
`define _uvm_sim_task_exit_internal_dbg(str) \
	`ifdef _uvm_sim_internal_dbg_general  \
		`uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] TASK : %0t \t Exit \t\t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_gt \
		if ( $time >= `_uvm_sim_internal_dbg_time_start ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] TASK : %0t \t Exit \t\t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_btw \
		if ( ( $time <= `_uvm_sim_internal_dbg_time_end ) && ( $time >= `_uvm_sim_internal_dbg_time_start ) ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] TASK : %0t \t Exit \t\t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`endif
	
`define _uvm_sim_internal_dbg(str) \
	`ifdef _uvm_sim_internal_dbg_general  \
		`uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] PRINT : %0t \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_gt \
		if ( $time >= `_uvm_sim_internal_dbg_time_start ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] PRINT : %0t \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`elsif _uvm_sim_internal_dbg_time_btw \
		if ( ( $time <= `_uvm_sim_internal_dbg_time_end ) && ( $time >= `_uvm_sim_internal_dbg_time_start ) ) `uvm_info(get_full_name(),$sformatf("(-) [INTERNAL:DEBUG][UVM] PRINT : %0t \t %0s \t\t\t in %m",$time,``str``),UVM_LOW) \
	`endif