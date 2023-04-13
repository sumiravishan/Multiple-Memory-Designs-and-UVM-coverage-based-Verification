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
module memory_apb
import mem_design_pkg::*;
(PCLK, PRESETn, PADDR, PWRITE, PSEL, PENABLE, PWDATA, PREADY, PRDATA);

parameter SIZE = param_SIZE;
parameter WIDTH_DATA = param_WIDTH_DATA;
parameter WIDTH_ADDR= param_WIDTH_ADDR;

input PCLK, PRESETn, PWRITE, PSEL, PENABLE;
input [WIDTH_ADDR-1:0] PADDR;
input [WIDTH_DATA-1:0] PWDATA;
output reg [WIDTH_DATA-1:0] PRDATA;
output PREADY;

apb_mem_states apb_mem_state;

bit [WIDTH_DATA-1:0] mem [SIZE-1:0];

assign PREADY = !PRESETn ? 1'b0 : ( ( apb_mem_state == apb_mem_wait ) && ( PENABLE == 1 ) && ( PSEL == 1 ) ) ? 1'b0 :  ( ( apb_mem_state == apb_mem_wait ) || ( apb_mem_state == apb_mem_req_done ) ) ? 1'b1 : 1'b0 ;

always @(posedge PCLK) begin 
	if ( ! PRESETn ) begin 
		apb_mem_state <= apb_mem_wait;
		PRDATA <= {WIDTH_ADDR{1'b0}};
	end else begin 
		case(apb_mem_state)
			apb_mem_wait: apb_mem_state <= ( ( PENABLE == 1 ) && ( PSEL == 1 ) ) ? apb_mem_req_received : apb_mem_wait;
			apb_mem_req_received : begin 
				if ( PADDR < SIZE ) begin 
					if ( PWRITE == 1 ) begin 
						mem[PADDR] <= PWDATA;
					end else begin
						PRDATA <= mem[PADDR];
					end
				end else begin 
					PRDATA <= {WIDTH_ADDR{1'b0}};
				end 
				apb_mem_state <= apb_mem_req_done;
			end 
			apb_mem_req_done : apb_mem_state <= apb_mem_wait; 
		endcase
	end 
end

endmodule
