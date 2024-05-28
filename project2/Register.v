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


module Register(
    input wire [15:0] I,
    input wire Clock,
    input wire E,
    input wire [2:0] FunSel,
    output reg [15:0] Q
);
    initial Q = 0;
    always @(posedge Clock) begin
            if (E) begin
                case (FunSel) 
                    3'b000: Q <= Q-1;
                    3'b001: Q <= Q+1;
                    3'b010: Q <= I;
                    3'b011: Q <= 0;
                    3'b100: begin
                        Q[15:8] <=  8'b0; 
                        Q[7:0] <= I[7:0];
                    end 
                    3'b101: Q[7:0] <= I[7:0];
                    3'b110: Q[15:8] <= I[7:0];
                    3'b111:                    
                    if (I[7] == 1'b1) begin
                        Q[15:8] = 8'b11111111;
                        Q[7:0] <= I[7:0];
                    end else begin
                        Q[15:8] = 8'b00000000;
                        Q[7:0] <= I[7:0];
                    end
                endcase
        end
    end
endmodule