`include "define.vh"

module LCDI 
(
    input wire clk,
    input wire rst_n,

    input wire [`DATA_WIDTH-1:0] data0_in,    //原始数据行缓存1
    input wire [`DATA_WIDTH-1:0] data1_in,    //原始数据行缓存2
    input wire [`DATA_WIDTH-1:0] data2_in,    //原始数据行缓存3

    output wire [`DATA_WIDTH-1:0] data0_out,
    output wire [`DATA_WIDTH-1:0] data1_out,
    output wire [`DATA_WIDTH-1:0] data2_out,
    output wire [`DATA_WIDTH-1:0] data3_out,

    input wire frame_start,
    output reg frame_end,
    output reg line_end,

    output reg data_out_valid,  //相当于write_ram_enable
    output reg data_in_valid,   //切换数据的前一个时钟周期拉高
    input wire data_in_ready    //不需要管
);

reg [2:0] LCDI_state;
reg [2:0] next_state;

reg [9:0] col_count;
reg [9:0] row_count;


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        LCDI_state<=`LCDI_IDLE;
    end
    else begin
        LCDI_state<=next_state;
    end
end

always @(*) begin
    case(LCDI_state)
    `LCDI_IDLE:begin
        if(frame_start) begin
            next_state=`LCDI_STATE1;        
        end
        else begin
            next_state=`LCDI_IDLE;        
        end
    end
    `LCDI_STATE1:next_state=`LCDI_STATE2;
    `LCDI_STATE2:next_state=`LCDI_STATE3;
    `LCDI_STATE3:next_state=`LCDI_STATE4;
    `LCDI_STATE4:next_state=`LCDI_STATE5;
    `LCDI_STATE5:next_state=`LCDI_STATE6;
    `LCDI_STATE6:begin
        if(col_count==10'd962&&row_count==10'd540) begin
            next_state=`LCDI_IDLE;
        end
        else begin
            next_state=`LCDI_STATE1;
        end
    end
    default:next_state=`LCDI_IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        col_count<=-10'd3;  //fulling the flow line needs extra 3 cycles
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            if(col_count<10'd963) begin
                col_count<=col_count+10'd1;
            end
            else begin
                col_count<=10'd1;
            end
        end
        else if(LCDI_state==`LCDI_IDLE) begin
            col_count<=-10'd3;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        row_count<=10'd0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            if(col_count==10'd962) begin
                row_count<=row_count+10'd1;
            end
        end
        else if(LCDI_state==`LCDI_IDLE) begin
            row_count<=10'd0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        line_end<=1'b0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            if(row_count!=10'd0&&col_count==10'd962) begin
                line_end<=1'b1;
            end
            else begin
                line_end<=1'b0;
            end
        end
        else begin
            line_end=1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        frame_end<=1'b0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6) begin
            if(col_count==10'd962&&row_count==10'd540) begin
                frame_end<=1'b1;
            end
        end
        else begin
            frame_end<=1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_out_valid<=1'b0;
    end
    else begin
        if((LCDI_state==`LCDI_STATE6||LCDI_state==`LCDI_STATE5||
        LCDI_state==`LCDI_STATE4||LCDI_state==`LCDI_STATE3)
        &&row_count!=10'd0&&col_count>10'd2&&col_count!=10'd963) begin
            data_out_valid<=1'b1;
        end
        else begin
            data_out_valid<=1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_in_valid<=1'b0;
    end
    else begin
        if(LCDI_state==`LCDI_STATE6&&(row_count!=10'd540||col_count<10'd960)) begin
            data_in_valid<=1'b1;
        end
        else begin
            data_in_valid<=1'b0;
        end
    end
end


wire queue_write_enalbe;
wire [`DATA_WIDTH-1:0] queue_in_data0;
wire [`DATA_WIDTH-1:0] queue_in_data1;
wire [`DATA_WIDTH-1:0] queue_in_data2;
wire [`DATA_WIDTH-1:0] queue_in_data3;
wire [`DATA_WIDTH-1:0] queue_out_index_data0;
wire [`DATA_WIDTH-1:0] queue_out_index_data1;
wire [`DATA_WIDTH-1:0] queue_out_index_data2;

wire [`DATA_WIDTH-1:0] queue_out_inter_data0;
wire [`DATA_WIDTH-1:0] queue_out_inter_data1;
wire [`DATA_WIDTH-1:0] queue_out_inter_data2;

wire [`DATA_WIDTH-1:0] index1_data0_out;
wire [`DATA_WIDTH-1:0] index1_data1_out;
wire [`DATA_WIDTH-1:0] index1_data2_out;

wire [6:0] index1_index;

wire [6:0] index2_index0;
wire [6:0] index2_index1;
wire [6:0] index2_index2;
wire [6:0] index2_index3;

LCDI_queue LCDI_queue_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .LCDI_state(LCDI_state),

    .write_enable(queue_write_enalbe),
    .data0_in(queue_in_data0),
    .data1_in(queue_in_data1),
    .data2_in(queue_in_data2),
    .data3_in(queue_in_data3),
    .index_data0_out(queue_out_index_data0),
    .index_data1_out(queue_out_index_data1),
    .index_data2_out(queue_out_index_data2),

    .inter_data0_out(queue_out_inter_data0),
    .inter_data1_out(queue_out_inter_data1),
    .inter_data2_out(queue_out_inter_data2)
);

index1 index1_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .LCDI_state(LCDI_state),

    .data0_in(data0_in),
    .data1_in(data1_in),
    .data2_in(data2_in),
    .data0_out(index1_data0_out),
    .data1_out(index1_data1_out),
    .data2_out(index1_data2_out),
    .index(index1_index)
);

inter1 inter1_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .LCDI_state(LCDI_state),

    .index(index1_index),
    .data0_in(index1_data0_out),
    .data1_in(index1_data1_out),
    .data2_in(index1_data2_out),
    .write_enable(queue_write_enalbe),
    .data0_out(queue_in_data0),
    .data1_out(queue_in_data1),
    .data2_out(queue_in_data2),
    .data3_out(queue_in_data3)
);

index2 index2_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .LCDI_state(LCDI_state),
    
    .data0_in(queue_out_index_data0),
    .data1_in(queue_out_index_data1),
    .data2_in(queue_out_index_data2),
    .index0(index2_index0),
    .index1(index2_index1),
    .index2(index2_index2),
    .index3(index2_index3)
);

inter2 inter2_ins
(
    .clk(clk),
    .rst_n(rst_n),
    .LCDI_state(LCDI_state),

    .index0(index2_index0),
    .index1(index2_index1),
    .index2(index2_index2),
    .index3(index2_index3),
    .data0_in(queue_out_inter_data0),
    .data1_in(queue_out_inter_data1),
    .data2_in(queue_out_inter_data2),
    .data0_out(data0_out),
    .data1_out(data1_out),
    .data2_out(data2_out),
    .data3_out(data3_out)
);


endmodule

