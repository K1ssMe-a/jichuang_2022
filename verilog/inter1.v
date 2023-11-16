`include "define.vh"


module inter1
(
    input wire clk,
    input wire rst_n,
    input wire [2:0] LCDI_state,
    
    input wire [6:0] index,
    input wire [`DATA_WIDTH-1:0] data0_in,
    input wire [`DATA_WIDTH-1:0] data1_in,
    input wire [`DATA_WIDTH-1:0] data2_in,

    output reg write_enable,
    output reg [`DATA_WIDTH-1:0] data0_out,
    output reg [`DATA_WIDTH-1:0] data1_out,
    output reg [`DATA_WIDTH-1:0] data2_out,
    output reg [`DATA_WIDTH-1:0] data3_out
);

reg signed [9:0] coeff0_0, coeff0_1, coeff0_2;
reg signed [9:0] coeff1_0, coeff1_1, coeff1_2;

reg signed [16:0] tmp_result0_0, tmp_result0_1, tmp_result0_2;
reg signed [16:0] tmp_result1_0, tmp_result1_1, tmp_result1_2;

wire signed [18:0] tmp_add_result0 ,tmp_add_result1;

reg [7:0] add_result0,add_result1;

wire [31:0] W_VU1_data;
wire [31:0] W_VU2_data;
wire [31:0] W_VL1_data;
wire [31:0] W_VL2_data;

always @(*) begin
    case(LCDI_state)
    `LCDI_STATE2:begin
        coeff0_0=W_VU1_data[29:20]; coeff0_1=W_VU1_data[19:10]; coeff0_2=W_VU1_data[9:0];
        coeff1_0=W_VU2_data[29:20]; coeff1_1=W_VU2_data[19:10]; coeff1_2=W_VU2_data[9:0];
    end
    `LCDI_STATE3:begin 
        coeff0_0=W_VL1_data[29:20]; coeff0_1=W_VL1_data[19:10]; coeff0_2=W_VL1_data[9:0];
        coeff1_0=W_VL2_data[29:20]; coeff1_1=W_VL2_data[19:10]; coeff1_2=W_VL2_data[9:0];
    end
    default:begin
        coeff0_0=`COEFF_ZERO; coeff0_1=`COEFF_ZERO; coeff0_2=`COEFF_ZERO; 
        coeff1_0=`COEFF_ZERO; coeff1_1=`COEFF_ZERO; coeff1_2=`COEFF_ZERO; 
    end
    endcase
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        tmp_result0_0<=`MUTI_ZERO; tmp_result0_1<=`MUTI_ZERO; tmp_result0_2<=`MUTI_ZERO;
        tmp_result1_0<=`MUTI_ZERO; tmp_result1_1<=`MUTI_ZERO; tmp_result1_2<=`MUTI_ZERO;
    end
    else begin
        tmp_result0_0<=$signed({1'b0,data0_in})*coeff0_0;
        tmp_result0_1<=$signed({1'b0,data1_in})*coeff0_1;
        tmp_result0_2<=$signed({1'b0,data2_in})*coeff0_2;
        tmp_result1_0<=$signed({1'b0,data0_in})*coeff1_0;
        tmp_result1_1<=$signed({1'b0,data1_in})*coeff1_1;
        tmp_result1_2<=$signed({1'b0,data2_in})*coeff1_2;
    end
end

assign tmp_add_result0=tmp_result0_0+tmp_result0_1+tmp_result0_2;
assign tmp_add_result1=tmp_result1_0+tmp_result1_1+tmp_result1_2;



assign add_result0=anti_flow(tmp_add_result0);
assign add_result1=anti_flow(tmp_add_result1);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data0_out<=`DATA_ZERO;
        data1_out<=`DATA_ZERO;
        data2_out<=`DATA_ZERO;
        data3_out<=`DATA_ZERO;
    end
    else begin
        case(LCDI_state)
        `LCDI_STATE3:begin
            data0_out<=add_result0;
            data1_out<=add_result1;
        end
        `LCDI_STATE4:begin
            data2_out<=add_result0;
            data3_out<=add_result1;
        end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        write_enable<=1'b0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE4) begin
            write_enable<=1'b1;
        end
        else begin
            write_enable<=1'b0;
        end
    end
end


W_VL1 W_VL1_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_VL1_data)
);

W_VL2 W_VL2_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_VL2_data)
);

W_VU1 W_VU1_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_VU1_data)
);

W_VU2 W_VU2_inst
(
    .clka(clk),
    .ena(1'b1),
    .addra(index),
    .douta(W_VU2_data)
);

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


endmodule
