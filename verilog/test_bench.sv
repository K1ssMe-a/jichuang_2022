`include "define.vh"
`timescale 1ns / 1ps

module test_bench;


logic clk=1'b1;
logic rst_n=1'b1;
logic frame_start=1'b0;

logic frame_end;
logic line_end;
logic data_in_valid;
logic data_out_valid;


logic [`DATA_WIDTH-1:0] data0_in=$random % 256;;
logic [`DATA_WIDTH-1:0] data1_in=$random % 256;;
logic [`DATA_WIDTH-1:0] data2_in=$random % 256;;

logic [`DATA_WIDTH-1:0] data0_out;
logic [`DATA_WIDTH-1:0] data1_out;
logic [`DATA_WIDTH-1:0] data2_out;
logic [`DATA_WIDTH-1:0] data3_out;


always @(posedge clk) begin
    if(data_in_valid) begin
        data0_in<=$random % 256;
        data1_in<=$random % 256;
        data2_in<=$random % 256;
    end
end


initial begin
    #3 rst_n=1'b0;
    #2  rst_n=1'b1;
end

initial begin
    forever begin
        #1 clk=~clk;
    end
end

initial begin
    #8 frame_start=1'b1;
    #2 frame_start=1'b0;
end


LCDI LCDI_inst
(
    .clk(clk),
    .rst_n(rst_n),

    .data0_in(data0_in),
    .data1_in(data1_in),
    .data2_in(data2_in),
    .data0_out(data0_out),
    .data1_out(data1_out),
    .data2_out(data2_out),
    .data3_out(data3_out),

    .frame_start(frame_start),
    .frame_end(frame_end),
    .line_end(line_end),
    .data_in_valid(data_in_valid),
    .data_out_valid(data_out_valid)
);


endmodule
