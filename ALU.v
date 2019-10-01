`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define LSL 4'b0011
`define LSR 4'b0100
`define SUB 4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64;

    output  [n-1:0] BusW;
    input   [n-1:0] BusA, BusB;
    input   [3:0] ALUCtrl;
    output  Zero;
    
    reg     [n-1:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            `AND: begin
                BusW <= #20 (BusA & BusB);
            end
            `OR: begin
                BusW <= #20 (BusA | BusB);
            end
            `ADD: begin
                BusW<= #20 (BusA + BusB);
            end
            `LSL: begin
                BusW<= #20 (BusA << BusB);
            end
            `LSR: begin
                BusW <= #20 (BusA >> BusB);
             end
             `SUB: begin
                BusW <= #20 (BusA - BusB);
             end
             `PassB: begin
                BusW <= #20 (BusB);
              end
              default: begin
                BusW <= #20 64'd0;
              end
        endcase
    end

   assign #1 Zero = (&(~BusW));
endmodule



/*
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2018 04:01:25 PM
// Design Name: 
// Module Name: ALU
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


module ALU(BusOut, BusAi, BusBi, ALUCtrl, Zero);
    
    //Control Parameters
    parameter AND = 4'b0000,
              OR = 4'b0001,
              ADD = 4'b0010,
              LSL = 4'b0011,
              LSR = 4'b0100,
              SUB = 4'b0110,
              PassB = 4'b0111;

              
    parameter n = 64;
    
    output [n-1:0] BusOut;
    input  [n-1:0] BusAi, BusBi;
    input  [3:0] ALUCtrl;
    output Zero;
    
    reg [63:0] BusW;
    reg [63:0] BusA;
    reg [63:0] BusB;
    
    //BusA <= BusAi;
    //BusB <= BusBi;
    
    always@(ALUCtrl or BusA or BusB) begin
        BusA <= BusAi;
        BusB <= BusBi;
    
        case(ALUCtrl)
            // AND
            4'b0000: begin                  // AND
                 BusW <= #20 (BusA & BusB);
             end
            // OR
            4'b0001: begin                  // OR
                BusW <= #20 BusA | BusB;
            end
            // ADD                          // ADD
            4'b0010: begin
                BusW <= #20 BusA + BusB;
            end
            // LSL                          // LSL
            4'b0011: begin
                BusW <=  #20 BusA << BusB;
            end
            // LSR                          // LSR
            4'b0100: begin
                BusW <= #20 BusA >> BusB;
            end
            // SUB                          // SUB
            4'b0110: begin
                BusW <= #20 (BusA - BusB);
            end
            // PassB                        // PassB
            4'b0111: begin
                BusW <= #20 BusB;
            end 
            default: begin
                BusW <= #20 64'b0;
            end
        endcase
        
    end
    assign BusOut = BusW;
    assign #1 Zero = (&(~BusW));
endmodule
*/