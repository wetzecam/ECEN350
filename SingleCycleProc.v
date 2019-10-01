`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cameron Wetzel
// 
// Create Date:    12:16:03 03/10/2009 
// Design Name: 
// Module Name:    SingleCycleProc 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SingleCycleProc(CLK, Reset_L, startPC, currentPC, dMemOut);//, Debug, DebBB, debo, debRegF, Oopcode, ALUBusses, ALUCont, ALUins, signext);
   input CLK;
   input Reset_L;
   input [63:0] startPC;
   output [63:0] currentPC;
   output [63:0] dMemOut;
   
   //These for Personal Debugging!
   /*
   output [64:0] Debug;
   output [63:0] DebBB;
   output [31:0] debo;
   output [15:0] debRegF;
   output [10:0] Oopcode;
   
   output [255:0] ALUBusses;
   output [3:0] ALUCont;
   output [2:0] ALUins;
   output [63:0] signext;
   
   //Debugging:
   assign DebBB = ALUResult;//ALUImmRegChoice;
   assign Debug = {MemWrite, ALUImmRegChoice};//{ALUZero, nextPC};
   assign debo = currentInstruction;
   assign debRegF = {rn, rB, rd, RegWrite};
   
   assign ALUBusses = {ALUResult, ALUImmRegChoice, busA, busB};
   assign ALUCont = {ALUCtrl};
   assign ALUins = {ALUZero, MemRead, MemWrite};
   assign signext = signExtImm64;
   */
   //PC Logic
   wire [63:0] 	 nextPC;
   reg [63:0] 	 currentPC;
   
   //Instruction Decode
   wire [31:0] 	 currentInstruction;
   wire [10:0] 	 opcode;
   wire [4:0] 	 rm,rn,rd;
   wire [5:0] 	 shamt;

    assign Oopcode = opcode;

   // Decoding instruction fields
   assign {opcode, rm, shamt, rn, rd} = currentInstruction;
   /*assign rm = currentInstruction[20:16];
   assign shamt = currentInstruction[15:10];
   assign rn = currentInstruction[9:5];
   assign rd = currentInstruction[4:0];

    assign opcode = currentInstruction[31:21];
   */
   //Register wires
   wire [63:0] 	 busA; 
   wire [63:0]   busB; 
   wire [63:0]   busW; //buses for inputs and
   //outputs of regfile
   wire [4:0] 	 rB; // Used to attach output of
   // Reg2Loc mux to B input register
   // index input
   
   //Control Logic Wires
   wire 	 Reg2Loc, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Uncondbranch;
   wire [1:0] 	 ALUOp;
   wire [3:0] 	 ALUCtrl;
   
   //ALU Wires
   wire [63:0] 	 signExtImm64, ALUImmRegChoice;
   wire [63:0] 	 ALUResult;
   wire 	 ALUZero;
   
   //Data Memory Wires
   wire [63:0] 	 dMemOut;

   //Instruction Memory
   InstructionMemory instrMem(currentInstruction, currentPC);	
   
   //PC Logic
   NextPClogic next(
        .NextPC(nextPC), 
        .CurrentPC(currentPC),
        .SignExtImm64(signExtImm64), 
        .Branch(Branch), 
        .ALUZero(ALUZero), 
        .UnBranch(Uncondbranch));
        
   always @ (negedge CLK, negedge Reset_L) begin
      if(~Reset_L)
	currentPC = startPC;
      else
	currentPC = nextPC;
   end
   
   //~~~~~~~~~~~~~~~~~~~~~
   
   
   //Control
   SingleCycleControl control(
                                .Reg2Loc(Reg2Loc), 
                                .ALUSrc(ALUSrc), 
                                .MemToReg(MemToReg), 
                                .RegWrite(RegWrite), 
                                .MemRead(MemRead), 
                                .MemWrite(MemWrite), 
                                .Branch(Branch), 
                                .Uncondbranch(Uncondbranch), 
                                .ALUOp(ALUOp), 
                                .Opcode(opcode)
                                );
   
   //Register file
   /*create the Reg2Loc mux*/
   assign #2 rB = ((rm) & {5{(~Reg2Loc)}}) | ((rd) & {5{(Reg2Loc)}});///(Reg2Loc ? rd : rm);

   RegisterFile registers(.BusA(busA),
                          .BusB(busB),
                          .BusW(busW), 
                          .RA(rn), 
                          .RB(rB), 
                          .RW(rd), 
                          .RegWr(RegWrite), 
                          .Clk(CLK));
   
   //Sign Extender
   /*instantiate your sign extender*/
   SignExtender Signext(.BusImm(signExtImm64),
                        .Imm32(currentInstruction), 
                        .Ctrl(ResetL));
   
   //ALU
   ALUControl ALUContr(.ALUCtrl(ALUCtrl),
                      .ALUop(ALUOp),
                      .OpCode(opcode));
   
   // Which source for ALU input 2
   assign #2 ALUImmRegChoice = ALUSrc ? signExtImm64 : busB;//((busB) & (~ALUSrc)) | ((signExtImm64) & (ALUSrc));     //? signExtImm64 : busB;
   
   ALU mainALU(.BusW(ALUResult), 
               .Zero(ALUZero),
               .BusA(busA), 
               .BusB(ALUImmRegChoice), 
               .ALUCtrl(ALUCtrl));
   
   //Data Memory
   DataMemory data(dMemOut, ALUResult, busB, MemRead, MemWrite, CLK);
   /*create MemToReg mux */
   
   assign #2 busW = (MemToReg ? dMemOut : ALUResult);
   
   
   
endmodule

