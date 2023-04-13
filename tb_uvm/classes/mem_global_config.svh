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

`ifndef _MEM_GLOBAL_CONFIG_SVH_
`define _MEM_GLOBAL_CONFIG_SVH_

class mem_global_config extends uvm_object;
	

	virtual mem_drive_interface_cam vif_cam;
	virtual mem_drive_interface_apb vif_apb;
	int timeout;
	int max_consecative_timeout_count;
	
	bit scb_print_received_pkt = 1;
	bit scb_print_pass_pkt = 1;
	
	bit driver_print_pkt = 1;
	bit monitor_print_pkt = 1;
	
	//reporting options - driver
	mem_uvm_pkg::custom_uvm_reporting cust_rpt_driver = mem_uvm_pkg::report_all;
	mem_uvm_pkg::custom_uvm_time_reporting cust_rpt_time_driver = mem_uvm_pkg::report_all_time;
	
	//reporting options - monitor
	mem_uvm_pkg::custom_uvm_reporting cust_rpt_monitor = mem_uvm_pkg::report_all;
	mem_uvm_pkg::custom_uvm_time_reporting cust_rpt_time_monitor = mem_uvm_pkg::report_all_time;

	
	//reporting options - common
	int unsigned report_addr = 0;
	int unsigned report_din = 0;
	int unsigned report_dout = 0;
	time report_time_start = 0 ;
	time report_time_end = 0;
	
	`uvm_object_utils(mem_global_config)
	
	function new(string name="");
		super.new(name);
	endfunction

endclass 


`endif