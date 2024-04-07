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



module InstructionRegister (
    input [7:0] I,
    input Clock,
    input wire Write, 
    input wire LH,
    output reg [15:0] IROut
 );
 
    always@(posedge Clock) begin
        if (Write) begin
            case(LH)
            1'b0: IROut[7:0] = I;
            1'b1: IROut[15:8] = I;
            endcase
        end
    end
 endmodule
            
                
        
    
   
    
        
    
    


