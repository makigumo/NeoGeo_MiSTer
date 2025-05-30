// NeoGeo logic definition
// Copyright (C) 2018 Sean Gonsalves
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// All pins ok except TRES, but apparently never used (something to do with crystal oscillator ?)

module neo_d0(
	input CLK,
	input CLK_EN_24M_P,
	input CLK_EN_24M_N,
	output CLK_24M,
	input nRESET, nRESETP,
	output CLK_12M,
	output CLK_68KCLK,
	output CLK_68KCLKB,
	output CLK_EN_68K_P,
	output CLK_EN_68K_N,
	output CLK_6MB,
	output CLK_1HB,
	output CLK_EN_12M,
	output CLK_EN_12M_N,
	output CLK_EN_6MB,
	output CLK_EN_1HB,
	input M68K_ADDR_A4,
	input nBITWD0,
	input [5:0] M68K_DATA,
	input [15:11] SDA_H,
	input [4:2] SDA_L,
	input nSDRD, nSDWR, nMREQ, nIORQ,
	output nZ80NMI,
	input nSDW,
	output nSDZ80R, nSDZ80W, nSDZ80CLR,
	output nSDROM, nSDMRD, nSDMWR,
	output SDRD0, SDRD1,
	output n2610CS, n2610RD, n2610WR,
	output nZRAMCS,
	output [2:0] BNK,
	output [2:0] P1_OUT,
	output [2:0] P2_OUT
);
	reg [2:0] REG_BNK;
	reg [5:0] REG_OUT;
	
	// Clock divider part
	clocks_sync CLKS(CLK, CLK_EN_24M_P, CLK_EN_24M_N, nRESETP, CLK_24M, CLK_12M, CLK_68KCLK, CLK_68KCLKB, CLK_EN_68K_P, CLK_EN_68K_N, CLK_6MB, CLK_1HB, CLK_EN_12M, CLK_EN_12M_N, CLK_EN_6MB, CLK_EN_1HB);
	
	// Z80 controller part
	z80ctrl Z80CTRL(CLK, SDA_L, SDA_H, nSDRD, nSDWR, nMREQ, nIORQ, nSDW, nRESET, nZ80NMI, nSDZ80R, nSDZ80W,
				nSDZ80CLR, nSDROM, nSDMRD, nSDMWR, SDRD0, SDRD1, n2610CS, n2610RD, n2610WR, nZRAMCS);
	
	assign {P2_OUT, P1_OUT} = REG_OUT;
	assign BNK = REG_BNK;

	always @(posedge CLK) begin
		reg nBITWD0_d;
		nBITWD0_d <= nBITWD0;
		if (!nBITWD0 & nBITWD0_d) begin
			if (M68K_ADDR_A4)
				REG_BNK <= M68K_DATA[2:0];
			else
				REG_OUT <= M68K_DATA[5:0];
		end
		if(~nRESETP) {REG_BNK, REG_OUT} <= 0;
	end
	
endmodule
