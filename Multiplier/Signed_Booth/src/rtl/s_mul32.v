module s_mul32 (
    input clk,
    input n_rst,

    input start,
    input [31:0] src1,
    input [31:0] src2,

    output [63:0] product,
    output done
);

    //internal registers
    reg busy;
    reg busy_d;

    reg [31:0] src1_reg;
    reg [31:0] src2_reg;

    reg [31:0] acc;
    reg [31:0] q;
    reg q_0;

    reg [5:0] cycles;

    //internal flag /lines 
    wire [31:0] renew;
    wire acc_load;
    wire finish;
 
    //flag assignment
    assign finish = (cycles == 6'd31);
    assign acc_load = (q[0]) ^ (q_0);

    //output assignment
    assign product = {acc, q};
    assign done = !(busy) && (busy_d);

    //add-sub unit
    cla_32 u_cla_32(
        .src1(acc),
        .src2(src1_reg),
        .sub_flag(q[0]),
        .sum(renew),
        .carry_out()
    );
    
    //busy control
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            busy <= 1'b0;
        else if(start)
            busy <= 1'b1;
        else if(finish)
            busy <= 1'b0;
        else
            busy <= busy;
    end

    //edge detecting logic
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            busy_d <= 1'b0;
        else
            busy_d <= busy;
    end

    //FF for saving src1, src2
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst) begin
            src1_reg <= 32'h0;
            src2_reg <= 32'h0;
        end

        else if(start) begin
            src1_reg <= src1;
            src2_reg <= src2;
        end

        else if(busy) begin
            src1_reg <= src1_reg;
            src2_reg <= src2_reg;
        end

        else begin
            src1_reg <= 32'h0;
            src2_reg <= 32'h0;
        end
    end

    //signed booth logic 
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            {acc, q, q_0} <= {32'h0, 32'h0, 1'b0};

        else if(start)
            {acc, q, q_0} <= {32'h0, src2, 1'b0};

        else if(busy) begin
            {acc, q, q_0} <= (acc_load) ?
            {renew[31], renew, q} :
            {acc[31], acc, q};
        end

        else
            {acc, q, q_0} <= {acc, q, q_0};

    end

    //cycle counter
    always @(posedge clk or negedge n_rst) begin
        if(!n_rst)
            cycles <= 6'h0;
        else if(busy)
            cycles <= cycles + 6'h1;
        else
            cycles <= 6'h0;
    end
endmodule