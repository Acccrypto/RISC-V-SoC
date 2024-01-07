`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/04 11:16:47
// Design Name: 
// Module Name: shuffle_rom
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

module shuffle_rom(
    input      [7:0]  old_addr,
    output reg [5:0]  new_addr
    );
    
    always @(*) begin
        case (old_addr)
            8'd0: new_addr = 6'd1;
            8'd1: new_addr = 6'd9;
            8'd2: new_addr = 6'd28;
            8'd3: new_addr = 6'd30;
            8'd4: new_addr = 6'd31;
            8'd5: new_addr = 6'd14;
            8'd6: new_addr = 6'd7;
            8'd7: new_addr = 6'd2;
            8'd8: new_addr = 6'd19;
            8'd9: new_addr = 6'd16;
            8'd10: new_addr = 6'd3;
            8'd11: new_addr = 6'd13;
            8'd12: new_addr = 6'd6;
            8'd13: new_addr = 6'd27;
            8'd14: new_addr = 6'd5;
            8'd15: new_addr = 6'd15;
            8'd16: new_addr = 6'd10;
            8'd17: new_addr = 6'd26;
            8'd18: new_addr = 6'd0;
            8'd19: new_addr = 6'd21;
            8'd20: new_addr = 6'd4;
            8'd21: new_addr = 6'd24;
            8'd22: new_addr = 6'd22;
            8'd23: new_addr = 6'd8;
            8'd24: new_addr = 6'd17;
            8'd25: new_addr = 6'd23;
            8'd26: new_addr = 6'd12;
            8'd27: new_addr = 6'd20;
            8'd28: new_addr = 6'd25;
            8'd29: new_addr = 6'd11;
            8'd30: new_addr = 6'd29;
            8'd31: new_addr = 6'd18;
            8'd32: new_addr = 6'd3;
            8'd33: new_addr = 6'd6;
            8'd34: new_addr = 6'd8;
            8'd35: new_addr = 6'd7;
            8'd36: new_addr = 6'd15;
            8'd37: new_addr = 6'd14;
            8'd38: new_addr = 6'd0;
            8'd39: new_addr = 6'd47;
            8'd40: new_addr = 6'd46;
            8'd41: new_addr = 6'd34;
            8'd42: new_addr = 6'd9;
            8'd43: new_addr = 6'd13;
            8'd44: new_addr = 6'd33;
            8'd45: new_addr = 6'd39;
            8'd46: new_addr = 6'd11;
            8'd47: new_addr = 6'd41;
            8'd48: new_addr = 6'd2;
            8'd49: new_addr = 6'd12;
            8'd50: new_addr = 6'd40;
            8'd51: new_addr = 6'd38;
            8'd52: new_addr = 6'd37;
            8'd53: new_addr = 6'd32;
            8'd54: new_addr = 6'd10;
            8'd55: new_addr = 6'd35;
            8'd56: new_addr = 6'd36;
            8'd57: new_addr = 6'd5;
            8'd58: new_addr = 6'd1;
            8'd59: new_addr = 6'd42;
            8'd60: new_addr = 6'd45;
            8'd61: new_addr = 6'd4;
            8'd62: new_addr = 6'd43;
            8'd63: new_addr = 6'd44;
            8'd64: new_addr = 6'd23;
            8'd65: new_addr = 6'd16;
            8'd66: new_addr = 6'd55;
            8'd67: new_addr = 6'd7;
            8'd68: new_addr = 6'd17;
            8'd69: new_addr = 6'd34;
            8'd70: new_addr = 6'd5;
            8'd71: new_addr = 6'd2;
            8'd72: new_addr = 6'd21;
            8'd73: new_addr = 6'd53;
            8'd74: new_addr = 6'd52;
            8'd75: new_addr = 6'd20;
            8'd76: new_addr = 6'd6;
            8'd77: new_addr = 6'd19;
            8'd78: new_addr = 6'd33;
            8'd79: new_addr = 6'd54;
            8'd80: new_addr = 6'd22;
            8'd81: new_addr = 6'd48;
            8'd82: new_addr = 6'd32;
            8'd83: new_addr = 6'd3;
            8'd84: new_addr = 6'd51;
            8'd85: new_addr = 6'd50;
            8'd86: new_addr = 6'd1;
            8'd87: new_addr = 6'd38;
            8'd88: new_addr = 6'd39;
            8'd89: new_addr = 6'd18;
            8'd90: new_addr = 6'd36;
            8'd91: new_addr = 6'd4;
            8'd92: new_addr = 6'd49;
            8'd93: new_addr = 6'd0;
            8'd94: new_addr = 6'd37;
            8'd95: new_addr = 6'd35;
            8'd96: new_addr = 6'd51;
            8'd97: new_addr = 6'd42;
            8'd98: new_addr = 6'd10;
            8'd99: new_addr = 6'd25;
            8'd100: new_addr = 6'd34;
            8'd101: new_addr = 6'd40;
            8'd102: new_addr = 6'd18;
            8'd103: new_addr = 6'd49;
            8'd104: new_addr = 6'd17;
            8'd105: new_addr = 6'd57;
            8'd106: new_addr = 6'd56;
            8'd107: new_addr = 6'd24;
            8'd108: new_addr = 6'd26;
            8'd109: new_addr = 6'd2;
            8'd110: new_addr = 6'd1;
            8'd111: new_addr = 6'd11;
            8'd112: new_addr = 6'd8;
            8'd113: new_addr = 6'd27;
            8'd114: new_addr = 6'd0;
            8'd115: new_addr = 6'd33;
            8'd116: new_addr = 6'd3;
            8'd117: new_addr = 6'd59;
            8'd118: new_addr = 6'd16;
            8'd119: new_addr = 6'd58;
            8'd120: new_addr = 6'd48;
            8'd121: new_addr = 6'd35;
            8'd122: new_addr = 6'd41;
            8'd123: new_addr = 6'd9;
            8'd124: new_addr = 6'd19;
            8'd125: new_addr = 6'd43;
            8'd126: new_addr = 6'd50;
            8'd127: new_addr = 6'd32;
            8'd128: new_addr = 6'd24;
            8'd129: new_addr = 6'd57;
            8'd130: new_addr = 6'd12;
            8'd131: new_addr = 6'd1;
            8'd132: new_addr = 6'd49;
            8'd133: new_addr = 6'd13;
            8'd134: new_addr = 6'd60;
            8'd135: new_addr = 6'd4;
            8'd136: new_addr = 6'd8;
            8'd137: new_addr = 6'd33;
            8'd138: new_addr = 6'd21;
            8'd139: new_addr = 6'd48;
            8'd140: new_addr = 6'd20;
            8'd141: new_addr = 6'd44;
            8'd142: new_addr = 6'd45;
            8'd143: new_addr = 6'd52;
            8'd144: new_addr = 6'd16;
            8'd145: new_addr = 6'd61;
            8'd146: new_addr = 6'd29;
            8'd147: new_addr = 6'd56;
            8'd148: new_addr = 6'd25;
            8'd149: new_addr = 6'd37;
            8'd150: new_addr = 6'd28;
            8'd151: new_addr = 6'd5;
            8'd152: new_addr = 6'd9;
            8'd153: new_addr = 6'd0;
            8'd154: new_addr = 6'd53;
            8'd155: new_addr = 6'd40;
            8'd156: new_addr = 6'd36;
            8'd157: new_addr = 6'd32;
            8'd158: new_addr = 6'd17;
            8'd159: new_addr = 6'd41;
            8'd160: new_addr = 6'd22;
            8'd161: new_addr = 6'd60;
            8'd162: new_addr = 6'd28;
            8'd163: new_addr = 6'd2;
            8'd164: new_addr = 6'd30;
            8'd165: new_addr = 6'd24;
            8'd166: new_addr = 6'd6;
            8'd167: new_addr = 6'd44;
            8'd168: new_addr = 6'd38;
            8'd169: new_addr = 6'd40;
            8'd170: new_addr = 6'd0;
            8'd171: new_addr = 6'd10;
            8'd172: new_addr = 6'd8;
            8'd173: new_addr = 6'd32;
            8'd174: new_addr = 6'd16;
            8'd175: new_addr = 6'd50;
            8'd176: new_addr = 6'd46;
            8'd177: new_addr = 6'd42;
            8'd178: new_addr = 6'd18;
            8'd179: new_addr = 6'd26;
            8'd180: new_addr = 6'd20;
            8'd181: new_addr = 6'd36;
            8'd182: new_addr = 6'd4;
            8'd183: new_addr = 6'd12;
            8'd184: new_addr = 6'd52;
            8'd185: new_addr = 6'd14;
            8'd186: new_addr = 6'd56;
            8'd187: new_addr = 6'd58;
            8'd188: new_addr = 6'd62;
            8'd189: new_addr = 6'd54;
            8'd190: new_addr = 6'd48;
            8'd191: new_addr = 6'd34;
            8'd192: new_addr = 6'd32;
            8'd193: new_addr = 6'd12;
            8'd194: new_addr = 6'd24;
            8'd195: new_addr = 6'd2;
            8'd196: new_addr = 6'd14;
            8'd197: new_addr = 6'd16;
            8'd198: new_addr = 6'd18;
            8'd199: new_addr = 6'd38;
            8'd200: new_addr = 6'd50;
            8'd201: new_addr = 6'd62;
            8'd202: new_addr = 6'd48;
            8'd203: new_addr = 6'd34;
            8'd204: new_addr = 6'd60;
            8'd205: new_addr = 6'd0;
            8'd206: new_addr = 6'd52;
            8'd207: new_addr = 6'd30;
            8'd208: new_addr = 6'd8;
            8'd209: new_addr = 6'd36;
            8'd210: new_addr = 6'd56;
            8'd211: new_addr = 6'd28;
            8'd212: new_addr = 6'd20;
            8'd213: new_addr = 6'd44;
            8'd214: new_addr = 6'd4;
            8'd215: new_addr = 6'd22;
            8'd216: new_addr = 6'd58;
            8'd217: new_addr = 6'd40;
            8'd218: new_addr = 6'd46;
            8'd219: new_addr = 6'd10;
            8'd220: new_addr = 6'd42;
            8'd221: new_addr = 6'd54;
            8'd222: new_addr = 6'd6;
            8'd223: new_addr = 6'd26;
            default: new_addr = 6'd0;
        endcase
    end
    
endmodule
