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

`ifndef _MEM_MONITOR_BASE_SVH_
`define _MEM_MONITOR_BASE_SVH_

class mem_monitor_base extends uvm_monitor;
	`uvm_component_utils(mem_monitor_base)
	string cfg_str;
	mem_global_config cfg;
	mem_monitor_transaction pkt;
	int internal_count;
	int consecative_timeout_count;
	bit packet_created;
	bit reset_occured;
	
	uvm_analysis_port #(mem_monitor_transaction)broadcast_port;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		broadcast_port = new("broadcast_port",this);
		cfg = mem_global_config::type_id::create("cfg");
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction 

	function bit packet_report_check();
		`_uvm_sim_fn_enter_internal_dbg("packet_report_check")
		packet_report_check = 0;
		case(cfg.cust_rpt_driver) 
			mem_uvm_pkg::report_all: packet_report_check = 1;
			mem_uvm_pkg::report_write_only: packet_report_check = ( pkt.mem_operation == mem_design_pkg::mem_write);
			mem_uvm_pkg::report_read_only: packet_report_check = ( pkt.mem_operation == mem_design_pkg::mem_read);
			mem_uvm_pkg::report_specific_addr: packet_report_check = ( pkt.addr == cfg.report_addr );
			mem_uvm_pkg::report_specific_din: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_read) && ( pkt.din == cfg.report_din ) );
			mem_uvm_pkg::report_specific_din: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_read) && ( pkt.dout == cfg.report_dout ) );
			mem_uvm_pkg::report_specific_read_addr: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_read) && ( pkt.addr == cfg.report_addr ) );
			mem_uvm_pkg::report_specific_write_addr: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_write) && ( pkt.addr == cfg.report_addr ) );
			default: packet_report_check = 0;
		endcase
		if ( packet_report_check == 1 ) begin 
			packet_report_check = 0;
			case(cfg.cust_rpt_time_driver) 
				mem_uvm_pkg::report_time_gt: packet_report_check = ( $time > cfg.report_time_start ) ;
				mem_uvm_pkg::report_time_eq: packet_report_check = ( $time == cfg.report_time_start ) ;
				mem_uvm_pkg::report_time_btw: packet_report_check = ( ( $time > cfg.report_time_start ) && ( $time < cfg.report_time_end ) ) ;
				default: packet_report_check = 1;
			endcase	
		end
		`_uvm_sim_fn_exit_internal_dbg("packet_report_check")
	endfunction 

	task run_phase(uvm_phase phase);
		`_uvm_sim_task_enter_internal_dbg("run_phase")
		if ( ! uvm_config_db#(mem_global_config)::get(null, "",cfg_str, cfg) ) begin 
			`uvm_fatal(get_full_name(),$sformatf("Unable to get the Configuration %0s",cfg_str))
		end
		phase.raise_objection(this);
			fork 
				begin 
					forever begin
						internal_count = 0;
						packet_created = 0;
						reset_occured = 0;
						`_uvm_sim_internal_dbg("Initiate packet collecting")
						get_mem_pkt();
						
						if ( ( reset_occured == 1 ) && ( packet_created == 1 ) ) begin 
							`uvm_warning(get_full_name(),"Reset occured in between transaction")
						end else if ( ( reset_occured == 0 ) && ( packet_created == 1 ) ) begin 
							if ( cfg.monitor_print_pkt ) begin 
								if ( packet_report_check() == 1 ) pkt.print();
							end
							`_uvm_sim_internal_dbg("Sending the packet to scoreboard")
							broadcast_port.write(pkt);
							consecative_timeout_count=0;
						end 
						if ( reset_occured == 1 ) begin
							@(posedge cfg.vif_cam.clk); // Should be sysclk , but since sysclk == vif_cam.clk this is ok
						end
						`_uvm_sim_internal_dbg("Ready to collect next packet")
					end 
				end 
				begin 
					@(mem_uvm_pkg::ev_end_driver_monitor);
				end
			join_any
			disable fork;
		`_uvm_sim_task_exit_internal_dbg("run_phase")
		phase.drop_objection(this);
	endtask 
	
	virtual task get_mem_pkt();
		`_uvm_sim_task_enter_internal_dbg("get_mem_pkt")
		`_uvm_sim_task_exit_internal_dbg("get_mem_pkt")
	endtask 
	
	virtual function void timeout_logic();
		`_uvm_sim_task_enter_internal_dbg("get_mem_pkt")
		internal_count++;
		if ( internal_count == cfg.max_consecative_timeout_count ) begin 
			consecative_timeout_count++;
			if ( consecative_timeout_count == cfg.max_consecative_timeout_count ) begin
				`uvm_error(get_full_name(), "Monitor reach Timeout for the packet" ) 
				`uvm_fatal(get_full_name(), "Monitor reach Max consecative Timeout count")
			end else begin 
				`uvm_error(get_full_name(), "Monitor reach Timeout for the packet" ) 
			end
		end else begin 
			`uvm_warning(get_full_name(), "Timeout occured.............")
		end 
	endfunction

endclass 


`endif
