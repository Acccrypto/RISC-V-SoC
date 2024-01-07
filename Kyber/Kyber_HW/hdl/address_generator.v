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

module address_generator_shuffling(
    input               clk, rstn,
    input   [2:0]       sel,  // 000: IDLE, 001: NTT, 010/110: PWM/PWA, 100: INTT
    output  reg [6:0]   old_address_0, old_address_1,
    output  reg [6:0]   old_address_2, old_address_3,
    output  [6:0]       tf_address,    
    output  [1:0]       ntt_l,
    output  [1:0]       wen,   
    output              done_flag
);
    
    parameter [2:0]
        IDLE    =    0,
        NTT     =    1,
        PWMA    =    2,
        INTT    =    3,
        DONE    =    4;
    
    reg  [2:0]  CS;
    reg  [6:0]  len;
    reg  [6:0]  k;
    reg  [1:0]  l;
    reg         wen_reg;
    reg         done;
    reg  [6:0]  tf_address0;
    reg  [7:0]  sf_oldaddr;
    reg  [1:0]  cnt;
    
    wire        wen_reg1, wen_reg2;
    wire        done_reg1, done_reg2;
    wire [5:0]  sf_newaddr;
    
    always @(posedge clk) begin
        if (!rstn) begin
            CS            <=    IDLE;
            sf_oldaddr    <=    0;
            len           <=    0;
            l             <=    0;
            k             <=    0;
            wen_reg       <=    0;
            done          <=    0;
            cnt           <=    0;
        end
        else begin
            case (CS)
                IDLE: begin
                    if (sel == 3'b001) begin
                        CS            <=    NTT;
                        sf_oldaddr    <=    0;
                        len           <=    64;
                        l             <=    0;
                        k             <=    0;
                    end
                    else if (sel == 3'b100) begin
                        CS            <=    INTT;
                        sf_oldaddr    <=    8'd223;
                        len           <=    2;
                        l             <=    1;
                        k             <=    0;
                    end
                    else if (sel[1] == 1'b1) begin
                        CS            <=    PWMA;
                        sf_oldaddr    <=    0;
                        len           <=    2;
                        l             <=    1;
                        k             <=    (sel[2])? 0 : 63;
                    end
                    else begin
                        CS            <=    IDLE;
                        sf_oldaddr    <=    0;
                        len           <=    0;
                        l             <=    0;
                        k             <=    0;
                    end
                    wen_reg       <=    1'b0;
                    done          <=    1'b0;
                    cnt           <=    0;
                end
                NTT: begin
                    sf_oldaddr    <=    sf_oldaddr + 1;
                    wen_reg       <=    1'b1;
                    if (sf_oldaddr == 8'd223) begin
                        done     <=    1'b1;
                        CS       <=    DONE;
                    end
                    else if (sf_oldaddr[4:0] == 5'h1f) begin
                        if (sf_oldaddr[7:5] == 5)
                            l      <=    1;
                        else
                            len    <=    len >> 1;
                    end
                end
                INTT: begin
                    sf_oldaddr    <=    sf_oldaddr - 1;
                    wen_reg       <=    1'b1;
                    if (sf_oldaddr == 8'd0) begin
                        done     <=    1'b1;
                        CS       <=    DONE;
                    end
                    else if (sf_oldaddr[4:0] == 5'h0) begin
                        if (sf_oldaddr[7:5] == 6)
                            l      <=    0;
                        else
                            len    <=    len << 1;
                    end
                end
                PWMA: begin
                    if (sel[2]) begin
                        if (k[0] == 1'b1) begin
                            sf_oldaddr    <=    sf_oldaddr + 4;
                            if (sf_oldaddr == 124) begin
                                done     <=    1'b1;
                                CS       <=    DONE;
                            end
                        end
                        k        <=    k + 1;
                        wen_reg  <=    1'b1;
                    end
                    else begin
                        cnt      <=    cnt + 1;
                        if (cnt == 2'b11) begin
                            wen_reg       <=    1'b1;
                            k             <=    k + 1;
                            sf_oldaddr    <=    sf_oldaddr + 4;
                            if (sf_oldaddr == 124) begin
                                done     <=    1'b1;
                                CS       <=    DONE;
                            end
                        end
                        else begin
                            wen_reg  <=    0;
                        end     
                    end
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
    
    delay #(.WIDTH(2), .DELAY(7)) delay_0 (
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
        .din(tf_address0), 
        .dout(tf_address)   
    ); 
    
    delay #(.WIDTH(2), .DELAY(4)) delay_3 (
        .clk(clk), 
        .din(l), 
        .dout(ntt_l)   
    ); 
    
    // shuffle the order
    shuffle_rom shuffle_rom_0(
        .old_addr(sf_oldaddr), .new_addr(sf_newaddr)
    );
    
    always @(*) begin
        if (sel == 3'b001) begin
            old_address_0 = { sf_newaddr, 1'b0 };
            if (len == 64) 
                tf_address0 = 0;
            else if (len == 32) 
                tf_address0 = sf_newaddr[5] + 1;   
            else if (len == 16) 
                tf_address0 = sf_newaddr[5:4] + 3;
            else if (len == 8) 
                tf_address0 = sf_newaddr[5:3] + 7;
            else if (len == 4) 
                tf_address0 = sf_newaddr[5:2] + 15;
            else if (len == 2) begin
                if (l == 0) 
                    tf_address0 = sf_newaddr[5:1] + 31;
                else 
                    tf_address0 = sf_newaddr[5:1] + 63;
            end
            else begin
                old_address_0 = 0;
                tf_address0 = 0;
            end
        end
        else if (sel == 3'b100) begin
            old_address_0 = { sf_newaddr, 1'b0 };
            if (len == 64) 
                tf_address0 = 0;
            else if (len == 32) 
                tf_address0 = 2 - sf_newaddr[5];   
            else if (len == 16) 
                tf_address0 = 6 - sf_newaddr[5:4];
            else if (len == 8) 
                tf_address0 = 14 - sf_newaddr[5:3];
            else if (len == 4) 
                tf_address0 = 30 - sf_newaddr[5:2];
            else if (len == 2) begin
                if (l == 0) 
                    tf_address0 = 62 - sf_newaddr[5:1];
                else 
                    tf_address0 = 94 - sf_newaddr[5:1];
            end
            else begin
                old_address_0 = 0;
                tf_address0 = 0;
            end
        end
        else if (sel[1] == 1'b1) begin
            old_address_0 = sf_oldaddr;
            tf_address0 = k;
        end
        else begin
            old_address_0 = 0;
            tf_address0 = 0;
        end
        old_address_1 = old_address_0 + 1;
        old_address_2 = old_address_0 + len;
        old_address_3 = old_address_1 + len;
    end
    
    assign  wen = { wen_reg1, wen_reg2 };
    assign  done_flag = done_reg2;

endmodule

module address_generator_inplace(
    input               clk, rstn,
    input   [2:0]       sel,  // 000: IDLE, 001: NTT, 010/110: PWM/PWA, 100: INTT
    output  [6:0]       old_address_0, old_address_1,
    output  [6:0]       old_address_2, old_address_3,
    output  [6:0]       tf_address,    
    output  [1:0]       ntt_l,
    output  [1:0]       wen,   
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
    reg  [6:0]  k;
    reg  [1:0]  l;
    reg         wen_reg;
    reg         done;
    
    wire        wen_reg1, wen_reg2;
    wire        done_reg1, done_reg2;
    
    always @(posedge clk) begin
        if (!rstn) begin
            CS       <=    0;
            len      <=    0;
            start    <=    0;
            j        <=    0;
            k        <=    0;
            l        <=    0;
            wen_reg  <=    0;
            done     <=    0;
        end
        else begin
            case (CS)
                IDLE: begin
                    if (sel[1] == 1'b1) begin
                        CS       <=    PWMA;
                        len      <=    2;
                        l        <=    1;
                        k        <=    (sel[2])? 0 : 63;
                    end
                    else if (sel[0] == 1'b1) begin
                        CS       <=    NTT;
                        len      <=    64;
                        l        <=    0;
                        k        <=    0;
                    end
                    else if (sel[2] == 1'b1) begin
                        CS       <=    INTT;
                        len      <=    2;
                        l        <=    1;
                        k        <=    94;
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
                    done     <=    0;
                end
                NTT, INTT: begin
                    if (j == start + len - 2) begin
                        if (old_address_3 == 127) begin
                            if (len == 2) begin
                                if (CS == NTT) begin
                                    if (l == 1) begin
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
                    if (sel[2]) begin
                        if (start[0]) begin
                            j        <=    j + 4;
                            if (old_address_3 == 127) begin
                                done     <=    1'b1;
                                CS       <=    DONE;
                            end
                        end
                        k        <=    k + 1;
                        wen_reg  <=    1'b1;
                    end
                    else begin
                        if (start[1:0] == 2'b11) begin
                            wen_reg  <=    1'b1;
                            j        <=    j + 4;
                            k        <=    k + 1;
                            if (old_address_3 == 127) begin
                                done     <=    1'b1;
                                CS       <=    DONE;
                            end
                        end
                        else begin
                            wen_reg  <=    0;
                        end     
                    end
                    start[1:0]    <=    start[1:0] + 1;
                end
                DONE: begin
                    wen_reg  <=    0;
                    k        <=    0;
                    done     <=    0;
                    if (done_flag)
                        CS       <=    IDLE;
                end
            endcase
        end
    end
    
    delay #(.WIDTH(2), .DELAY(7)) delay_0 (
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
    assign  wen = { wen_reg1, wen_reg2 };
    assign  done_flag = done_reg2;

endmodule
