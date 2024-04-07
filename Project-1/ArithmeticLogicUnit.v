`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2024 05:05:27 PM
// Design Name: 
// Module Name: register
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

module ArithmeticLogicUnit(
    input wire[15:0] A, B,
    input wire[4:0] FunSel,
    input wire WF,
    input wire Clock,
    output reg[15:0] ALUOut,
    output reg[3:0] FlagsOut
    
    
 );

reg [16:0] Temp_ALU, comp, Sub;
reg [8:0] Temp_ALU1, comp1, Sub1;
reg [3:0] FlagsOut_temp;


always @* begin 
            case(FunSel) 
            //Copy A to ALUOut
            5'b00000: begin
                ALUOut[15:8] = 8'b0;
                ALUOut[7:0] = A[7:0];
            end
            //Copy B to ALUOut
            5'b00001: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = B[7:0];
            end
            
            //Bitwise NOT A
            5'b00010: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = ~A[7:0];
            end
            
            //Bitwise NOT B
            5'b00011: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = ~B[7:0];
            end
            
            //Addition A + B
            5'b00100: begin
                ALUOut[15:8]  = 8'b0;
                Temp_ALU1 = A + B;
                ALUOut[7:0]  = Temp_ALU1[7:0];
            end
            
            //Addition A + B + C
            5'b00101: begin
                ALUOut[15:8]  = 8'b0;
                Temp_ALU1 = A + B + FlagsOut[2];
                ALUOut[7:0]  = Temp_ALU1[7:0];
                
            end
            //Subtraction A - B
            5'b00110: begin
                ALUOut[15:8]  = 8'b0;
                comp1 = ~B;
                Sub1 = A + comp1 + 1'b1;
                ALUOut[7:0]  = Sub1[7:0];
            end
            
            //Bitwise AND A & B
            5'b00111: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = A & B;

            end
            
            //Bitwise OR A | B
            5'b01000: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = A | B;

            end
            
            //Bitwise XOR A ^ B
            5'b01001: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = A ^ B;

            end
            
            //Bitwise NAND ~(A & B)
            5'b01010: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = ~(A & B);

            end
            
            //Logical Shift Left (LSL) A
            5'b01011: begin 
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0] = {A[6:0], 1'b0};

            end
            
            //Logical Shift Right (LSR) A
            5'b01100: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0]  = {1'b0, A[7:1]};
            end
            
            //Arithmetic Shift Right (ASR) A
            5'b01101: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0] = {A[7], A[7:1]};
            end
            
            //Circular Shift Left (CSL) A
            5'b01110: begin
                ALUOut[15:8]  = 8'b0;
                ALUOut[7:0] = {FlagsOut[2], A[7:1]};     
            end
            //Circular Shift Right (CSR) A   
            5'b01111: begin
                 ALUOut[15:8]  = 8'b0;
                 ALUOut[7:0] = {A[6:1], FlagsOut[2]};
            end
            //Copy A to ALUOut
            5'b10000: begin
                ALUOut = A;
                
            end
            //Copy B to ALUOut
            5'b10001:  begin
                ALUOut = B;
            end
            //Bitwise NOT A
            5'b10010: begin
                ALUOut = ~A;
            end
            //Bitwise NOT B
            5'b10011: begin
                ALUOut = ~B;
            end
            //Addition A + B
            5'b10100: begin
                Temp_ALU = A + B;
                ALUOut[15:0] = Temp_ALU[15:0];
            end
            //Addition A + B +C
            5'b10101: begin
                Temp_ALU = A + B + FlagsOut[2];
                ALUOut[15:0] = Temp_ALU[15:0];
                
            end
            //Subtraction A - B
            5'b10110:  begin 
                comp = ~B;
                Sub = A + comp + 1'b1;
                ALUOut[15:0] = Sub[15:0];
            end 
            //Bitwise A AND B 
            5'b10111: begin
               ALUOut = A & B;

            end
            //Bitwise A OR B 
            5'b11000: begin
                ALUOut = A | B;
            end
            //Bitwise A XOR B 
            5'b11001: begin
                ALUOut = A ^ B;
            end
            //Bitwise A NAND B 
            5'b11010: begin
                ALUOut = ~(A & B);
            end
            5'b11011: begin // LSL A
                ALUOut = {A[14:0], 1'b0};
            end
            5'b11100: begin //LSR A
                ALUOut = {1'b0, A[14:1]};
            end
            5'b11101: begin //ASR A
                ALUOut = {A[15], A[15:1]};
            end
            5'b11110: begin //CSL
                ALUOut = {A[14:0], FlagsOut[2]};
            end
            5'b11111: begin //CSR
                ALUOut = {FlagsOut[2], A[15:1]};
            end
        endcase
    end
    always @(posedge Clock) begin
        if(WF) begin
            case(FunSel)
                5'b00000: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            5'b00001: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            // Case 00010: Bitwise NOT A
            5'b00010: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            // Case 00011: Bitwise NOT B
            5'b00011: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            // Case 00100: Addition A + B
            5'b00100: begin
                FlagsOut[3] = (ALUOut == 8'b0); //Z
                FlagsOut[2] = (Temp_ALU1[8]==1); // C
                FlagsOut[1] = (ALUOut[7]==1); // N
                FlagsOut[0] = (A[7] == B[7]) && (ALUOut[7] != A[7]); // Overflow if sign of A and B are same and different from result
            end
            //Addition A + B +C
            5'b00101: begin
                FlagsOut[3] = (ALUOut == 8'b0); //Z
                FlagsOut[2] = (Temp_ALU1[8] ==1); //C
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[0] = (A[7] == B[7]) && (Temp_ALU1[7] != A[7]); //O
                
            end
            
            //Subtraction A - B
            5'b00110: begin
            FlagsOut[3] = (ALUOut == 8'b0); //Z
            FlagsOut[2] = (Sub1[8]==1); // C
            FlagsOut[1] = (ALUOut[7]==1); // N
            FlagsOut[0] = (A[7] == B[7]) && (ALUOut[7] != A[7]); // Overflow if sign of A and B are same and different from result
            end
            
            //Bitwise AND A & B
            5'b00111: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            //Bitwise OR A | B
            5'b01000: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            //Bitwise XOR A ^ B
            5'b01001: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            //Bitwise NAND ~(A & B)
            5'b01010: begin
                FlagsOut[1] = (ALUOut[7]==1); //N
                FlagsOut[3] = (ALUOut[7:0] == 8'b0); //Z
            end
            
            //Logical Shift Left (LSL) A
            5'b01011: begin 
                FlagsOut[3] = (ALUOut == 8'b0); //Z
                FlagsOut[2] = (A[7]==1); //C
                FlagsOut[1] = (ALUOut[7]==1); //N
            end
            
            //Logical Shift Right (LSR) A
            5'b01100: begin
                FlagsOut[3]  = (ALUOut == 8'b0); //Z
                FlagsOut[2] = (A[0]==1); //C
                FlagsOut[1] = (ALUOut[7]==1); //N
            end
            
            //Arithmetic Shift Right (ASR) A
            5'b01101: begin
                FlagsOut[3] = (ALUOut == 8'b0); //Z
                FlagsOut[2] = A[0]; //C
            end
            
            //Circular Shift Left (CSL) A
            5'b01110: begin
                FlagsOut[3] = (ALUOut == 8'b0);
                FlagsOut[2] = A[7];
                FlagsOut[1] = (ALUOut[7]==1);
            end
            5'b01111: begin //Circular Shift Right (CSR) A
                 FlagsOut[3] = (ALUOut == 8'b0);
                 FlagsOut[2] = A[0];
                 FlagsOut[1] = (ALUOut[7]==1);
            end
            
    
            5'b10000: begin
                FlagsOut[3] = (ALUOut == 16'b0); //Z
                FlagsOut[1] = (ALUOut[15]==1); // C
            end
            5'b10001:  begin
                FlagsOut[3] = (ALUOut == 16'b0); //Z
                FlagsOut[1] = (ALUOut[15]==1); // C
            end
            5'b10010: begin
                FlagsOut[3] = (ALUOut == 16'b0); //Z
                FlagsOut[1] = (ALUOut[15]==1); // C
            end
            5'b10011: begin
                FlagsOut[3] = (ALUOut == 16'b0); //Z
                FlagsOut[1] = (ALUOut[15]==1); // C
            end
            //A+B
            5'b10100: begin
                FlagsOut[3] = (ALUOut == 16'b0); //Z
                FlagsOut[2] = (Temp_ALU[16] == 1'b1); // C
                FlagsOut[1] = (ALUOut[15]==1); //N 
                FlagsOut[0] = (A[15] == B[15]) && (A[15] != ALUOut[15]); // O
            end
            //A+B+C
            5'b10101: begin
                FlagsOut[3] = (Temp_ALU[15:0] == 16'b0);
                FlagsOut[2] = (Temp_ALU[16]==1);
                FlagsOut[1] = (ALUOut[15]==1);
                FlagsOut[0] = (A[15] == B[15]) && (A[15] != Temp_ALU[15]);
            end
            //A-B
            5'b10110:  begin
                FlagsOut[3] = (ALUOut == 16'b0);
                FlagsOut[2] = (Sub[16]==1); // Check if borrow occurred
                FlagsOut[1] = (ALUOut[15]==1); // Sign bit of the result
                FlagsOut[0] = (A[15] != B[15]) && (A[15] != ALUOut[15]); // Overflow if signs of A and B are different and different from result
            end 
            5'b10111: begin
               FlagsOut[3] = (ALUOut == 16'b0); //Z
               FlagsOut[1] = (ALUOut[15]==1); // N
            end
            5'b11000: begin
               FlagsOut[3] = (ALUOut == 16'b0); //Z
               FlagsOut[1] = (ALUOut[15]==1); // N
            end
            5'b11001: begin
               FlagsOut[3] = (ALUOut == 16'b0); //Z
               FlagsOut[1] = (ALUOut[15]==1); // N
            end
            5'b11010: begin
               FlagsOut[3] = (ALUOut == 16'b0); //Z
               FlagsOut[1] = (ALUOut[15]==1); // N
            end
            5'b11011: begin //LSL A
               FlagsOut[3] = (ALUOut == 16'b0); //Z
               FlagsOut[2] = (A[15]==1); //C
               FlagsOut[1] = (ALUOut[15]==1); // N
            end
            5'b11100: begin //LSR A
                FlagsOut[3]  = (ALUOut == 16'b0);
                FlagsOut[2] = (A[0]==1);
                FlagsOut[1] = (ALUOut[15]==1); 
            end
            5'b11101: begin //ASR
                FlagsOut[3] = (ALUOut == 16'b0);
                FlagsOut[2] = A[0];
            end
            5'b11110: begin //CSL
                FlagsOut[3] = (ALUOut == 16'b0);
                FlagsOut[2] = A[15];
                FlagsOut[1] = (ALUOut[15]==1);
            end
            5'b11111: begin //CSR
                FlagsOut[3] = (ALUOut == 16'b0);
                FlagsOut[2] = A[0];
                FlagsOut[1] = (ALUOut[15]==1);
            end
        endcase
    end
    end
endmodule