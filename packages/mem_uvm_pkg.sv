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
`timescale 1ns/1ns
package mem_uvm_pkg;

	import uvm_pkg::*;
	import mem_design_pkg::mem_op;
	import mem_design_pkg::mem_write;
	import mem_design_pkg::mem_read;
	
	`include "uvm_macros.svh"
	
	`include "_uvm_code_internal_debug_msg.sv"
	
	typedef enum bit [2:0] { report_all, report_write_only, report_read_only, report_specific_addr, report_specific_din, report_specific_dout, report_specific_read_addr, 
				   report_specific_write_addr } custom_uvm_reporting;
	typedef enum bit [1:0] { report_all_time = 0 , report_time_gt, report_time_eq, report_time_btw } custom_uvm_time_reporting ;
	

	covergroup write_operation_coverage(ref bit val_bit, ref mem_op op);
		val_cov: coverpoint val_bit iff ( op == mem_write )  {
			bins bin_zero = {0};
			bins bin_one  = {1};
			bins trans_pos = (0 => 1);
			bins trans_neg = (1 => 0);
		}
	endgroup 
	
	covergroup read_operation_coverage(ref bit val_bit, ref mem_op op);
		val_cov: coverpoint val_bit iff ( op == mem_read )  {
			bins bin_zero = {0};
			bins bin_one  = {1};
			bins trans_pos = (0 => 1);
			bins trans_neg = (1 => 0);
		}
	endgroup 

	covergroup signal_cov(ref bit signal);
		status_cov: coverpoint signal {
			bins bin_zero = {0};
			bins bin_one  = {1};
			bins trans_pos = (0 => 1);
			bins trans_neg = (1 => 0);
		}
	endgroup 

	covergroup signal_level_cov(ref bit signal);
		status_cov: coverpoint signal {
			bins bin_zero = {0};
			bins bin_one  = {1};
		}
	endgroup 
	
	event ev_end_driver_monitor;
	event ev_driver_ended;
	`include "mem_global_config.svh"
	`include "mem_sequence_item.svh"
	typedef uvm_sequencer#(mem_sequence_item) mem_sequencer;
	`include "mem_sequence_lib.svh"
	`include "mem_virtual_sequencer.svh"
	`include "mem_virtual_sequence.svh"
	`include "mem_diver_cam.svh"
	`include "mem_diver_apb.svh"
	`include "mem_monitor_transaction.svh"
	`include "mem_monitor_base.svh"
	`include "mem_monitor_cam.svh"
	`include "mem_monitor_apb.svh"
	`include "mem_scoreboard_base.svh"
	`include "mem_scoreboard_cam.svh"
	`include "mem_scoreboard_apb.svh"
	`include "mem_coverage_base.svh"
	`include "mem_coverage_cam.svh"
	`include "mem_coverage_apb.svh"
	`include "mem_agent_cam.svh"
	`include "mem_agent_apb.svh"
	`include "mem_env_base.svh"
	`include "mem_env_vir_seqr.svh"
	`include "mem_base_test.svh"
	`include "mem_test_virtual_seq.svh"

endpackage