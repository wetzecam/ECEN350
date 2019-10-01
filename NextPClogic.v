`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Cameron Wetzel
//  825004842
// ECEN 350 Lab 8 : NextPCLogic Control Module
//////////////////////////////////////////////////////////////////////////////////

module NextPClogic(
    input [63:0] CurrentPC,
    input [63:0] SignExtImm64,
    input Branch,
    input ALUZero,
    input UnBranch,
    output [63:0] NextPC
    );
    
    // declare internal nets
    wire sel; // controls MUX
    // the following registers hold intermediate values
    reg [63:0] NextTmp;      // Value to -> NextPC
    wire [63:0] SignShift;   // SignExtender*4 
    
    reg [63:0] A;
    reg [63:0] B;
    
    
    
    
    assign sel = UnBranch | (Branch & ALUZero);
    assign SignShift = SignExtImm64 << 2;           // (Sign Extender output) * 4
    
    
    always@(*) begin
        A <= #1 (CurrentPC + 3'b100);
        B <= #2 (CurrentPC + {SignExtImm64[61:0], 1'b0, 1'b0});
    end
    
    assign NextPC = ((A) & {64{(~sel)}}) | ((B) & {64{(sel)}});
    
    //assign #1 NextPC = (sel ? A : B);
    
    // implementation of logic
    //always @ (*) begin
    //    case(sel)
            // No Branch
    //        1'b0: NextTmp <= #1 CurrentPC + 4;
            // Branch
    //        1'b1: NextTmp <= #2 CurrentPC + SignShift;
    //    endcase
        //InterPC <= #1 CurrentPC + 4;
        //InterB  <= #2 CurrentPC + (SignExtImm64 << 2); 
    
    
    //assign #1 NextPC = NextTmp; 
    
endmodule
