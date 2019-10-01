`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Cameron Wetzel
//  825004842
// ECEN 350 Lab 8 : ALU Control unit
//////////////////////////////////////////////////////////////////////////////////


module ALUControl(
    input [1:0] ALUop,
    input [10:0] OpCode,
    output [3:0] ALUCtrl
    );
    
    // Boolean equations derived from truth table in lab Manual
    
     assign #2 ALUCtrl[0] = (~ALUop[1] & ALUop[0]) | (ALUop[1] & ~ALUop[0] & OpCode[8]);
     assign #2 ALUCtrl[1] = (~(ALUop[1]) | (ALUop[1] & OpCode[3] & (~ALUop[0])));
     assign #2 ALUCtrl[2] = (ALUop[0] | (ALUop[1] & OpCode[9]));
    
    assign #2 ALUCtrl[3] =  ALUop[1] & ~ALUop[1];//1'b0;   // Currently no Cases where ALUCtrl[3] should be asserted
    
endmodule
