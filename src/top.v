`timescale 1ns / 1ps

module top(
    input clk,              //sys clk
    input clr,              //clr ROM
    input instSel,          //select SS=0 or ROM=1
    input [1:0] romSel,     //select ROM inst set
    input [7:0] data,       //inst switches
    output done,            //output when ROM is done w/ inst set
    output reg [3:0] LEDs   //output LEDs
    );
    
    reg step;               //control fetch, decode, execute states //ROM
    reg loaded;             //control fetch, decode, execute states //SS
    reg [1:0] STDstate;     //decide std op
    reg [1:0] ALUstate;     //decide ALU op
    reg [1:0] x;            //binary index for Rx
    reg [1:0] y;            //binary index for Ry
    wire [7:0] ROMoutput;   //inst from ROM
    integer i1;             //index for Rx
    integer i2;             //index for Ry
   
    reg [3:0] r [3:0];      //4 wide array of 4bit reg
    reg [7:0] inst;         //instruction
    
    ROM U2 (.clk(clk), .clr(clr), .step(step), .sel(romSel), .done(done), .inst(ROMoutput));
    
    initial begin
        loaded = 0;
        step = 0;
    end
        
    always @(posedge clk) begin
        //fetch------------------------------------------------------------------------
        if (!loaded) begin
            case (instSel) //input sel
                1'b0: inst <= data; //SS
                1'b1: inst <= ROMoutput; //ROM
            endcase
        //--decode----------------------------------------------------------------------
            STDstate <= inst[7:6]; //std op
            x        <= inst[5:4]; //first reg
            y        <= inst[3:2]; //second reg
            ALUstate <= inst[1:0]; //ALU op
            #10
            
            //create decimal indexices from binary inst
            case(x)
                2'b00: i1 <= 0;
                2'b01: i1 <= 1;
                2'b10: i1 <= 2;
                2'b11: i1 <= 3;
            endcase
            case(y)
                2'b00: i2 <= 0;
                2'b01: i2 <= 1;
                2'b10: i2 <= 2;
                2'b11: i2 <= 3;
            endcase
            
            loaded = ~loaded;
            step = 0;
        //execute------------------------------------------------------------------------
        end else if (loaded) begin
            case (STDstate)
                2'b00: r[i1] <= {y, ALUstate}; //load
                2'b01: LEDs <= r[i1];          //store
                2'b10: r[i1] <= r[i2];          //move
                2'b11: begin //ALU
                    case (ALUstate)
                        2'b00: r[i1] <= r[i1] + r[i2]; //add
                        2'b01: r[i1] <= r[i1] - r[i2]; //sub
                        2'b10: r[i1] <= r[i1] & r[i2]; //and
                        2'b11: r[i1] <= ~r[i1];        //not
                    endcase
                end //end ALU operations
            endcase //end operations
            loaded = ~loaded;
            step = 1;
        end //endif loaded
    end //end @posedge clk
endmodule
