`timescale 1ns / 1ps

module ALU_32_locked_tb;
//Inputs
 reg signed [31:0] A,B;
 reg [3:0] ALU_OP;
 reg [7:0]key;
//Outputs
 wire[31:0] ALU_Out, APSR;
 
  ALU_32_locked test_unit(
            A,B,                 
            ALU_OP,
            key,
            ALU_Out,
            APSR
     );
    initial
    begin
      A = 32'h0A;
      B = 32'h02;
      key=8'b00100110;  //right
      ALU_OP = 4'b0000;
      #10 ALU_OP = 4'b0001;
      #10 ALU_OP = 4'b0010;
      #10 ALU_OP = 4'b0011;
      #10;
      key=8'b00000110;   //wrong
      ALU_OP = 4'b0000;
      #10 ALU_OP = 4'b0001;
      #10 ALU_OP = 4'b0010;
      #10 ALU_OP = 4'b0011;
      #10;
      A = 32'h21;
      B = 32'h05;
      key=8'b00100110;  //right
      ALU_OP = 4'b0000;
      #10 ALU_OP = 4'b0001;
      #10 ALU_OP = 4'b0010;
      #10 ALU_OP = 4'b0011;
      #10;
      key=8'b00000110;   //wrong
      ALU_OP = 4'b0000;
      #10 ALU_OP = 4'b0001;
      #10 ALU_OP = 4'b0010;
      #10 ALU_OP = 4'b0011;
     
      $finish;
    end
endmodule
