`include "define.vh"

module index1
(
    input wire clk,
    input wire rst_n,
    input wire [2:0] LCDI_state,

    input wire [`DATA_WIDTH-1:0] data0_in,
    input wire [`DATA_WIDTH-1:0] data1_in,
    input wire [`DATA_WIDTH-1:0] data2_in,

    output reg [`DATA_WIDTH-1:0] data0_out,
    output reg [`DATA_WIDTH-1:0] data1_out,
    output reg [`DATA_WIDTH-1:0] data2_out,

    output reg [6:0] index
);

reg [3:0] G0;
reg [3:0] G1;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data0_out<=`DATA_ZERO;
        data1_out<=`DATA_ZERO;
        data2_out<=`DATA_ZERO;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            data0_out<=data0_in;
            data1_out<=data1_in;
            data2_out<=data2_in;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        G0<=4'b0;
        G1<=4'b0;
    end 
    else begin
        G0<=classify(data0_in-data1_in);
        G1<=classify(data2_in-data1_in);
    end
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        index<=7'b0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            index<=G0+G1*9; 
        end
    end
end


function [3:0] classify 
(
input [8:0] G
);
    casex(G)
    9'b01??????? : begin classify=4'd0;end   //[128,255] 
    9'b001?????? : begin classify=4'd0;end   //[64,128) 
    9'b00011???? : begin classify=4'd0;end   //[48,64)
    9'b00010???? : begin classify=4'd1;end   //[32,48)
    9'b00001???? : begin classify=4'd2;end   //[16,32)
    9'b0000001?? : begin classify=4'd3;end   //[4,16)
    9'b0000000?? : begin classify=4'd4;end   //[0,4)
    9'b1111111?? : begin classify=4'd4;end   //[-4,0)
    9'b11111???? : begin classify=4'd5;end   //[-16,-4)
    9'b1111????? : begin classify=4'd6;end   //[-32,-16)
    9'b11101???? : begin classify=4'd7;end   //[-48,-32)
    9'b111?????? : begin classify=4'd8;end   //[-64,-48)
    9'b11??????? : begin classify=4'd8;end   //[-128,64)
    9'b1???????? : begin classify=4'd8;end   //[-256,128)
    endcase
endfunction


endmodule
