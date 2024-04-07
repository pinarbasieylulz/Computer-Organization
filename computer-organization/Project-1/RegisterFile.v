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


module RegisterFile(
    input wire [15:0] I,
    input wire [2:0] OutASel, OutBSel, FunSel,
    input wire [3:0] RegSel, ScrSel,
    input wire Clock,
    output reg [15:0] OutA, OutB
    
);

wire E1, E2, E3, E4, E11, E12, E13, E14;

assign E1 = ~RegSel[3];
assign E2 = ~RegSel[2];
assign E3 = ~RegSel[1];
assign E4 = ~RegSel[0];
assign E11 = ~ScrSel[3];
assign E12 = ~ScrSel[2];
assign E13 = ~ScrSel[1];
assign E14 = ~ScrSel[0];

wire [15:0] o1, o2, o3, o4, o5, o6, o7, o8;
Register R1(.I(I), .Clock(Clock), .E(E1), .FunSel(FunSel), .Q(o1));
Register R2(.I(I), .Clock(Clock), .E(E2), .FunSel(FunSel), .Q(o2));
Register R3(.I(I), .Clock(Clock), .E(E3), .FunSel(FunSel), .Q(o3));
Register R4(.I(I), .Clock(Clock), .E(E4), .FunSel(FunSel), .Q(o4));
Register S1(.I(I), .Clock(Clock), .E(E11), .FunSel(FunSel), .Q(o5));
Register S2(.I(I), .Clock(Clock), .E(E12), .FunSel(FunSel), .Q(o6));
Register S3(.I(I), .Clock(Clock), .E(E13), .FunSel(FunSel), .Q(o7));
Register S4(.I(I), .Clock(Clock), .E(E14), .FunSel(FunSel), .Q(o8));

always @* begin
    case (OutASel)
        3'b000: OutA = o1;
        3'b001: OutA = o2;
        3'b010: OutA = o3;
        3'b011: OutA = o4;
        3'b100: OutA = o5;
        3'b101: OutA = o6;
        3'b110: OutA = o7;
        3'b111: OutA = o8;
    endcase

    case (OutBSel)
        3'b000: OutB = o1;
        3'b001: OutB = o2;
        3'b010: OutB = o3;
        3'b011: OutB = o4;
        3'b100: OutB = o5;
        3'b101: OutB = o6;
        3'b110: OutB = o7;
        3'b111: OutB = o8;
    endcase
end

endmodule