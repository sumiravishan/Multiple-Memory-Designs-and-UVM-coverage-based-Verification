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

`ifndef _MEM_DRIVER_CAM_SVH_
`define _MEM_DRIVER_CAM_SVH_

class mem_driver_cam extends uvm_driver#(mem_sequence_item);
	`uvm_component_utils(mem_driver_cam)
	mem_sequence_item pkt;
	string cfg_str;
	mem_global_config cfg; 
	
	function new(string name , uvm_component parent);
		super.new(name,parent);
	endfunction 
	
	virtual function bit packet_report_check();
		`_uvm_sim_fn_enter_internal_dbg("packet_report_check")
		packet_report_check = 0;
		case(cfg.cust_rpt_driver) 
			mem_uvm_pkg::report_write_only: packet_report_check = ( pkt.mem_operation == mem_design_pkg::mem_write);
			mem_uvm_pkg::report_read_only: packet_report_check = ( pkt.mem_operation == mem_design_pkg::mem_read);
			mem_uvm_pkg::report_specific_addr: packet_report_check = ( pkt.addr == cfg.report_addr );
			mem_uvm_pkg::report_specific_din: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_read) && ( pkt.data == cfg.report_din ) );
			mem_uvm_pkg::report_specific_read_addr: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_read) && ( pkt.addr == cfg.report_addr ) );
			mem_uvm_pkg::report_specific_write_addr: packet_report_check = ( ( pkt.mem_operation == mem_design_pkg::mem_write) && ( pkt.addr == cfg.report_addr ) );
			default: packet_report_check = 1;
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
	
	virtual task run_phase(uvm_phase phase);
		`_uvm_sim_task_enter_internal_dbg("run_phase")
		if ( ! uvm_config_db#(mem_global_config)::get(null, "",cfg_str, cfg) ) begin 
			`uvm_fatal(get_full_name(),$sformatf("Unable to get the Configuration %0s",cfg_str))
		end
		phase.raise_objection(this); 
			fork 
				begin  
					@(posedge cfg.vif_cam.clk);
					wait( cfg.vif_cam.rst == 0 );
					forever begin 
						if ( !cfg.vif_cam.rst ) begin 
							seq_item_port.get_next_item(pkt);
							if ( pkt != null ) begin 
							    if ( cfg.driver_print_pkt ) begin 
									if ( packet_report_check() == 1 ) pkt.print();
								end 
								if ( pkt.mem_operation == mem_design_pkg::mem_write) begin 
									mem_write_drive();
								end else begin 
									mem_read_drive();
								end 							
							end else begin 
								`uvm_fatal(get_full_name(),"Received Null Packet")
							end 
							seq_item_port.item_done();
						end else begin 
							@(posedge cfg.vif_cam.clk); // This is must other wise simulation hangs
						end
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

	virtual task mem_write_drive();
		`_uvm_sim_task_enter_internal_dbg("mem_write_drive")
		if ( cfg.vif_cam != null ) begin 
			fork : mem_write
				begin 
					wait( cfg.vif_cam.busy === 0 );
					@(posedge cfg.vif_cam.clk);
					cfg.vif_cam.wr_nrd <= 1;
					cfg.vif_cam.addr <= pkt.addr;
					cfg.vif_cam.din <= pkt.data;
					cfg.vif_cam.req <=1;
					@(posedge cfg.vif_cam.clk);
					`_uvm_sim_internal_dbg("Waiting for Process start")
					wait(  cfg.vif_cam.busy==1);
					cfg.vif_cam.req <=0;
					`_uvm_sim_internal_dbg("Waiting for Process Ends")
					wait( cfg.vif_cam.busy==0);
				end
				begin 
					@( cfg.vif_cam.rst == 1 );	
					`_uvm_sim_internal_dbg("Reset Occured")
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
		if ( cfg.vif_cam != null ) begin 
			fork : mem_read
				begin 
					wait( cfg.vif_cam.busy === 0 );
					@(posedge cfg.vif_cam.clk);
					cfg.vif_cam.wr_nrd <= 0;
					cfg.vif_cam.addr <= pkt.addr;
					cfg.vif_cam.req <= 1;
					@(posedge cfg.vif_cam.clk);
					`_uvm_sim_internal_dbg("Waiting for Process start")
					wait(  cfg.vif_cam.busy==1);
					cfg.vif_cam.req <= 0;
					`_uvm_sim_internal_dbg("Waiting for Process Ends")
					wait( cfg.vif_cam.busy==0);
				end
				begin 
					@( cfg.vif_cam.rst == 1 );	
					`_uvm_sim_internal_dbg("Reset Occured")					
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
