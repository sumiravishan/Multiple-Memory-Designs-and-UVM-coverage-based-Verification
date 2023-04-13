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
module memory_cam
import mem_design_pkg::*;
(clk, rst, wr_nrd, req, din, addr, dout, read_valid, busy, full, almost_full, write_error, invalid_write_state);


parameter SIZE = param_SIZE;
parameter WIDTH_DATA = param_WIDTH_DATA;
parameter WIDTH_ADDR=param_WIDTH_ADDR;

parameter FILL_SIZE = $clog2(SIZE);

input clk,rst,wr_nrd,req;
input [WIDTH_DATA-1:0] din;
input [WIDTH_ADDR-1:0] addr;
output logic [WIDTH_DATA-1:0] dout;
output logic read_valid,busy,full,almost_full, write_error, invalid_write_state;


parameter param_ADDR_MEM_MAX = SIZE-2;

reg [WIDTH_ADDR-1:0] mem_addr [SIZE-2:0];
reg [WIDTH_ADDR-1:0] request_addr;

reg [WIDTH_DATA-1:0] mem_data [SIZE-2:0];
reg [WIDTH_DATA-1:0] request_data;

reg [FILL_SIZE-1:0] addr_counter;
reg [FILL_SIZE-1:0] mem_fill_count;
reg [FILL_SIZE-1:0] next_addr_to_use;
reg [FILL_SIZE-1:0] current_sorted_address;

reg addr_counter_start;
reg [WIDTH_DATA-1:0] mem_data_addr0;

reg sorted;
reg check_sorting;
reg sort_corrected;

sort_states sort_state;
reg [WIDTH_ADDR-1:0] sort_addr_reg;
reg [WIDTH_ADDR-1:0] sort_addr_start;
reg [WIDTH_ADDR-1:0] sort_addr_end;
reg [WIDTH_ADDR-1:0] sort_addr_middle;
bit first_sort_cycle;
binary_search_dir binary_search_direction;

mem_search_state mem_state;
mem_op mem_operation;

reg counter_rst;

