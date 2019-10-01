`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2018 03:36:18 PM
// Design Name: 
// Module Name: SignExtender
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


module SignExtender(BusImm, Imm32, Ctrl);
    output reg [63:0] BusImm;
    input wire [31:0] Imm32;
    input wire Ctrl;
    
    // internal nets
    reg extBit;
    //wire F;
    reg [63:0] TMP;
    //wire [1:0] op;
    
    
    //assign F = (~(Imm32[31] & Imm32[30]) & Imm32[25]) | ((Imm32[31] & ~Imm32[30]) & Imm32[24]) | ((Imm32[31] & Imm32[30]) & Imm32[20]);
    //assign #1 extBit = (Ctrl ? 1'b0 : F);
    //assign op = Imm32[31:30];
    
    always@(Imm32) begin
        case(Imm32[31:30])
            2'b00: begin
                extBit = #1 (Imm32[25]);
                BusImm = {{38{extBit}}, Imm32[25:0]};
            end
            2'b10: begin
                extBit = #1 (Ctrl & Imm32[24]);
                BusImm  = {{45{extBit}}, Imm32[23:5]};
            end
            2'b11: begin
                extBit = #1 (Ctrl & Imm32[20]);
                BusImm  = {{55{extBit}}, Imm32[20:12]};
            end
            default: TMP <= 64'b0;
        endcase
    
    end
    
    
    //assign BusImm = TMP;
    
    //assign #1 extBit = (Ctrl ? 1'b0 : Imm32[20]);
    //assign BusImm = {{55{extBit}}, Imm32[20:12]};
    
    
    
    
    
endmodule

