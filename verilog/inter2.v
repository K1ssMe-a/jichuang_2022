`include "define.vh"


module inter2
(
    input wire clk,
    input wire rst_n,
    input wire [2:0] LCDI_state,
    
    input wire  [6:0] index0,
    input wire  [6:0] index1,
    input wire  [6:0] index2,
    input wire  [6:0] index3,

    input wire [`DATA_WIDTH-1:0] data0_in,
    input wire [`DATA_WIDTH-1:0] data1_in,
    input wire [`DATA_WIDTH-1:0] data2_in,

    output reg [`DATA_WIDTH-1:0] data0_out,
    output reg [`DATA_WIDTH-1:0] data1_out,
    output reg [`DATA_WIDTH-1:0] data2_out,
    output reg [`DATA_WIDTH-1:0] data3_out
);

reg [6:0] index;

wire [31:0] W_HL1_data;
wire [31:0] W_HL2_data;
wire [31:0] W_HR1_data;
wire [31:0] W_HR2_data;

wire signed [9:0] coeff0_0, coeff0_1, coeff0_2;
wire signed [9:0] coeff1_0, coeff1_1, coeff1_2;
wire signed [9:0] coeff2_0, coeff2_1, coeff2_2;
wire signed [9:0] coeff3_0, coeff3_1, coeff3_2;

reg signed [16:0] tmp_result0_0, tmp_result0_1, tmp_result0_2;
reg signed [16:0] tmp_result1_0, tmp_result1_1, tmp_result1_2;
reg signed [16:0] tmp_result2_0, tmp_result2_1, tmp_result2_2;
reg signed [16:0] tmp_result3_0, tmp_result3_1, tmp_result3_2;

wire signed [18:0] tmp_add_result0, tmp_add_result1, tmp_add_result2, tmp_add_result3;
wire [7:0] add_result0,add_result1,add_result2,add_result3;


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        index<=7'b0;
    end
    else begin
        case(LCDI_state)
        `LCDI_STATE6:index<=index0;
        `LCDI_STATE1:index<=index1;
        `LCDI_STATE2:index<=index2;
        `LCDI_STATE3:index<=index3;
        endcase
    end
end

assign coeff0_0=W_HL1_data[29:20];
assign coeff0_1=W_HL1_data[19:10];
assign coeff0_2=W_HL1_data[9 :0 ];
assign coeff1_0=W_HL2_data[29:20];
assign coeff1_1=W_HL2_data[19:10];
assign coeff1_2=W_HL2_data[9 :0 ];
assign coeff2_0=W_HR1_data[29:20];
assign coeff2_1=W_HR1_data[19:10];
assign coeff2_2=W_HR1_data[9 :0 ];
assign coeff3_0=W_HR2_data[29:20];
assign coeff3_1=W_HR2_data[19:10];
assign coeff3_2=W_HR2_data[9 :0 ];


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        tmp_result0_0<=17'd0; tmp_result0_1<=17'd0; tmp_result0_2<=17'd0;
        tmp_result1_0<=17'd0; tmp_result1_1<=17'd0; tmp_result1_2<=17'd0;
        tmp_result2_0<=17'd0; tmp_result2_1<=17'd0; tmp_result2_2<=17'd0;
        tmp_result3_0<=17'd0; tmp_result3_1<=17'd0; tmp_result3_2<=17'd0;
    end
    else begin
        tmp_result0_0 <= coeff0_0 * $signed({1'b0,data0_in}); 
        tmp_result0_1 <= coeff0_1 * $signed({1'b0,data1_in}); 
        tmp_result0_2 <= coeff0_2 * $signed({1'b0,data2_in});
        tmp_result1_0 <= coeff1_0 * $signed({1'b0,data0_in}); 
        tmp_result1_1 <= coeff1_1 * $signed({1'b0,data1_in}); 
        tmp_result1_2 <= coeff1_2 * $signed({1'b0,data2_in});
        tmp_result2_0 <= coeff2_0 * $signed({1'b0,data0_in}); 
        tmp_result2_1 <= coeff2_1 * $signed({1'b0,data1_in}); 
        tmp_result2_2 <= coeff2_2 * $signed({1'b0,data2_in});
        tmp_result3_0 <= coeff3_0 * $signed({1'b0,data0_in}); 
        tmp_result3_1 <= coeff3_1 * $signed({1'b0,data1_in}); 
        tmp_result3_2 <= coeff3_2 * $signed({1'b0,data2_in});
    end
end


assign tmp_add_result0=tmp_result0_0+tmp_result0_1+tmp_result0_2;
assign tmp_add_result1=tmp_result1_0+tmp_result1_1+tmp_result1_2;
assign tmp_add_result2=tmp_result2_0+tmp_result2_1+tmp_result2_2;
assign tmp_add_result3=tmp_result3_0+tmp_result3_1+tmp_result3_2;

assign add_result0=anti_flow(tmp_add_result0);
assign add_result1=anti_flow(tmp_add_result1);
assign add_result2=anti_flow(tmp_add_result2);
assign add_result3=anti_flow(tmp_add_result3);


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data0_out<=`DATA_ZERO;
        data1_out<=`DATA_ZERO;
        data2_out<=`DATA_ZERO;
        data3_out<=`DATA_ZERO;
    end
    else begin
        data0_out<=add_result0;
        data1_out<=add_result1;
        data2_out<=add_result2;
        data3_out<=add_result3;
    end
end


function [7:0] anti_flow(input [18:0] data_in)
    if(data_in[18]==1'b1) begin
        anti_flow=8'b0;
    end
    else if(data_in[17:16]!=2'b0) begin
        anti_flow=8'hff;
    end
    else if(data0_in[7]==1'b1) begin
        anti_flow=data_in[15:8]+8'b1;
    end
    else begin
        anti_flow=data_in[15:8];
    end
endfunction


W_HL1 W_HL1_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_HL1_data)
);

W_HL2 W_HL2_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_HL2_data)
);

W_HR1 W_HR1_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_HR1_data)
);

W_HR2 W_HR2_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_HR2_data)
);

endmodule

