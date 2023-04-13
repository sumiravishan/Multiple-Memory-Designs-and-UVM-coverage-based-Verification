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
package tb_param_pkg;

parameter param_SIZE = 8;
parameter param_WIDTH_DATA = 8;

parameter sim_cycles = 10000;
parameter rst_duration = 3 ;

//Address width max expected is 32
`ifdef param_scenario1
parameter param_WIDTH_ADDR=$clog2(param_SIZE) * 2;
`elsif param_scenario2
parameter param_WIDTH_ADDR=$clog2(param_SIZE) / 2;
`else
parameter param_WIDTH_ADDR=$clog2(param_SIZE);
`endif

endpackage 
