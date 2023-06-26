module div32(
    input clk,
    input n_rst,

    input start,
    input [31:0] src1,
    input [31:0] src2,

    output [31:0] qut,
    output [31:0] rmd,
    output done
);

    //internal registers
    reg busy;
    reg busy_d;
    reg [5:0] cycles;
    reg [31:0] src1_reg;
    reg [31:0] src2_reg;

    reg [32:0] acc;
    reg [32:0] shift_acc;
    reg [31:0] q;
    reg [31:0] shift_q;
    
    //internal flags
    wire [32:0] new;
    wire restore_acc;
    wire finish;

    wire q_lsb;

    //flag assignment
    assign restore_acc = new[32];
    assign q_lsb = !(restore_acc);
    assign finish = (cycles == 6'h0);

    //output assignment
    assign qut = q;
    assign rmd = acc;
    assign done = (!busy) && (busy_d);

    //adder unit
    cla_33 u_cla_33(
        .src1(shift_acc),
        .src2({1'b0, src2_reg}),
        .sub_flag(1'b1),
        .sum(new),
        .carry_out()
    );

    //busy logic
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

    //ff for edge-detecting
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            busy_d <= 1'b0;
        else
            busy_d <= busy;
    end

    //src1, src2 saving ff
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

    //cycle counter
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            cycles <= 6'h0;
        else if(start)
            cycles <= 6'd31;
        else if(busy)
            cycles <= cycles - 6'h1;
        else
            cycles <= cycles;
    end

    //shift logic
    always @(*)begin
        if(busy)
            {shift_acc, shift_q} <= {acc, q} << 1;
        else
            {shift_acc, shift_q} <= {33'h0, 32'h0};
    end

    //restoring division logic
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            {acc, q} <= {32'h0, 32'h0};
        else if(start)
            {acc, q} <= {32'h0, src1};
        else if(busy) begin
            {acc, q} <= (restore_acc) ?
                {shift_acc, q[30:0], q_lsb} :
                {new, q[30:0], q_lsb};
        end

        else
            {acc, q} <= {acc, q};
    end

endmodule