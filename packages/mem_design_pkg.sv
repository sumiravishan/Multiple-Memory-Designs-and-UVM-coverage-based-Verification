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
package mem_design_pkg;

typedef enum bit [2:0] { mem_initial=0,mem_req_received,mem_handle_addr_0,mem_addr_search,mem_addr_found, mem_addr_search_end, mem_addr_search_sorted, mem_invalid_state0 } mem_search_state;
typedef enum bit { mem_read=0, mem_write } mem_op;
typedef enum bit [2:0] { sort_start, sort_first,sort_middle, sort_end, sort_wait, sort_done } sort_states; 
typedef enum bit { up=0, down } binary_search_dir;

typedef enum bit [1:0] { apb_mem_wait, apb_mem_req_received, apb_mem_req_done } apb_mem_states;

parameter param_SIZE = 8;
parameter param_WIDTH_DATA = 8;
`ifdef param_scenario1
parameter param_WIDTH_ADDR=$clog2(param_SIZE) * 2;
`elsif param_scenario2
parameter param_WIDTH_ADDR=$clog2(param_SIZE) / 2;
`else
parameter param_WIDTH_ADDR=$clog2(param_SIZE);
`endif

endpackage