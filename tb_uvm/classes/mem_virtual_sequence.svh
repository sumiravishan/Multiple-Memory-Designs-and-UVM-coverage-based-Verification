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

`ifndef _MEM_VIRTUAL_SEQUENCE_SVH_
`define _MEM_VIRTUAL_SEQUENCE_SVH_

class mem_virtual_sequence extends uvm_sequence#(mem_sequence_item);
	`uvm_object_utils(mem_virtual_sequence)
	
	`uvm_declare_p_sequencer(mem_virtual_sequencer)

	mem_base_sequence seq_cam_1,seq_apb_1; 
	mem_write_only_sequence seq_cam_2, seq_apb_2;
	mem_read_only_sequence seq_cam_3,seq_apb_3;
	bit [1:0]end_seq =0 ;

	
	function new(string name="");
		super.new(name);
	endfunction

	task pre_body();
		`_uvm_sim_task_enter_internal_dbg("pre_body")
		seq_cam_1 = mem_base_sequence::type_id::create("seq_cam_1");
		seq_cam_2 = mem_write_only_sequence::type_id::create("seq_cam_2");
		seq_cam_3 = mem_read_only_sequence::type_id::create("seq_cam_3");
		seq_apb_1 = mem_base_sequence::type_id::create("seq_apb_1");
		seq_apb_2 = mem_write_only_sequence::type_id::create("seq_apb_2");
		seq_apb_3 = mem_read_only_sequence::type_id::create("seq_apb_3");
		`_uvm_sim_task_exit_internal_dbg("pre_body")
	endtask 
	
	task body();
		`_uvm_sim_task_enter_internal_dbg("body")
		`uvm_info(get_full_name(),"STAR SEQ1",UVM_DEBUG)
		fork : seq1_sequece
			begin 
				seq_cam_1.start(p_sequencer.seqr_cam);
			end 
			begin 
				seq_apb_1.start(p_sequencer.seqr_apb);
			end
			begin 
				wait(end_seq == 1 );
				seq_cam_1.end_seq = 1;
				seq_apb_1.end_seq = 1;
			end 
		join
		`uvm_info(get_full_name(),"END SEQ1 & STAR SEQ2",UVM_DEBUG)
		fork 
			begin : seq2_sequece
				seq_cam_2.start(p_sequencer.seqr_cam);
			end 
			begin 
				seq_apb_2.start(p_sequencer.seqr_apb);
			end
			begin 
				wait(end_seq == 2 );
				seq_cam_2.end_seq = 1;
				seq_apb_2.end_seq = 1;
			end 
		join
		`uvm_info(get_full_name(),"END SEQ2 & STAR SEQ3",UVM_DEBUG)
		fork 
			begin : seq3_sequece
				seq_cam_3.start(p_sequencer.seqr_cam);
			end
			begin 
				seq_apb_3.start(p_sequencer.seqr_apb);
			end			
			begin 
				wait(end_seq == 3 );
				seq_cam_3.end_seq = 1;
				seq_apb_3.end_seq = 1;
			end 
		join
		`uvm_info(get_full_name(),"END SEQ",UVM_LOW)
		`_uvm_sim_task_exit_internal_dbg("body")
	endtask 

endclass

`endif