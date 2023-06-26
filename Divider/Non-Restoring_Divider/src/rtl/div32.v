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
    //busy register
    reg busy;
    reg busy_d;

    //cycle counter
    reg [5:0] cycles;

    //operation FF
    reg [31:0] m;
    reg [32:0] acc;
    reg [32:0] shift_acc;
    reg [31:0] q;
    reg [31:0] shift_q;

    //accumulation source in add unit
    reg [32:0] target_acc;

    //internal lines / signals
    wire [32:0] new_acc;
    wire adder_action;
    wire q_lsb;
    wire last;

    //flag assignment
    assign adder_action = (acc[32] == 1'b0); // if 0 --> SUB, if 1 --> SUB
    assign q_lsb = !(new_acc[32]);
    assign last = (cycles == 6'd32);
    
    //output assignment
    assign qut = q;
    assign rmd = acc[31:0];
    assign done = (!busy) && (busy_d);

    //add unit
    cla_33 adder(
        .src1 (target_acc),
        .src2 ({1'b0, m}),
        .sub_flag (adder_action),
        .sum (new_acc),
        .carry_out ()
    );

    //busy logic
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            busy <= 1'b0;
        else if(start)
            busy <= 1'b1;
        else if(last)
            busy <= 1'b0;
        else
            busy <= busy;
    end

    //busy FF for edge-detecting
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            busy_d <= 1'b0;
        else
            busy_d <= busy;
    end

    //cycle counter
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            cycles <= 6'h0;
        else if(busy)
            cycles <= cycles + 6'h1;
        else
            cycles <= 6'h0;
    end

    //src2 saving FF
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            m <= 32'h0;
        else if(start)
            m <= src2;
        else if(busy)
            m <= m;
        else
            m <= 32'h0;
    end

    //acc select unit
    always @(*)begin
        if(last)
            target_acc = acc;
        else
            target_acc = shift_acc;
    end

    //A,Q shift unit
    always @(*)begin
        if(busy)
            {shift_acc, shift_q} <= {acc, q} << 1;
        else
            {shift_acc, shift_q} <= {33'h0, 32'h0};
    end

    //Non-Restoring Division algorithm
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)
            {acc, q} <= {33'h0, 32'h0};

        else if(start)
            {acc, q} <= {33'h0, src1};

        else if(last) begin
            {acc, q} <= (acc[32]) ? 
                {new_acc,q} : 
                {acc, q};
        end

        else if(busy)
            {acc, q} <= {new_acc, shift_q[31:1], q_lsb};

        else
            {acc, q} <= {acc, q};
    end

endmodule