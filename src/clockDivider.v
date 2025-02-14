`timescale 1 ns/1 ns

module clockDivider #(parameter PRESCALER = 25_000_000)(
    input clkin,
    output reg clkout
    );
    
    reg [24:0] count;
    
    initial begin
        count = 0;
        clkout = 0;
    end

    always @(posedge clkin) begin
        if (count == PRESCALER) begin
            count <= 0;
            clkout <= ~clkout;
        end
        else begin
            count <= count + 1;
        end
    end
    
endmodule