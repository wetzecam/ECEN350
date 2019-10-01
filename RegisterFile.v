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
    output reg [63:0] BusA;
    output reg [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RW;
    input [4:0] RA;
    input [4:0] RB;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];
  
  
  
  
  
  
    always @ (negedge Clk) begin
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
    
    
    always@ (posedge Clk) begin
        if(^registers[RA]===1'bX) begin
            #2 assign BusA = {64{1'b0}};
        end
        else begin
            #2 assign BusA = registers[RA]; 
        end
        
        if(^registers[RB]===1'bX) begin
                    #2 assign BusB = {64{1'b0}};
                end
                else begin
                    #2 assign BusB = registers[RB]; 
                end
        
    
    end
    

endmodule
