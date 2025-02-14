`timescale 1ns / 1ps
module ROM(
    input clk,
    input clr,
    input step,
    input [1:0] sel,
    output reg done,
    output reg [7:0] inst
    );
			  
	reg [6:0] count;
	reg [6:0] limit;
	
	initial begin
	   count = 0;
	   limit = 20;
	end
	
	always @(posedge clk) begin
		if(clr) begin
                done <= 0;
                count <= 0;
            end
		else if(count > limit) begin
                done <= 1;
                count <= 0;
            end
		else if(step) begin
                done <= 0;
            end
		else done <= 0;
	end //end posedge clk

    always @(posedge step) begin
        count = count + 1'b1;
		case(sel)
            0: begin
                limit = 19;
                case(count)
                    1:  inst = 8'b00000000; // LOAD R0 0
                    2:  inst = 8'b00010001; // LOAD R1 1
                    3:  inst = 8'b00100010; // LOAD R2 2
                    4:  inst = 8'b00110011; // LOAD R3 3
                    5:  inst = 8'b00001000; // LOAD R0 8
                    6:  inst = 8'b01000000; // STORE R0
                    7:  inst = 8'b00000100; // LOAD R0 4
                    8:  inst = 8'b10010000; // MOVE R0 into R1
                    9:  inst = 8'b00010111; // LOAD R1 7
                    10: inst = 8'b00100110; // LOAD R2 6
                    11: inst = 8'b11011000; // ADD R1 R2
                    12: inst = 8'b00010111; // LOAD R1 7
                    13: inst = 8'b00100110; // LOAD R2 6
                    14: inst = 8'b11011001; // SUB R1 R2
                    15: inst = 8'b00010111; // LOAD R1 7
                    16: inst = 8'b00101001; // LOAD R2 
                    17: inst = 8'b11011010; // AND R1 R2
                    18: inst = 8'b00111010; // LOAD R3 10
                    19: inst = 8'b11110011; // NOT R3
                    default: inst = 8'b00000000;
                endcase
            end //end 0
            
			1: begin
                limit = 8;
                case(count)
                    1: inst = 8'b00110110; //load R3 6
                    2: inst = 8'b00100100; //load R2 4
                    3: inst = 8'b01110000; //store R3
                    4: inst = 8'b10011000; //move R1 R2
                    5: inst = 8'b11011100; //add R1 R3
                    6: inst = 8'b01010000; //store R1
                    7: inst = 8'b11010011; //not R1 
                    8: inst = 8'b01010000; //store R1
                    default: inst = 8'b00000000;
                endcase
            end //end 1
        
            
			2: begin
                limit = 6;
                case(count)
                    1: inst = 8'b00110101; //load R3 5
                    2: inst = 8'b00100011; //load R2 3
                    3: inst = 8'b01100000; //store R2
                    4: inst = 8'b10011000; //move R1 R2
                    5: inst = 8'b11011100; //add R1 R3
                    6: inst = 8'b01010000; //store R1
                    default: inst = 8'b00000000;
                endcase
            end //end 2
            
			3: begin
                limit = 8;
                case(count)
                    1: inst = 8'b00010001; //load R1 1
                    2: inst = 8'b00100001; //load R2 1
                    3: inst = 8'b11011000; //add R1 R2
                    4: inst = 8'b11100100; //add R2 R1
                    5: inst = 8'b11011000; //add R1 R2
                    6: inst = 8'b11100100; //add R2 R1
                    7: inst = 8'b11011000; //add R1 R2
                    8: inst = 8'b01010000; //store R1
                    default: inst = 8'b00000000;
                endcase
            end //end 3
		endcase //end ROMselect
    end
endmodule
