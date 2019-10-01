`timescale 1ns / 1ps
`define Zero 64'h0
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2018 03:42:09 PM
// Design Name: 
// Module Name: RegisterFile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RW;
    input [4:0] RA;
    input [4:0] RB;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];
    
    //internal tmp registers for always block assignment of outputs
    reg [63:0] BusAr;
    reg [63:0] BusBr;
    
    always @ (negedge Clk) begin
        
        BusAr <= #2 registers[RA];
        BusBr <= #2 registers[RB];
        
        
        if(RegWr) begin
            case(RW)
                5'd31: begin
                    registers[5'd31] <= #3 64'h0;
                end
                default: begin
                    registers[RW] <= #3 BusW;
                end
            endcase
        end
    end
    
    assign BusA = BusAr;
    assign BusB = BusBr;

endmodule
