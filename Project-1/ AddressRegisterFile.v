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

module AddressRegisterFile(
    input [15:0] I,
    input [1:0] OutCSel, OutDSel,
    input [2:0] RegSel, FunSel,
    input Clock,
    output reg [15:0] OutC, OutD
);

wire [15:0] o1, o2, o3;
Register PC(.I(I), .Clock(Clock), .E(~RegSel[2]), .FunSel(FunSel), .Q(o1));
Register AR(.I(I), .Clock(Clock), .E(~RegSel[1]), .FunSel(FunSel), .Q(o2));
Register SP(.I(I), .Clock(Clock), .E(~RegSel[0]), .FunSel(FunSel), .Q(o3));    
    always @* begin
        case (OutCSel)
            2'b00: OutC = o1;
            2'b01: OutC = o1;
            2'b10: OutC = o2;
            2'b11: OutC = o3;
        endcase
        case (OutDSel) 
            2'b00: OutD = o1;
            2'b01: OutD = o1;
            2'b10: OutD = o2;
            2'b11: OutD = o3;
        endcase
    end
endmodule
    
