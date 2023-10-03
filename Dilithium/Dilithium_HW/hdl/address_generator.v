///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: address_generator.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFireSoC> <Die::MPFS250T_ES> <Package::FCVG484>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module address_generator(
    input               clk, rstn,
    input   [2:0]       sel,  // 000: IDLE, 001: NTT, 010/110: PWM/PWA, 100: INTT
    output  [6:0]       old_address_0, old_address_1,
    output  [6:0]       old_address_2, old_address_3,
    output  [7:0]       tf_address,    
    output  [1:0]       ntt_l,
    output              wen,   
    output              done_flag
);
    
    parameter [2:0]
        IDLE    =    0,
        NTT     =    1,
        PWMA    =    2,
        INTT    =    3,
        DONE    =    4;
    
    reg  [2:0]  CS;
    reg  [6:0]  len, start, j;
    reg  [7:0]  k;
    reg  [1:0]  l;
    reg         dl_sel;
    reg         wen_reg;
    reg         done;
    
    wire        wen_reg1, wen_reg2;
    wire [1:0]  ntt_l_reg1, ntt_l_reg2;
    wire        done_reg1, done_reg2;
    
    always @(posedge clk) begin
        if (!rstn) begin
            CS       <=    0;
            len      <=    0;
            start    <=    0;
            j        <=    0;
            k        <=    0;
            l        <=    0;
            dl_sel   <=    0;
            wen_reg  <=    0;
            done     <=    0;
        end
        else begin
            case (CS)
                IDLE: begin
                    if (sel[0] == 1'b1) begin
                        CS       <=    NTT;
                        len      <=    64;
                        l        <=    0;
                        k        <=    0;
                    end
                    else if (sel[1] == 1'b1) begin
                        CS       <=    PWMA;
                        len      <=    2;
                        l        <=    2;
                        k        <=    0;
                    end
                    else if (sel[2] == 1'b1) begin
                        CS       <=    INTT;
                        len      <=    2;
                        l        <=    2;
                        k        <=    254;
                    end
                    else begin
                        CS       <=    IDLE;
                        len      <=    0;
                        l        <=    0;
                        k        <=    0;
                    end
                    wen_reg  <=    0;
                    start    <=    0;
                    j        <=    0;
                    dl_sel   <=    sel[2] & sel[1];
                    done     <=    0;
                end
                NTT, INTT: begin
                    if (j == start + len - 2) begin
                        if (old_address_3 == 127) begin
                            if (len == 2) begin
                                if (CS == NTT) begin
                                    if (l == 2) begin
                                        done     <=    1'b1;
                                        CS       <=    DONE;
                                    end
                                    else begin
                                        l        <=    l + 1;
                                    end
                                end
                                else begin
                                    if (l == 0) begin
                                        len      <=    len << 1;
                                    end
                                    else begin
                                        l        <=    l - 1;
                                    end
                                end                             
                            end
                            else begin
                                if (CS == NTT) begin
                                    len      <=    len >> 1;
                                end
                                else begin
                                    if (len == 64) begin
                                        done     <=    1'b1;
                                        CS       <=    DONE;
                                    end
                                    else begin
                                        len      <=    len << 1;
                                    end
                                end
                            end
                            start    <=    0;
                            j        <=    0;
                        end
                        else begin
                            start    <=    j + len + 2;
                            j        <=    j + len + 2;
                        end
                        if (CS == NTT) begin
                            k        <=    k + 1;
                        end
                        else begin
                            k        <=    k - 1;
                        end
                    end
                    else begin
                        j        <=    j + 2;
                    end
                    wen_reg  <=    1'b1;
                end
                PWMA: begin
                    if ((old_address_3 == 127) && (k[0] == 1'b1)) begin
                        wen_reg  <=    sel[2];
                        done     <=    1'b1;
                        CS       <=    DONE;
                    end
                    else begin
                        if (k[0]) begin
                            j        <=    j + 4;
                            wen_reg  <=    sel[2];
                        end
                        else begin
                            wen_reg  <=    1'b1;
                        end
                    end
                    k[0]     <=    ~k[0];
                end
                DONE: begin
                    wen_reg  <=    0;
                    done     <=    0;
                    if (done_flag)
                        CS       <=    IDLE;
                end
            endcase
        end
    end
    
    delay #(.WIDTH(2), .DELAY(4)) delay_0 (
        .clk(clk), 
        .din({ wen_reg, done }), 
        .dout({ wen_reg1, done_reg1 })   
    ); 
    
    delay #(.WIDTH(2), .DELAY(3)) delay_1 (
        .clk(clk), 
        .din({ wen_reg1, done_reg1 }), 
        .dout({ wen_reg2, done_reg2 })   
    ); 
    
    delay #(.WIDTH(8), .DELAY(3)) delay_2 (
        .clk(clk), 
        .din(k), 
        .dout(tf_address)   
    ); 
    
    delay #(.WIDTH(2), .DELAY(4)) delay_3 (
        .clk(clk), 
        .din(l), 
        .dout(ntt_l)   
    ); 
    
    assign  old_address_0 = j;
    assign  old_address_1 = j + 1;
    assign  old_address_2 = old_address_0 + len;
    assign  old_address_3 = old_address_1 + len;
    assign  { wen, done_flag } = (dl_sel)? { wen_reg1, done_reg1 } : { wen_reg2, done_reg2 };

endmodule

