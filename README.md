# Multiple-Memory-Designs-and-UVM-coverage-based-Verification
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

Multiple Memory Simulataneous Testing with uvm + functional coverage + constrained randomization - For Reference purposes
  supported
      Two memory designs : 
		- CAM Memory  : This includes regular sorting mechanism of internal address array. Reduce address search latency
		- General Memory with APB access
      Read/Write checks with virtual sequence with self-verifing design logic in the scoreboard :
		- Random Test 
		- Write only Test 
		- Read only Test
      Customized uvm reporting for internal components 
	  Fully parameterized design and verification environment
	  Easy extendable ( parameterized ) to run Millions of simulation cycles simulation with different sized Memory
  Simulator
      Xilinx xsim free simulator ( 2021 or later ) 
	  Easy setup to convert to other commercial simulator
	  Use gtkwave to open the waveform file which is free and fast

  folder
    ./src         : SystemVerilog memory designs
    ./packages    : SystemVerilog packages for design , testbench and uvm 
    ./tb_uvm      : SystemVerilog testbench , interfaces and uvm classes
    ./inc         : Include files for verification
    ./run         : Run folder with file list and Makefile


How to run:

1. set up your test env
  1.1 Make sure to install simulator and gtkwave is installed or change the Makefile and filelist options according to the simulator requirement

  1.2 Go to run folder and execute any make target after clean

  1.3 Check the coverage results in rep1 folder 

2. how to run example
  cd run
  make clean run_uvm_default_scenario
  
3. If you wish to change any parameter value for verification and design together , change the parameters in tb_param_pkg.sv only. 


