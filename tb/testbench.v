`timescale 1ns / 1ps

module testbench();
    reg clk;
    reg c;
    reg is;
    reg loaded;
    reg [1:0] rs;
    reg [7:0] d;
    reg [7:0] count;
    wire f;
    wire [3:0] L;
    
    top DUT (.data(d), .clk(clk), .instSel(is), .romSel(rs), .clr(c), .done(f), .LEDs(L));
    
    initial begin
        clk = 0;
        d = 0;
        is = 1; //input select //SS=0 //ROM=1
        rs = 0; //rom select 0-3
        c = 1;
        #10
        c = 0;
        count = 1;
        loaded = 0;
        
        forever #10 clk = ~clk;
    end
    
    always @(posedge clk) begin
        if (!is) begin //SS
            if (loaded) begin
                case(count)
                    1:  d = 8'b00000000; // LOAD R0 0
                    2:  d = 8'b00010001; // LOAD R1 1
                    3:  d = 8'b00100010; // LOAD R2 2
                    4:  d = 8'b00110011; // LOAD R3 3
                    5:  d = 8'b00001000; // LOAD R0 8
                    6:  d = 8'b01000000; // STORE R0
                    7:  d = 8'b00000100; // LOAD R0 4
                    8:  d = 8'b10010000; // MOVE R0 into R1
                    9:  d = 8'b00010111; // LOAD R1 7
                    10: d = 8'b00100110; // LOAD R2 6
                    11: d = 8'b11011000; // ADD R1 R2
                    12: d = 8'b00010111; // LOAD R1 7
                    13: d = 8'b00100110; // LOAD R2 6
                    14: d = 8'b11011001; // SUB R1 R2
                    15: d = 8'b00010111; // LOAD R1 7
                    16: d = 8'b00101001; // LOAD R2 
                    17: d = 8'b11011010; // AND R1 R2
                    18: d = 8'b00111010; // LOAD R3 10
                    19: d = 8'b11110011; // NOT R3
                    default: d = 8'b00000000;
                endcase
                count = count + 1;
                loaded = ~loaded;
            end else if (!loaded) begin
                loaded = ~loaded;
            end //endif loaded
        end else if (is) begin //ROM
            if (f) begin //if done
                c = 1;
                c = 0;
            end
        end //endif is
    end //posedge clk
endmodule
