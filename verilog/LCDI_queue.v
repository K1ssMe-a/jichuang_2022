`include "define.vh"

module LCDI_queue
(
    input wire clk,
    input wire rst_n,

    input wire [2:0] LCDI_state,
    input wire write_enable,
    input wire [`DATA_WIDTH-1:0] data0_in,
    input wire [`DATA_WIDTH-1:0] data1_in,
    input wire [`DATA_WIDTH-1:0] data2_in,
    input wire [`DATA_WIDTH-1:0] data3_in,

    output reg [`DATA_WIDTH-1:0] index_data0_out,
    output reg [`DATA_WIDTH-1:0] index_data1_out,
    output reg [`DATA_WIDTH-1:0] index_data2_out,

    output reg [`DATA_WIDTH-1:0] inter_data0_out,
    output reg [`DATA_WIDTH-1:0] inter_data1_out,
    output reg [`DATA_WIDTH-1:0] inter_data2_out
);

reg [1:0] col_index;

reg [`DATA_WIDTH-1:0] tmp_data0_out;
reg [`DATA_WIDTH-1:0] tmp_data1_out;
reg [`DATA_WIDTH-1:0] tmp_data2_out;
reg [`DATA_WIDTH-1:0] tmp_data3_out;

reg [`DATA_WIDTH-1:0] tmp_data0_0, tmp_data0_1, tmp_data0_2, tmp_data0_3;
reg [`DATA_WIDTH-1:0] tmp_data1_0, tmp_data1_1, tmp_data1_2, tmp_data1_3;
reg [`DATA_WIDTH-1:0] tmp_data2_0, tmp_data2_1, tmp_data2_2, tmp_data2_3;
reg [`DATA_WIDTH-1:0] tmp_data3_0, tmp_data3_1, tmp_data3_2, tmp_data3_3;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        col_index<=2'd0;
    end
    else begin
        if(write_enable) begin
            col_index<=col_index+2'd1;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        tmp_data0_0<=`DATA_ZERO;tmp_data0_1<=`DATA_ZERO;tmp_data0_2<=`DATA_ZERO;tmp_data0_3<=`DATA_ZERO;
        tmp_data1_0<=`DATA_ZERO;tmp_data1_1<=`DATA_ZERO;tmp_data1_2<=`DATA_ZERO;tmp_data1_3<=`DATA_ZERO;
        tmp_data2_0<=`DATA_ZERO;tmp_data2_1<=`DATA_ZERO;tmp_data2_2<=`DATA_ZERO;tmp_data2_3<=`DATA_ZERO;
        tmp_data3_0<=`DATA_ZERO;tmp_data3_1<=`DATA_ZERO;tmp_data3_2<=`DATA_ZERO;tmp_data3_3<=`DATA_ZERO;
    end
    else begin
        if(write_enable) begin
            case(col_index) 
            2'd0:begin
                tmp_data0_0<=data0_in;
                tmp_data1_0<=data1_in;
                tmp_data2_0<=data2_in;
                tmp_data3_0<=data3_in;
            end
            2'd1:begin
                tmp_data0_1<=data0_in;
                tmp_data1_1<=data1_in;
                tmp_data2_1<=data2_in;
                tmp_data3_1<=data3_in;
            end
            2'd2:begin
                tmp_data0_2<=data0_in;
                tmp_data1_2<=data1_in;
                tmp_data2_2<=data2_in;
                tmp_data3_2<=data3_in;
            end
            2'd3:begin
                tmp_data0_3<=data0_in;
                tmp_data1_3<=data1_in;
                tmp_data2_3<=data2_in;
                tmp_data3_3<=data3_in;
            end
            endcase
        end
    end
end

always @(*) begin
    case(LCDI_state)
    `LCDI_STATE1:begin
        tmp_data0_out=tmp_data0_0;
        tmp_data1_out=tmp_data0_1;
        tmp_data2_out=tmp_data0_2;
        tmp_data3_out=tmp_data0_3;
    end
    `LCDI_STATE2:begin
        tmp_data0_out=tmp_data1_0;
        tmp_data1_out=tmp_data1_1;
        tmp_data2_out=tmp_data1_2;
        tmp_data3_out=tmp_data1_3;
    end
    `LCDI_STATE3:begin
        tmp_data0_out=tmp_data2_0;
        tmp_data1_out=tmp_data2_1;
        tmp_data2_out=tmp_data2_2;
        tmp_data3_out=tmp_data2_3;
    end
    `LCDI_STATE4:begin
        tmp_data0_out=tmp_data3_0;
        tmp_data1_out=tmp_data3_1;
        tmp_data2_out=tmp_data3_2;
        tmp_data3_out=tmp_data3_3;
    end
    default:begin
        tmp_data0_out=`DATA_ZERO;
        tmp_data1_out=`DATA_ZERO;
        tmp_data2_out=`DATA_ZERO;
        tmp_data3_out=`DATA_ZERO;
    end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        index_data0_out<=`DATA_ZERO;
        index_data1_out<=`DATA_ZERO;
        index_data2_out<=`DATA_ZERO;
    end
    else begin
        case(col_index)
        2'd0:begin
            index_data0_out<=tmp_data1_out;
            index_data1_out<=tmp_data2_out;
            index_data2_out<=tmp_data3_out;
        end
        2'd1:begin
            index_data0_out<=tmp_data2_out;
            index_data1_out<=tmp_data3_out;
            index_data2_out<=tmp_data0_out;
        end
        2'd2:begin
            index_data0_out<=tmp_data3_out;
            index_data1_out<=tmp_data0_out;
            index_data2_out<=tmp_data1_out;
        end
        2'd3:begin
            index_data0_out<=tmp_data0_out;
            index_data1_out<=tmp_data1_out;
            index_data2_out<=tmp_data2_out;
        end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        inter_data0_out<=`DATA_ZERO;
        inter_data1_out<=`DATA_ZERO;
        inter_data2_out<=`DATA_ZERO;
    end
    else begin
        case(col_index)
        2'd0:begin
            inter_data0_out<=tmp_data0_out;
            inter_data1_out<=tmp_data1_out;
            inter_data2_out<=tmp_data2_out;
        end
        2'd1:begin
            inter_data0_out<=tmp_data1_out;
            inter_data1_out<=tmp_data2_out;
            inter_data2_out<=tmp_data3_out;
        end
        2'd2:begin
            inter_data0_out<=tmp_data2_out;
            inter_data1_out<=tmp_data3_out;
            inter_data2_out<=tmp_data0_out;
        end
        2'd3:begin
            inter_data0_out<=tmp_data3_out;
            inter_data1_out<=tmp_data0_out;
            inter_data2_out<=tmp_data1_out;
        end
        endcase
    end
end



endmodule

