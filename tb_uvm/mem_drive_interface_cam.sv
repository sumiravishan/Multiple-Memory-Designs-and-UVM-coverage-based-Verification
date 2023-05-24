`timescale 1ns/1ns
/*///////////////////////////////////////////////////////////////////
////                                                             ////
////  Author: Sumira Fernando                                    ////
////          k.w.s.v.fernando@gmail.com                         ////
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
interface mem_drive_interface_cam(input bit sysclk,sysrst);
	import tb_param_pkg::*;

	bit clk,rst,wr_nrd,req;
	bit [param_WIDTH_DATA-1:0] din;
	bit [param_WIDTH_ADDR-1:0] addr;
    logic [param_WIDTH_DATA-1:0] dout;
	logic read_valid,busy,full,almost_full, write_error, invalid_write_state;

	assign clk = sysclk;
	assign rst = sysrst;
endinterface

