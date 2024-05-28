`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 05:05:27 PM
// Design Name: 
// Module Name: CPU SYSTEM  
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

module CPUSystem(
    input           Clock,
    input           Reset,
    output reg [7:0] T
    );

    reg   [2:0]   RF_OutASel, RF_OutBSel, RF_FunSel;
    reg   [3:0]   RF_RegSel, RF_ScrSel;
    reg   [4:0]   ALU_FunSel;
    reg           ALU_WF;
    reg   [1:0]   ARF_OutCSel, ARF_OutDSel;
    reg   [2:0]   ARF_FunSel;
    reg   [2:0]   ARF_RegSel;
    reg           IR_LH;
    reg           IR_Write;
    reg           Mem_WR;
    reg           Mem_CS;
    reg   [1:0]   MuxASel, MuxBSel;
    reg           MuxCSel;
    
    ArithmeticLogicUnitSystem _ALUSystem(
   .RF_OutASel(RF_OutASel), 
   .RF_OutBSel(RF_OutBSel), 
   .RF_FunSel(RF_FunSel),
   .RF_RegSel(RF_RegSel),
   .RF_ScrSel(RF_ScrSel),
   .ALU_FunSel(ALU_FunSel),
   .ALU_WF(ALU_WF),
   .ARF_OutCSel(ARF_OutCSel), 
   .ARF_OutDSel(ARF_OutDSel), 
   .ARF_FunSel(ARF_FunSel),
   .ARF_RegSel(ARF_RegSel),
   .IR_LH(IR_LH),
   .IR_Write(IR_Write),
   .Mem_WR(Mem_WR),
   .Mem_CS(Mem_CS),
   .MuxASel(MuxASel),
   .MuxBSel(MuxBSel),
   .MuxCSel(MuxCSel),
   .Clock(Clock)
   );
   
   parameter FETCH1 = 1, FETCH2 = 2, DECODE = 4, T3 = 8, T4 = 16, T5 = 32, T6 = 64, T7 = 128;
   parameter BRA = 0, BNE = 1, BEQ = 2, POP = 3, PSH = 4, INC = 5, DEC = 6, LSL = 7, LSR = 8,
             ASR = 9, CSL = 10, CSR = 11, AND = 12, ORR = 13, NOT = 14, XOR = 15, NAND= 16, MOVH=17, LDR= 18, STR = 19, MOVL = 20, ADD = 21, ADC = 22, SUB= 23, MOVS = 24, ADDS= 25, SUBS = 26, ANDS = 27, ORRS =28, XORS=29, BX= 30, BL=31, LDRIM=32, STRIM =33;

    reg [5:0] opCode;
    reg [1:0] Rsel;
    reg       S;
    reg [7:0] Address;
    reg [3:0] DSTREG;
    reg [3:0] SREG1;
    reg [3:0] SREG2;
    
    initial _CPUSystem._ALUSystem.ARF.SP.Q = 255;
    
    always@(*) begin
        if (Reset == 0) begin
            T = 1;
        end
    end
    always @(negedge Clock) begin
         case (T) //Fetch 1 phase 
        
        0: begin
            T =1;

        end
        FETCH1: begin
       // $display("Output Values:");
        //$display("OpCode: %h", _ALUSystem.IROut[15:10]);
        //$display("T: %d", T);
       // $display("Address Register File: PC: %d, AR: %d, SP: %d", _CPUSystem._ALUSystem.ARF.PC.Q, _CPUSystem._ALUSystem.ARF.AR.Q, _CPUSystem._ALUSystem.ARF.SP.Q);
        //$display("Instruction Register : %d", _CPUSystem._ALUSystem.IR.IROut);
        //$display("Register File Registers: R1: %d, R2: %d, R3: %d, R4: %d", _CPUSystem._ALUSystem.RF.R1.Q, _CPUSystem._ALUSystem.RF.R2.Q, _CPUSystem._ALUSystem.RF.R3.Q, _CPUSystem._ALUSystem.RF.R4.Q);
        //$display("Register File Scratch Registers: S1: %d, S2: %d, S3: %d, S4: %d", _CPUSystem._ALUSystem.RF.S1.Q, _CPUSystem._ALUSystem.RF.S2.Q, _CPUSystem._ALUSystem.RF.S3.Q, _CPUSystem._ALUSystem.RF.S4.Q);
        //$display("ALU Flags: Z: %d, N: %d, C: %d, O: %d", _CPUSystem._ALUSystem.ALU.FlagsOut[3], _CPUSystem._ALUSystem.ALU.FlagsOut[2], _CPUSystem._ALUSystem.ALU.FlagsOut[1], _CPUSystem._ALUSystem.ALU.FlagsOut[0]);
        //$display("Rsel: %b, S: %d, DSTREG: %b, SReg1: %b, SReg2: %b", Rsel, S, DSTREG, SREG1, SREG2);
        
            Mem_CS = 1'b0; //Memory enabled
            Mem_WR = 1'b0; //Mem read
            IR_Write = 1'b1;
            IR_LH = 1'b0;
            ARF_RegSel = 3'b011; //Program Counter PC is enabled only
            ARF_FunSel = 3'b001; //PC is incremented
            ARF_OutDSel = 2'b00; // Output of PC is selected
            RF_RegSel = 4'b1111; //dont enable RF
            RF_ScrSel = 4'b1111;
            T = 2;
        end
        FETCH2: begin
            Mem_CS = 1'b0; //Memory enabled
            Mem_WR = 1'b0; //Mem read
            IR_Write = 1'b1;
            IR_LH = 1'b1;
            ARF_RegSel = 3'b011; //Program Counter PC is enabled only
            ARF_FunSel = 3'b001; //PC is incremented
            ARF_OutDSel = 2'b00; // Output of PC is selected
            RF_RegSel = 4'b1111; //dont enable RF
            RF_ScrSel = 4'b1111;
            T = 4;
        end
        DECODE: begin
        
            RF_RegSel = 4'b1111; //dont enable RF           
            RF_ScrSel = 4'b1111; //dont enable SF
            ARF_FunSel = 3'b010; //Load to AR:
            MuxBSel = 2'b11; //Let IR
            IR_Write = 1'b0;  
            Mem_CS = 1'b1;        
            opCode = _ALUSystem.IROut[15:10];
            if(!(opCode == STRIM || opCode == STR || opCode == LDR || opCode == LDRIM)) begin
                ARF_RegSel = 3'b101; //AR is enabled
            end else begin
                ARF_RegSel = 3'b111; //AR is not enabled since it's value will be used
            end
            Rsel=_ALUSystem.IROut[9:8];
            Address=_ALUSystem.IROut[7:0];
            DSTREG=_ALUSystem.IROut[8:6];
            SREG1=_ALUSystem.IROut[5:3];
            SREG2=_ALUSystem.IROut[2:0];
            S=_ALUSystem.IROut[9];
            T = 8;


        end
        T3: begin
            RF_RegSel = 4'b1111;
            ARF_RegSel = 3'b111;
            RF_ScrSel = 4'b1111;
            Mem_CS = 1'b1;
            ALU_WF = 1'b0;
            IR_Write = 1'b0;
            if(opCode == STRIM ||opCode ==  BRA ||opCode ==  BNE ||opCode ==  BEQ) begin //S1 <- IR[7:0]
                RF_RegSel = 4'b1111; //No Rx is selected
                RF_ScrSel = 4'b0111; //S1 is selected (Loading the value to S1)
                Mem_CS = 1'b1; //Memory is not used
                ARF_RegSel = 3'b111; //ARF registers are not used
                RF_FunSel = 3'b010; //Load to RF
                MuxASel = 2'b11;
                
            end else if (opCode == PSH) begin
                ALU_FunSel = 5'b10000;
                Mem_WR = 1'b1; //Mem write
                Mem_CS = 1'b0;
                ARF_OutDSel = 2'b11; //SP
                ARF_RegSel = 3'b110; //SP is enabled
                ARF_FunSel = 3'b000; //Decrement
                MuxCSel = 1'b1;
                RF_RegSel = 4'b1111;
                case(Rsel)
                    2'b00: RF_OutASel = 4'b000;
                    2'b01: RF_OutASel = 4'b001;
                    2'b10: RF_OutASel = 4'b010;
                    2'b11: RF_OutASel = 4'b011;
                endcase
             end else if(opCode ==LDR) begin
                 Mem_WR = 1'b0; //Mem read
                 Mem_CS = 1'b0;
                 ARF_OutDSel = 2'b10;
                 MuxASel = 2'b10;
                 case(Rsel)
                     2'b00: RF_RegSel = 4'b0111;
                     2'b01: RF_RegSel = 4'b1011;
                     2'b10: RF_RegSel = 4'b1101;
                     2'b11: RF_RegSel = 4'b1110;
                 endcase
                 ARF_RegSel = 3'b101; //AR
                 ARF_FunSel = 3'b000; //Decrement so that we can hold other 8 bits 
                 RF_FunSel = 3'b110; //Write high [15:8]
             end else if(opCode == STR) begin
                ALU_FunSel = 5'b10000; //A
                Mem_WR= 1'b1; //Mem write
                Mem_CS= 1'b0; //Mem enabled
                ARF_OutDSel= 2'b10; //AR
                MuxCSel = 1'b0;
                case(Rsel)
                    2'b00: RF_OutASel = 3'b000;
                    2'b01: RF_OutASel = 3'b001;
                    2'b10: RF_OutASel = 3'b010;
                    2'b11: RF_OutASel = 3'b011;
                endcase
                
                ARF_RegSel = 3'b101; //AR
                ARF_FunSel = 3'b001; //Increment
             end else if
            (opCode == INC ||opCode == DEC || opCode == LSL ||
             opCode == LSR ||opCode ==  ASR ||opCode ==  CSL || 
             opCode == CSR || opCode == AND|| opCode == ORR || 
             opCode == NOT || opCode == XOR || opCode == NAND ||
             opCode == ADD || opCode == ADC || opCode == SUB ||
             opCode == MOVS || opCode == ADDS || opCode ==  SUBS || 
             opCode == ANDS || opCode == ORRS ||opCode ==  XORS) begin //S1 <- STREG
                RF_RegSel = 4'b1111; //No Rx is selected
                RF_ScrSel = 4'b0111; //S1 is selected
                Mem_CS = 1'b1; //Memory is not used
                ARF_RegSel = 3'b111; //ARF registers are not used
                RF_FunSel = 3'b010; //Load to RF
                if (SREG1[2] == 0) begin //ARF will be the source
                    MuxASel = 2'b01; //ARF output
                    case(SREG1)
                        3'b000: ARF_OutCSel = 2'b00;
                        3'b001: ARF_OutCSel = 2'b01;
                        3'b010: ARF_OutCSel = 2'b10;
                        3'b011: ARF_OutCSel = 2'b11;
                    endcase
                end else begin
                     MuxASel = 2'b00; //ALU Out
                     ALU_FunSel = 5'b10000; //16 bit A
                    case(SREG1)
                        3'b100: RF_OutASel = 3'b000; //R1
                        3'b101: RF_OutASel = 3'b001; //R2
                        3'b110: RF_OutASel = 2'b010; //R3
                        3'b111: RF_OutASel = 2'b011; //R4                   
                    endcase
                end
             end else if(opCode == BX) begin //S1 <- PC
                MuxASel = 2'b01; //ARF
                ARF_OutCSel = 2'b00; //PC is selected
                RF_RegSel = 4'b1111; //No Rx is selected
                RF_ScrSel = 4'b0111; //S1 is selected
                Mem_CS = 1'b1; //Memory is not used
                ARF_RegSel = 3'b111; //ARF registers are not used
                RF_FunSel = 3'b010; //Load to RF            
            end else if(opCode == LDRIM) begin
                RF_FunSel = 3'b100; //Only the 8 bits are loaded, clearing the other bits
                case(Rsel)
                    2'b00: RF_RegSel = 4'b0111;
                    2'b01: RF_RegSel = 4'b1011;
                    2'b10: RF_RegSel = 4'b1101;
                    2'b11: RF_RegSel = 4'b1110;
                endcase
                MuxASel = 2'b11; //IR [7:0]
                RF_ScrSel = 4'b1111; //Disable all
            end else if (opCode == BL) begin
                ARF_RegSel = 3'b110;
                ARF_FunSel = 3'b000; //Decrementing because we have started from 255 and going upwards
            end else if (opCode == POP) begin
                ARF_RegSel = 3'b110; // SP is enabled
                ARF_FunSel = 3'b001; //Increment
            end  else if(opCode == MOVL || opCode == MOVH ) begin
                ARF_RegSel = 4'b1111;
                MuxASel = 2'b11;
                case(Rsel)
                     2'b000: RF_RegSel = 4'b0111; //Enable R1
                     2'b001: RF_RegSel = 4'b1011; //Enable R2
                     2'b010: RF_RegSel = 4'b1101; //Enable R3
                     2'b011: RF_RegSel = 4'b1110; //Enable R4
                     
                endcase
                if(opCode == MOVL) begin
                    RF_FunSel = 3'b101; //Write low
                end else if(opCode == MOVH) begin
                    RF_FunSel = 3'b110; //Write high
                end
            end
            T=16;
        end
        T4: begin
            RF_RegSel = 4'b1111;
            ARF_RegSel = 3'b111;
            RF_ScrSel = 4'b1111;
            Mem_CS = 1'b1;
            ALU_WF = 1'b0;
            IR_Write = 1'b0;
                if(opCode == BRA || opCode == BNE || opCode == BEQ || opCode == STRIM) begin
                     RF_RegSel = 4'b1111; //No Rx is selected
                     RF_ScrSel = 4'b1011; //S2 is selected
                     Mem_CS = 1'b1; //Memory is not used
                     ARF_RegSel = 3'b111; //ARF registers are not used
                     RF_FunSel = 3'b010; //Load to RF
                     MuxASel = 2'b01; //ARF
                     ARF_OutCSel = 2'b01; //PC
                     if(opCode == STRIM) begin
                        ARF_OutCSel = 2'b10; //AR is selected
                     end
                 end else if(opCode == STR) begin
                       ALU_FunSel = 5'b10000; //A
                       Mem_WR= 1'b1; //Mem write
                       Mem_CS= 1'b0; //Mem enabled
                       ARF_OutDSel= 2'b10; //AR
                       MuxCSel = 1'b1;
                       case(Rsel)
                           2'b00: RF_OutASel = 3'b000;
                           2'b01: RF_OutASel = 3'b001;
                           2'b10: RF_OutASel = 3'b010;
                           2'b11: RF_OutASel = 3'b011;
                       endcase
               end else if(opCode == PSH) begin
               
                     ALU_FunSel = 5'b10000;
                     Mem_WR = 1'b1; //Mem write
                     Mem_CS = 1'b0;
                     ARF_OutDSel = 2'b11; //SP
                     ARF_RegSel = 3'b110; //SP is enabled
                     ARF_FunSel = 3'b000; //Decrement
                     MuxCSel = 1'b0;
                     case(Rsel)
                         2'b00: RF_OutASel = 4'b000;
                         2'b01: RF_OutASel = 4'b001;
                         2'b10: RF_OutASel = 4'b010;
                         2'b11: RF_OutASel = 4'b011;
                     endcase               
                end else if (opCode == AND ||opCode ==  ORR ||opCode ==  XOR ||
                opCode == NAND ||opCode ==  ADDS || opCode == SUBS || opCode == ANDS
                || opCode == ORRS || opCode == XORS ||opCode ==  ADD ||opCode ==  ADC || opCode == SUB) begin
                    RF_RegSel = 4'b1111; //No Rx is selected
                    RF_ScrSel = 4'b1011; //S2 is selected
                    Mem_CS = 1'b1; //Memory is not used
                    ARF_RegSel = 3'b111; //ARF registers are not used
                    RF_FunSel = 3'b010; //Load to RF 
                    if (SREG1[2] == 0) begin
                        MuxASel = 2'b01;
                        case(SREG2)
                            3'b000: ARF_OutCSel = 2'b00;
                            3'b001: ARF_OutCSel = 2'b01;
                            3'b010: ARF_OutCSel = 2'b10;
                            3'b011: ARF_OutCSel = 2'b11; 
                         endcase
                     end else begin
                        MuxASel = 2'b00;
                        ALU_FunSel = 5'b10000; //A

                         case(SREG2)
                            3'b100: RF_OutASel = 3'b000; //R1
                            3'b101: RF_OutASel = 3'b001; //R2
                            3'b110: RF_OutASel = 2'b010; //R3
                            3'b111: RF_OutASel = 2'b011; //R4                   
                        endcase 
                    end
                                    
                end else if (opCode == BL) begin
                    ARF_OutDSel = 2'b11;
                    Mem_WR = 1'b0; //Mem Read
                    Mem_CS= 1'b0; //Mem enabled
                    ARF_FunSel = 3'b110; //Load high
                    ARF_RegSel = 3'b011;
                    MuxBSel = 2'b10;
                 end else if(opCode == POP) begin
                    RF_FunSel = 3'b101; //Write Low
                    Mem_WR= 1'b0; //Mem read
                    Mem_CS= 1'b0; //Mem enabled
                    ARF_OutDSel= 2'b11; //SP
                    MuxASel = 2'b10; //Mem Out
                    case(Rsel)
                        2'b00: RF_RegSel = 4'b0111;
                        2'b01: RF_RegSel = 4'b1011;
                        2'b10: RF_RegSel = 4'b1101;
                        2'b11: RF_RegSel = 4'b1110;
                    endcase
                    RF_ScrSel = 4'b1111; //All of them are disabled
                    ARF_RegSel = 3'b110; //SP
                    ARF_FunSel = 3'b001; //Increment 
                end else if (opCode == LDR) begin
                    Mem_WR = 1'b0; //Mem read
                    Mem_CS = 1'b0;
                    ARF_OutDSel = 2'b10;
                    MuxASel = 2'b10; //MEM Out
                    case(Rsel)
                        2'b00: RF_RegSel = 4'b0111;
                        2'b01: RF_RegSel = 4'b1011;
                        2'b10: RF_RegSel = 4'b1101;
                        2'b11: RF_RegSel = 4'b1110;
                    endcase
                    ARF_RegSel = 3'b111; //AR
                    RF_FunSel = 3'b101; //Load low [7:0]
                 end else if(opCode == BX) begin
                     ALU_FunSel = 5'b10000; //ALUOut = A
                     ARF_OutDSel = 2'b11; //SP is sent to the Memory
                     Mem_WR = 1'b1; // Write to memory
                     Mem_CS = 1'b0; //Memory is enabled.
                     MuxCSel = 1'b1; //Second half is written to memory
                     ARF_FunSel = 3'b000; //Decrement the SP
                end
                    
                    
            T=32;
         end
         
         T5: begin
            RF_RegSel = 4'b1111;
            ARF_RegSel = 3'b111;
            RF_ScrSel = 4'b1111;
            Mem_CS = 1'b1;
            ALU_WF = 1'b0;
            IR_Write = 1'b0;   
            ARF_FunSel = 3'b010; //Load
            RF_FunSel = 3'b010; //Load      
             if (opCode == POP) begin
                 RF_FunSel = 3'b110; //Write High
                 Mem_WR= 1'b0; //Mem read
                 Mem_CS= 1'b0; //Mem enabled
                 ARF_OutDSel= 2'b11; //SP
                 MuxASel = 2'b10; //Mem Out
                 case(Rsel)
                     2'b00: RF_RegSel = 4'b0111;
                     2'b01: RF_RegSel = 4'b1011;
                     2'b10: RF_RegSel = 4'b1101;
                     2'b11: RF_RegSel = 4'b1110;
                 endcase
             end else if (!(opCode == BL || opCode == BX || opCode ==  MOVH || opCode == MOVL || opCode == STR || opCode == LDR || opCode == LDRIM  || opCode == PSH || opCode == POP)) begin     
                if(DSTREG[2] == 0) begin // We will load to ARF
                    MuxBSel = 2'b00; //ALU Out
                    case(DSTREG)
                        3'b000: ARF_RegSel = 3'b011; //Enable PC
                        3'b001: ARF_RegSel = 3'b011; //Enable PC
                        3'b010: ARF_RegSel = 3'b110; //Enable SP
                        3'b011: ARF_RegSel = 3'b101; //Enable AR
                    endcase
                end else begin
                    MuxASel = 2'b00;
                    RF_ScrSel = 4'b1111; //Enable no S registers
                    case(DSTREG)
                      3'b100: RF_RegSel = 4'b0111; //Enable R1
                      3'b101: RF_RegSel = 4'b1011; //Enable R2
                      3'b110: RF_RegSel = 4'b1101; //Enable R3
                      3'b111: RF_RegSel = 4'b1110; //Enable R4
                    endcase
                end
                RF_OutASel = 3'b100; //S1
                RF_OutBSel = 3'b101; //S2
            end
            if(opCode == BRA || opCode == BNE || opCode == BEQ) begin
                ALU_FunSel = 5'b00100;
                if(opCode ==BNE) begin
                    if(_ALUSystem.FlagsOut[3] == 0) begin
                        ARF_RegSel = 3'b011; //PC Enabled
                    end else begin
                        ARF_RegSel = 3'b111;
                    end
                end else if (opCode == BEQ) begin
                    if(_ALUSystem.FlagsOut[3] == 1) begin
                        ARF_RegSel = 3'b011; //PC Enabled
                    end else begin
                        ARF_RegSel = 3'b111;     end
                end else if(opCode == BRA) begin
                    ARF_RegSel = 3'b011; //PC Enabled
                end
                            
            end else if (opCode == INC || opCode == DEC) begin
                ALU_FunSel = 5'b10000; // A
            end else if (opCode == LSL) begin
                ALU_FunSel = 5'b11011;
            end else if(opCode == LSR) begin
                ALU_FunSel = 5'b11100;
            end else if (opCode == ASR) begin
                ALU_FunSel = 5'b11101;  
            end else if (opCode == CSL) begin
                ALU_FunSel = 5'b11110;     
            end else if (opCode == CSR) begin
                ALU_FunSel = 5'b11111;
            end else if (opCode == AND) begin
                ALU_FunSel = 5'b10111;     
            end else if (opCode == ORR) begin
                ALU_FunSel = 5'b11000;
            end else if (opCode == NOT) begin
                ALU_FunSel = 5'b10010;
            end else if (opCode == XOR) begin
                ALU_FunSel = 5'b11001;   
            end else if (opCode == NAND) begin
                ALU_FunSel = 5'b11010;
            end else if (opCode == ADD) begin
                ALU_FunSel = 5'b10100;
            end else if (opCode == ADC) begin
                ALU_FunSel = 5'b10101;
            end else if (opCode == SUB) begin
                ALU_FunSel = 5'b10110;
            end else if (opCode == MOVS) begin
                ALU_FunSel = 5'b10000; 
                ALU_WF = 1'b1;      
            end else if (opCode == ADDS) begin
                ALU_FunSel = 5'b10100;
                ALU_WF = 1'b1;   
            end else if (opCode == SUBS) begin
                ALU_FunSel = 5'b10110;
                ALU_WF = 1'b1;   
            end else if(opCode == ANDS) begin
                ALU_FunSel = 5'b10111; 
                ALU_WF = 1'b1;   
            end else if(opCode == ORRS) begin
                ALU_FunSel = 5'b11000;
                ALU_WF = 1'b1;   
            end else if(opCode == XORS) begin
                ALU_FunSel = 5'b11001; 
                ALU_WF = 1'b1;   
            end else if(opCode == BX) begin
                ALU_FunSel = 5'b10000; //ALUOut = A
                ARF_OutDSel = 2'b11; //SP is sent to the Memory
                Mem_WR = 1'b1; // Write to memory
                Mem_CS = 1'b0; //Memory is enabled.
                MuxCSel = 1'b0; //First half is loaded to memory
                ARF_FunSel = 3'b000; //Decrement the SP
             end else if (opCode == STRIM) begin
                RF_OutASel = 3'b100; //S1
                RF_OutBSel = 3'b101; // S2
                ALU_FunSel = 5'b10100; // ALUOUT = A + B
                ARF_FunSel = 3'b010; //Load 
                ARF_RegSel = 3'b101; //AR enabled
                MuxBSel =2'b00; //ALU Out
            end else if (opCode == BL) begin
                 ARF_RegSel = 3'b110;
                 ARF_FunSel = 3'b000; //Decrementing because we have started from 255 and going upwards
            end        
        T=64;
        end
        T6: begin
            RF_RegSel = 4'b1111;
            ARF_RegSel = 3'b111;
            RF_ScrSel = 4'b1111;
            Mem_CS = 1'b1;
            ALU_WF = 1'b0;
            IR_Write = 1'b0;          
            if (opCode == BX) begin
                ALU_FunSel = 5'b10000; //ALUOut = A
                ARF_OutDSel = 2'b11; //SP is sent to the Memory
                Mem_WR = 1'b1; // Write to memory
                Mem_CS = 1'b0; //Memory is enabled.
                MuxCSel = 1'b1; //Second half is loaded to memory
                ARF_FunSel = 3'b000; //Decrement the SP
                MuxBSel = 2'b00;
                case(Rsel)
                    2'b00: RF_OutASel = 4'b000;
                    2'b01: RF_OutASel = 4'b001;
                    2'b10: RF_OutASel = 4'b010;
                    2'b11: RF_OutASel = 4'b011;
               endcase
                 
             end else if (opCode == BL) begin
                    ARF_OutDSel = 2'b11;
                    Mem_WR = 1'b0; //Mem Read
                    Mem_CS= 1'b0; //Mem enabled
                    ARF_FunSel = 3'b101; //Load low
                    ARF_RegSel = 3'b011;
                    MuxBSel = 2'b10;  

           end else if (opCode == INC || opCode == DEC ) begin
            if(DSTREG [2] == 0) begin

                 case (DSTREG)
                    3'b000: ARF_RegSel = 3'b011; //Enable PC
                    3'b001: ARF_RegSel = 3'b011; //Enable PC
                    3'b010: ARF_RegSel = 3'b110; //Enable SP
                    3'b011: ARF_RegSel = 3'b101; //Enable AR
                 endcase
                 if(opCode == INC) begin
                   ARF_FunSel = 3'b001; //Increment
                 end else if (opCode == DEC) begin
                    ARF_FunSel = 3'b000; //Decrement
                 end
            end else begin
                 case(DSTREG)
                    3'b100: RF_RegSel = 4'b0111; //Enable R1
                    3'b101: RF_RegSel = 4'b1011; //Enable R2
                    3'b110: RF_RegSel = 4'b1101; //Enable R3
                    3'b111: RF_RegSel = 4'b1110; //Enable R4
                endcase
                if(opCode == INC) begin
                  RF_FunSel = 3'b001; //Increment
                end else begin
                   RF_FunSel = 3'b000; //Decrement
                end
            end               
            end else if(opCode == STRIM) begin
                case(Rsel)
                    2'b00: RF_OutASel = 4'b000;
                    2'b01: RF_OutASel = 4'b001;
                    2'b10: RF_OutASel = 4'b010;
                    2'b11: RF_OutASel = 4'b011;
                endcase
                ALU_FunSel = 5'b10000; //ALU Out = A
                MuxCSel = 1'b0; // Rx[7:0]
                Mem_CS = 1'b0; //MEM Enabled
                Mem_WR = 1'b1; // Memory Write
                ARF_OutDSel = 2'b10;
                ARF_RegSel = 3'b101; //AR is selected
                ARF_FunSel = 3'b001; //Increment since our memory only holds 8 bits    
                end                           
            T=128;
            end
        T7: begin
            RF_RegSel = 4'b1111;
            ARF_RegSel = 3'b111;
            RF_ScrSel = 4'b1111;
            Mem_CS = 1'b1;
            ALU_WF = 1'b0;
            IR_Write = 1'b0;          
            if(opCode == STRIM) begin
                    case(Rsel)
                        2'b00: RF_OutASel = 4'b000;
                        2'b01: RF_OutASel = 4'b001;
                        2'b10: RF_OutASel = 4'b010;
                        2'b11: RF_OutASel = 4'b011;
                    endcase
                    ALU_FunSel = 5'b10000; //ALU Out = A
                    MuxCSel = 1'b1; // Rx[15:8]
                    Mem_CS = 1'b0; //MEM Enabled
                    Mem_WR = 1'b1; // Memory Write
                    ARF_OutDSel = 2'b10;
                    ARF_RegSel = 3'b101; //AR is selected
                    ARF_FunSel = 3'b000; //Decrement so that we can go back to the first 8 bits' address    
            end
            T = 1;
        end           
     endcase
   end
endmodule