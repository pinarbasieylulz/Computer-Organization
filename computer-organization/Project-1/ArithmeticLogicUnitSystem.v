module MuxAB(
    input   [1:0]   MuxABSel,
    input   [15:0]  I0, I1,
    input   [7:0]  I2, I3,
    output  reg[15:0]   MuxABOut
);

    always @(*) begin
        MuxABOut = 16'b0;
        case (MuxABSel)
            2'b00:      MuxABOut = I0;
            2'b01:      MuxABOut = I1;
            2'b10:      MuxABOut[7:0] = I2;
            2'b11:      MuxABOut[7:0] = I3;
        endcase
    end
endmodule

module MuxC(
    input MuxCSel,
    input  [7:0] I0, I1,
    output  reg[7:0]  MuxCOut
);

    always @(*) begin
        case (MuxCSel)
            1'b0: MuxCOut = I0;
            1'b1: MuxCOut = I1;
        endcase
    end
endmodule


module ArithmeticLogicUnitSystem(
        input   [2:0]   RF_OutASel, RF_OutBSel, RF_FunSel,
        input   [3:0]   RF_RegSel, RF_ScrSel,
        input   [4:0]   ALU_FunSel,
        input           ALU_WF,
        input   [1:0]   ARF_OutCSel, ARF_OutDSel,
        input   [2:0]   ARF_FunSel,
        input   [2:0]   ARF_RegSel,
        input           IR_LH,
        input           IR_Write,
        input           Mem_WR,
        input           Mem_CS,
        input   [1:0]   MuxASel, MuxBSel,
        input           MuxCSel,
        input           Clock
);
    
wire[15:0]  OutA, OutB;
wire[15:0]  ALUOut;
wire[3:0]   FlagsOut;
wire[7:0]   MemOut; 
wire[15:0]  IROut, OutC, Address;
wire[15:0]  MuxAOut, MuxBOut;
wire[7:0]   MuxCOut; 
    
        
    RegisterFile RF(.I(MuxAOut), .OutASel(RF_OutASel), .OutBSel(RF_OutBSel), .FunSel(RF_FunSel), .RegSel(RF_RegSel), .ScrSel(RF_ScrSel), .Clock(Clock), .OutA(OutA), .OutB(OutB));
                    
    AddressRegisterFile ARF (.I(MuxBOut), .OutCSel(ARF_OutCSel), .OutDSel(ARF_OutDSel), .RegSel(ARF_RegSel), .FunSel(ARF_FunSel), .Clock(Clock), .OutC(OutC), .OutD(Address));
                            
    ArithmeticLogicUnit ALU (.A(OutA), .B(OutB), .WF(ALU_WF), .Clock(Clock), .FunSel(ALU_FunSel), .ALUOut(ALUOut), .FlagsOut(FlagsOut));
    
    InstructionRegister IR(.I(MemOut), .Clock(Clock), .Write(IR_Write), .LH(IR_LH), .IROut(IROut));
    
    
    Memory MEM (.Address(Address), .Data(MuxCOut), .WR(Mem_WR), .CS(Mem_CS), .Clock(Clock), .MemOut(MemOut));
    
    MuxAB MuxA(.MuxABSel(MuxASel), .I0(ALUOut), .I1(OutC), .I2(MemOut), .I3(IROut[7:0]), .MuxABOut(MuxAOut));
    
    MuxAB MuxB(.MuxABSel(MuxBSel), .I0(ALUOut), .I1(OutC), .I2(MemOut), .I3(IROut[7:0]), .MuxABOut(MuxBOut));
    
    MuxC MuxC(.MuxCSel(MuxCSel), .I0(ALUOut[7:0]), .I1(ALUOut[15:8]), .MuxCOut(MuxCOut));

endmodule