always @(posedge clk) begin : main_logic
	if ( rst ) begin 
		for ( int i=0 ; i < SIZE-1; i++ ) begin //Memory should be reset to 0 during reset - Must
			mem_addr[i] = {WIDTH_ADDR{1'b0}};
			mem_data[i] = {WIDTH_DATA{1'b0}};
		end
		dout <= {WIDTH_DATA{1'b0}};
		read_valid <= 1'b0;
		busy <= 1'b1;
		mem_state <= mem_initial;
		mem_operation <= mem_read;
		addr_counter_start <= 1'b0;
		counter_rst <= 1'b1;
		mem_fill_count <= {FILL_SIZE{1'b0}};
		write_error <= 1'b0;
		invalid_write_state <= 1'b0;
		next_addr_to_use <= {FILL_SIZE{1'b0}};
		mem_data_addr0 <= {WIDTH_DATA{1'b0}};
		sort_corrected <= 1'b0;
		sorted <= 1'b0;
		current_sorted_address <= {FILL_SIZE{1'b0}};
		check_sorting <= 1'b0;
		//sort_usage <= use_addr_counter;
		sort_addr_reg <= {WIDTH_ADDR{1'b0}};
	end else if ( mem_state == mem_initial ) begin 
		mem_state <= req ? mem_req_received: mem_initial;
		busy <= 1'b0;
		addr_counter_start <= 1'b0;
		counter_rst <= 1'b1;
		read_valid <= 1'b0;
		write_error <= 1'b0;
		request_addr <= addr;
		request_data <= din;
		invalid_write_state <= 1'b0;
		dout <= {WIDTH_DATA{1'b0}};
		//sort_usage <= use_addr_counter;
		sort_addr_reg <= {WIDTH_ADDR{1'b0}};
		sort_initiate();
	end else if ( req && ( mem_state == mem_req_received ) ) begin 
		mem_operation <= ( wr_nrd == 1'b1 ) ? mem_write : mem_read ;
		read_valid <= 1'b0;
		busy <= 1'b1;
		mem_state <= ( request_addr == 0 ) ? mem_handle_addr_0 : /* ( sorted == 1 ) ? mem_addr_search_sorted : */ mem_addr_search;
		addr_counter_start <= ( request_addr == 0 ) ? 1'b0: /* ( sorted == 1 ) ? 1'b0 : */ 1'b1;
		counter_rst <= 1'b0;
		sort_initiate();
	end else if ( mem_state == mem_handle_addr_0 ) begin
		if ( mem_operation == mem_write ) begin 
			mem_data_addr0 <= request_data;
		end else begin 
			dout <= mem_data_addr0;
			read_valid <= 1'b1;
		end 
		write_error <= 1'b0;
		mem_state <= mem_initial;	
		busy <= 1'b0;
		sort_initiate();
	end else if ( mem_state == mem_addr_search ) begin 
		if ( mem_fill_count == {WIDTH_ADDR{1'b0}} ) begin
			mem_state <= mem_addr_search_end;
			addr_counter_start <= 1'b0;	
			sort_corrected <= 1'b0;
			sort_addr_reg<= {WIDTH_ADDR{1'b0}};
		end else if ( sorted ) begin 
			/* if ( sort_state == sort_start ) begin 
				// nothing to do
			end else */ if ( sort_state == sort_first ) begin
				addr_counter_start <= ! ( mem_addr[sort_addr_start] == request_addr ); 
				binary_search_direction <= ( mem_addr[sort_addr_start] < request_addr ) ? up : down;
				mem_state <= ( mem_addr[sort_addr_start] == request_addr ) ? mem_addr_found : mem_addr_search;
				sort_addr_reg<= sort_addr_start;
			end else if ( sort_state == sort_middle ) begin
				addr_counter_start <= ! ( mem_addr[sort_addr_middle] == request_addr ); 
				binary_search_direction <= ( mem_addr[sort_addr_middle] < request_addr ) ? up : down;
				mem_state <= ( mem_addr[sort_addr_middle] == request_addr ) ? mem_addr_found : mem_addr_search;	
				sort_addr_reg<= sort_addr_middle;
			end else if ( sort_state == sort_end ) begin
				addr_counter_start <= ! ( mem_addr[sort_addr_end] == request_addr ); 
				binary_search_direction <= ( mem_addr[sort_addr_end] < request_addr ) ? up : down;
				mem_state <= ( mem_addr[sort_addr_end] == request_addr ) ? mem_addr_found : mem_addr_search;	
				sort_addr_reg <= sort_addr_end;
			//end else if ( sort_state == sort_wait ) begin
				//nothing to do 
			end else if ( sort_state == sort_done ) begin 
				addr_counter_start <= 1'b0;
				mem_state <= mem_addr_search_end;
			end
			sort_corrected <= 1'b0;			
		end else if ( mem_addr[addr_counter] == request_addr ) begin 
			mem_state <= mem_addr_found;
			addr_counter_start <= 1'b0;
			sort_corrected <= 1'b0;
			//sort_initiate(); //FIXME: Enhancement
		end else if ( addr_counter == mem_fill_count ) begin 
			mem_state <= mem_addr_search_end;
			addr_counter_start <= 1'b0;
			sort_initiate();
		end else begin 
			mem_state <= mem_addr_search;
			if ( ( current_sorted_address < addr_counter  ) && ( addr_counter != 0 ) ) begin 
				sort_initiate();
			end else begin 
				sort_corrected <= 1'b0;
			end 
		end
	end else if ( ( mem_state == mem_addr_found ) || ( mem_state == mem_addr_search_end ) ) begin 
		addr_counter_start <= 1'b0;
		if ( ( mem_operation == mem_read ) && ( mem_state == mem_addr_found ) )begin 
			dout <= sorted ? mem_data[sort_addr_reg] : mem_data[addr_counter];
			read_valid <= 1'b1;
			write_error <= 1'b0;
		end else if ( mem_operation == mem_read ) begin 
			dout <= {WIDTH_DATA{1'b0}};
			read_valid <= 1'b1;
			write_error <= 1'b0;
		end else if ( ( mem_operation == mem_write ) && ( mem_state == mem_addr_found ) && ( request_data != 0) )begin
			mem_data[sorted ? sort_addr_reg : addr_counter] <= request_data;		
			read_valid <= 1'b0;
			write_error <= 1'b0;
		end else if ( ( mem_operation == mem_write ) && ( mem_state == mem_addr_search_end ) && ( request_data != 0) && ( full ) )begin
			write_error <= 1;
			read_valid <= 1'b0;
		end else if ( ( mem_operation == mem_write ) && ( mem_state == mem_addr_found ) && ( request_data == 0) )begin
			mem_data[ sorted ? sort_addr_reg : addr_counter ] <= ( ( sorted ? sort_addr_reg : addr_counter ) + 1 != next_addr_to_use ) ? mem_data[next_addr_to_use-1] : {WIDTH_DATA{1'b0}}; //FIXME: Think again
			
			if ( ( sorted ? sort_addr_reg : addr_counter ) + 1 != next_addr_to_use ) begin 
				mem_addr[next_addr_to_use-1] <= {WIDTH_DATA{1'b0}};
				mem_addr[ sorted ? sort_addr_reg : addr_counter ] <= mem_addr[next_addr_to_use-1];
				
				current_sorted_address <= {FILL_SIZE{1'b0}};
				sorted <= 1'b0;
				check_sorting <= 1'b1;
			end else begin 
				mem_addr[ ( sort_corrected == 1'b0 ) ?  ( sorted ? sort_addr_reg : addr_counter ) :   ( ( request_addr == mem_addr[addr_counter-1] ) && ( sort_corrected == 1'b1 ) ) ? addr_counter-1 : addr_counter ] <= {WIDTH_ADDR{1'b0}};	
			end 
			
			mem_fill_count <= mem_fill_count -1;
			next_addr_to_use <= next_addr_to_use -1;
			read_valid <= 1'b0;
			write_error <= 1'b0;
		end else if ( ( mem_operation == mem_write ) && ( mem_state == mem_addr_search_end ) && ( request_data != 0) && ( !full ) )begin
			mem_addr[next_addr_to_use] <= request_addr;
			mem_data[next_addr_to_use] <= request_data;
			next_addr_to_use <= next_addr_to_use + 1;
			mem_fill_count <= mem_fill_count + 1;
			read_valid <= 1'b0;
			write_error <= 1'b0; 
			current_sorted_address <= {FILL_SIZE{1'b0}};
			check_sorting <= 1'b1;
			sorted <= 1'b0;
		end else begin 
			//New Memory write request , but value is zero
			//Any write request other than adrr=0 , will be an error write
			read_valid <= 1'b0;
			write_error <= full; 
		end
		invalid_write_state <= 1'b0;
		mem_state <= mem_initial;
		busy <= 1'b0;
		
	end else begin 
		mem_state <= mem_initial;
		invalid_write_state <= 1'b1;
	end 
end 

assign full = ( mem_fill_count == param_ADDR_MEM_MAX + 1) ;
assign almost_full = ( mem_fill_count == param_ADDR_MEM_MAX  ) ;
 
task automatic sort_initiate();
		if ( mem_fill_count > 1 ) begin 
			if ( sorted == 1'b0 ) begin
				if ( current_sorted_address ==  {FILL_SIZE{1'b0}} ) begin 
					current_sorted_address = current_sorted_address + 1;
					sorted <= 1'b0;
					sort_corrected <= 1'b0;
				end else if ( current_sorted_address < mem_fill_count ) begin 
					 if ( ( mem_addr[current_sorted_address] <  mem_addr[current_sorted_address-1] ) && ( mem_addr[current_sorted_address] != 0 ) )  begin  // ordering start		
						mem_addr[current_sorted_address-1] <= mem_addr[current_sorted_address] ;
						mem_data[current_sorted_address-1] <= mem_data[current_sorted_address] ;
						mem_addr[current_sorted_address] <= mem_addr[current_sorted_address-1] ;
						mem_data[current_sorted_address] <= mem_data[current_sorted_address-1] ; 
						sort_corrected <= 1'b1;
						check_sorting <= 1'b0;
						current_sorted_address <= {FILL_SIZE{1'b0}};
					end else begin 
						sort_corrected <= 1'b0;
						current_sorted_address <= current_sorted_address + 1;
					end 
					sorted <= 1'b0;
				end else begin 
					sorted <= ( ( current_sorted_address  == mem_fill_count ) && ( check_sorting = 1'b1 ) );
					sort_corrected <= 1'b0;
					current_sorted_address <= ( ( current_sorted_address == mem_fill_count ) && ( check_sorting = 1'b1 ) ) ? current_sorted_address : {FILL_SIZE{1'b0}};
					check_sorting <= ( ( current_sorted_address == mem_fill_count ) && ( check_sorting = 1'b1 ) ) ? check_sorting : 1'b1;
				end 
			end else begin 
				sorted <= ( current_sorted_address  == mem_fill_count ) && ( check_sorting = 1'b1 );
				sort_corrected <= 1'b0;
				current_sorted_address <= ( ( current_sorted_address == mem_fill_count ) && ( check_sorting = 1'b1 ) ) ? current_sorted_address : {FILL_SIZE{1'b0}};
				check_sorting <= ( ( current_sorted_address == mem_fill_count ) && ( check_sorting = 1'b1 ) ) ? check_sorting : 1'b1; 
			end 
		end else begin 
			sorted <= 1'b0;
			sort_corrected <= 1'b0;
			current_sorted_address <= {FILL_SIZE{1'b0}};
			check_sorting <= 1'b1;
		end 
endtask 


always @(posedge clk) begin : add_cnt
	if ( counter_rst | rst ) begin 
		addr_counter <= {FILL_SIZE{1'b0}};	
	end else if ( ( ! sorted ) && ( addr_counter_start == 1'b1 ) && ( addr_counter != mem_fill_count ) && ( mem_addr[addr_counter] != request_addr ) ) begin 
		addr_counter <= addr_counter + 1;
	end else begin 
		addr_counter <= addr_counter;
	end 
end 

always @(posedge clk) begin 
	if ( counter_rst | rst ) begin 
		sort_state <= sort_start;
		first_sort_cycle <= 1;
		sort_addr_start <= 0;
		sort_addr_end <= 0;		
	end else if ( sorted ) begin 
		if ( sort_state == sort_start ) begin 		
			sort_state <= first_sort_cycle ? ( ( ( 0 == mem_fill_count ) || ( addr_counter_start == 0 ) ) ? sort_done : sort_first ) : 
						  addr_counter_start ? ( (sort_addr_start==sort_addr_end) ? sort_end : sort_first ) : sort_done ;
			sort_addr_start <= first_sort_cycle ? 0 : sort_addr_start ;
			sort_addr_middle <= first_sort_cycle ? ( (mem_fill_count == 0 ) ? 0 : (mem_fill_count-1) / 2 ) : ( sort_addr_start + sort_addr_end ) / 2 ;
			sort_addr_end <= first_sort_cycle ? ( (mem_fill_count == 0 ) ? 0 :  mem_fill_count-1) : sort_addr_end ;
			first_sort_cycle <= 0;
		end else if ( sort_state == sort_first ) begin 
			sort_state <= sort_middle ;
		end else if ( sort_state == sort_middle ) begin 
			sort_state <= ( binary_search_direction == down ) ? sort_done : sort_end;
		end else if ( sort_state == sort_end ) begin 
			sort_state <= ( binary_search_direction == down ) ? sort_start : sort_wait ;
			
			sort_addr_start <= ( binary_search_direction == down ) ? /* ( ( sort_addr_start + 1 ) > ( sort_addr_middle - 1 ) ) ? ( sort_addr_middle - 1 ) : ( sort_addr_start + 1 ) > sort_addr_middle ? sort_addr_middle : */ ( sort_addr_start + 1 ) : sort_addr_start; 
			
			sort_addr_end <= ( binary_search_direction == down ) ? ( /*( sort_addr_middle - 1 ) < 0 )?  0 : ( ( ( sort_addr_middle - 1 ) < ( sort_addr_start + 1 ) ) ? ( sort_addr_start + 1 ) : */ ( sort_addr_middle - 1 ) ) : sort_addr_end; 
				
		end else if ( sort_state == sort_wait ) begin 
			sort_state <= ( binary_search_direction == down ) ? ( ( sort_addr_end== sort_addr_start + 1 ) ? sort_done : sort_start ) : sort_done ;
				
			sort_addr_start <= ( binary_search_direction == down ) ? /* ( ( sort_addr_middle + 1 ) > ( sort_addr_end - 1 ) ) ? ( sort_addr_end - 1 ) : ( sort_addr_middle + 1 ) > sort_addr_end ? sort_addr_end : */ ( sort_addr_middle + 1 ) : sort_addr_start;
				
			sort_addr_end <= ( binary_search_direction == down ) ?  ( /* ( sort_addr_end - 1 ) < 0 )?  0 : ( ( ( sort_addr_end - 1 ) < ( sort_addr_middle + 1 ) ) ? ( sort_addr_middle + 1 ) : */ ( sort_addr_end - 1 ) ) : sort_addr_end;
				
		end else begin 
			sort_state <= sort_done;
		end 
	end 
	
end 

endmodule 
