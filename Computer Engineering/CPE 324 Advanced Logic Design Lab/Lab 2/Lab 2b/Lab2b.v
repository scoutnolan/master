// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Alexandra Du			:| 06/01/2016:| Added Verilog file
// ============================================================================


//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

//`define ENABLE_ADC_CLOCK
//`define ENABLE_CLOCK1
//`define ENABLE_CLOCK2
//`define ENABLE_SDRAM
//`define ENABLE_HEX0
//`define ENABLE_HEX1
//`define ENABLE_HEX2
//`define ENABLE_HEX3
//`define ENABLE_HEX4
//`define ENABLE_HEX5
`define ENABLE_KEY
`define ENABLE_LED
`define ENABLE_SW
//`define ENABLE_VGA
//`define ENABLE_ACCELEROMETER
//`define ENABLE_ARDUINO
`define ENABLE_GPIO

module Lab2b(

	//////////// ADC CLOCK: 3.3-V LVTTL //////////
`ifdef ENABLE_ADC_CLOCK
	input 		          		ADC_CLK_10,
`endif
	//////////// CLOCK 1: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK1
	input 		          		MAX10_CLK1_50,
`endif
	//////////// CLOCK 2: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK2
	input 		          		MAX10_CLK2_50,
`endif

	//////////// SDRAM: 3.3-V LVTTL //////////
`ifdef ENABLE_SDRAM
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,
`endif

	//////////// SEG7: 3.3-V LVTTL //////////
`ifdef ENABLE_HEX0
	output		     [7:0]		HEX0,
`endif
`ifdef ENABLE_HEX1
	output		     [7:0]		HEX1,
`endif
`ifdef ENABLE_HEX2
	output		     [7:0]		HEX2,
`endif
`ifdef ENABLE_HEX3
	output		     [7:0]		HEX3,
`endif
`ifdef ENABLE_HEX4
	output		     [7:0]		HEX4,
`endif
`ifdef ENABLE_HEX5
	output		     [7:0]		HEX5,
`endif

	//////////// KEY: 3.3 V SCHMITT TRIGGER //////////
`ifdef ENABLE_KEY
	input 		     [1:0]		KEY,
`endif

	//////////// LED: 3.3-V LVTTL //////////
`ifdef ENABLE_LED
	output		     [9:0]		LEDR,
`endif

	//////////// SW: 3.3-V LVTTL //////////
`ifdef ENABLE_SW
	input 		     [9:0]		SW,
`endif

	//////////// VGA: 3.3-V LVTTL //////////
`ifdef ENABLE_VGA
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,
`endif

	//////////// Accelerometer: 3.3-V LVTTL //////////
`ifdef ENABLE_ACCELEROMETER
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,
`endif

	//////////// Arduino: 3.3-V LVTTL //////////
`ifdef ENABLE_ARDUINO
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
`endif

	//////////// GPIO, GPIO connect to GPIO Default: 3.3-V LVTTL //////////
`ifdef ENABLE_GPIO
	inout 		    [35:0]		GPIO
`endif
);
eight_bit_sub_add lab2_uut (
	 .A ({SW[4:1],{4{SW[0]}}}),
	 .B ({SW[9:6],{4{SW[5]}}}),
	 .B_CIN (KEY[0]),
	 .SUB_ADD (KEY[1]),
	 .D_S (LEDR[7:0]),
	 .B_COUT (LEDR[8])
);
endmodule
//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  Structural coding
//=======================================================
// Structural Representation of Adder/Subtractor Module
// presented in Part I of Laboratory Experiment
// B. Earl Wells -- University of Alabama Huntsville, 2014
// This version places all component modules in a single file
// Note: it is also possible to include each of the component
// modules in separate files and set up the profile such that
// it references each of these files.
// It is good practice in Quartus to give the project the same
// name as the top-level module

// Top level module
// eight-bit subtractor/adder
module eight_bit_sub_add(D_S,B_COUT,A,B,B_CIN,SUB_ADD);
	output [7:0] D_S;
	output B_COUT;
	input [7:0] A,B;
	input B_CIN,SUB_ADD;
	wire n0;
	four_bit_sub_add C0(D_S[3:0],n0,A[3:0],B[3:0],B_CIN,SUB_ADD);
	four_bit_sub_add C1(D_S[7:4],B_COUT,A[7:4],B[7:4],n0,SUB_ADD);
endmodule

// four-bit subtractor/adder
module four_bit_sub_add(d_s,b_cout,a,b,b_cin,sub_add);
	output [3:0] d_s;
	output b_cout;
	input [3:0] a,b;
	input b_cin,sub_add;
	wire n0,n1,n2;
	fullsubadd C0(d_s[0],n0,a[0],b[0],b_cin,sub_add);
	fullsubadd C1(d_s[1],n1,a[1],b[1],n0,sub_add);
	fullsubadd C2(d_s[2],n2,a[2],b[2],n1,sub_add);
	fullsubadd C3(d_s[3],b_cout,a[3],b[3],n2,sub_add);
endmodule

// full subtractor/adder
module fullsubadd(dif_sum,b_cout,x,y,b_cin,sub_add);
	output dif_sum,b_cout;
	input x,y,b_cin,sub_add;
	wire n0,n1,n2,n3,n4;
	not C0(n0,x);
	mux2_1 C1(n1,x,n0,sub_add);
	and C2(n2,y,n1);
	and C3(n3,y,b_cin);
	and C4(n4,n1,b_cin);
	or C5(b_cout,n2,n3,n4);
	xor C6(dif_sum,x,y,b_cin);
endmodule

// 2 to 1 multiplexer
module mux2_1(o,i0,i1,sel);
	output o;
	input i0,i1,sel;
	wire n0,n1,n2;
	not G0(n0,sel);
	and G1(n1,i0,n0);
	and G2(n2,i1,sel);
	or  G3(o,n1,n2);
endmodule


