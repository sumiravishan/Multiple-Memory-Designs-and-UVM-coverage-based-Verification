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

`ifndef _MEM_TEST_VIRTUAL_SEQ_SVT_
`define _MEM_TEST_VIRTUAL_SEQ_SVT_

class mem_test_virtual_seq extends mem_base_test;
	`uvm_component_utils(mem_test_virtual_seq)
	
	mem_virtual_sequence vseq;
	mem_env_vir_seqr vir_env0;
	
	function new(string name , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		//super.build_phase(phase);
		`_uvm_sim_fn_enter_internal_dbg("build_phase")
		build_config();
		vir_env0 = mem_env_vir_seqr::type_id::create("vir_env0",this);
		vir_env0.cfg_str = "cfg0";
		`_uvm_sim_fn_exit_internal_dbg("build_phase")
	endfunction
	
	
	
	virtual task run_phase(uvm_phase phase);
		`_uvm_sim_task_enter_internal_dbg("run_phase")
		vseq = mem_virtual_sequence::type_id::create("vseq");
		phase.raise_objection(this);	
		fork 
			begin 
				vseq.start(vir_env0.mem_vseqr); 
			end
			begin 
				repeat(3) begin 
					repeat(tb_param_pkg::sim_cycles) @(posedge cfg0.vif_cam.clk); // Should be sysclk , but since sysclk == vif_cam.clk this is ok
					vseq.end_seq++;
				end 
			end
		join
		->mem_uvm_pkg::ev_end_driver_monitor;
		`_uvm_sim_task_exit_internal_dbg("run_phase")
		phase.drop_objection(this);
	endtask

endclass 

`endif 

