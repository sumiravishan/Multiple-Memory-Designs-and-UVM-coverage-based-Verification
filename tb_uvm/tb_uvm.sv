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
`timescale 1ns/1ns
module tb_uvm();

import uvm_pkg::*;
`include "uvm_macros.svh"

import tb_param_pkg::*;
import mem_uvm_pkg::*;

bit sysclk,sysrst;
//cam 
bit wr_nrd,req;
bit [param_WIDTH_DATA-1:0] din;
bit [param_WIDTH_ADDR-1:0] addr;
logic [param_WIDTH_DATA-1:0] dout;
logic read_valid,busy,full,almost_full, write_error, invalid_write_state;

//apb
bit PWRITE, PSEL, PENABLE;
bit [param_WIDTH_ADDR-1:0] PADDR;
bit [param_WIDTH_DATA-1:0] PWDATA;
logic [param_WIDTH_DATA-1:0] PRDATA;
logic PREADY;


memory_cam #(.SIZE(param_SIZE),.WIDTH_DATA(param_WIDTH_DATA),.WIDTH_ADDR(param_WIDTH_ADDR) )dut0(.*,.clk(sysclk),.rst(sysrst));
memory_apb #(.SIZE(param_SIZE),.WIDTH_DATA(param_WIDTH_DATA),.WIDTH_ADDR(param_WIDTH_ADDR) )dut1(.*,.PCLK(sysclk),.PRESETn(!sysrst));

mem_drive_interface_cam uvm_itf0(.*);
mem_drive_interface_apb uvm_itf1(.*);

//driving -cam 
assign din = uvm_itf0.din;
assign wr_nrd = uvm_itf0.wr_nrd;
assign addr = uvm_itf0.addr;
assign req = uvm_itf0.req;
//load - cam
assign uvm_itf0.read_valid = read_valid;
assign uvm_itf0.busy = busy;
assign uvm_itf0.full = full;
assign uvm_itf0.almost_full = almost_full;
assign uvm_itf0.write_error = write_error;
assign uvm_itf0.invalid_write_state = invalid_write_state;
assign uvm_itf0.dout = dout;

//driving -apb
assign PWRITE = uvm_itf1.PWRITE;
assign PSEL = uvm_itf1.PSEL;
assign PENABLE = uvm_itf1.PENABLE;
assign PADDR = uvm_itf1.PADDR;
assign PWDATA = uvm_itf1.PWDATA;
//loading -apb
assign uvm_itf1.PRDATA = PRDATA;
assign uvm_itf1.PREADY = PREADY;


initial begin 
	sysclk=0;
	forever #1 sysclk = ~sysclk;
end

initial begin 
	sysrst=1;
	repeat(rst_duration) @(posedge sysclk);
	sysrst=0;
end

initial begin 
	uvm_config_db#(virtual mem_drive_interface_cam)::set(null,"*",$sformatf("mem_drive_interface_cam%0d",0),uvm_itf0);
	uvm_config_db#(virtual mem_drive_interface_apb)::set(null,"*",$sformatf("mem_drive_interface_apb%0d",0),uvm_itf1);
	run_test("mem_test_virtual_seq");
end 

initial begin
	$dumpvars(0, tb_uvm);
end 

endmodule
