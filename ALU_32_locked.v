`timescale 1ns / 1ps

//////////////////////////////////
//                              //
// ALU PROTECTED WITH 8 bit KEY //
//                              //
//////////////////////////////////

module ALU_32_locked(
           input signed [31:0] A,B,                 
           input [3:0] ALU_OP, //4 bit ALU instructions
           input [7:0] key,
           output reg signed [31:0] ALU_Out,
           output reg [31:0]APSR // NZC flag:[31:29] || other bits reserved to 0
    );
    reg carry;
    wire signed [31:0]temp_A, temp_B;
    wire [191:0]temp;
    
    reg [31:0]temp_APSR;
    
    reg [159:0]temp_out_0000,temp_out_0001,temp_out_0010,temp_out_0011,temp_out_0100,temp_out_0101,temp_out_0110,temp_out_0111,temp_out_1000,
    temp_out_1001,temp_out_1010,temp_out_1011,temp_out_1100,temp_out_1101,temp_out_1110,temp_out_1111;
    
    reg [4:0]temp_carry_0000,temp_carry_0001,temp_carry_0010,temp_carry_0011,temp_carry_0100,temp_carry_0101,temp_carry_0110,temp_carry_0111,
    temp_carry_1000,temp_carry_1001,temp_carry_1010,temp_carry_1011,temp_carry_1100,temp_carry_1101,temp_carry_1110,temp_carry_1111;

//input locking
    assign temp[31:0]=key[7]?B:A; //0
    assign temp[63:32]=key[7]?A:B;
    
    assign temp[95:64]=key[6]?temp[63:32]:temp[31:0]; //0
    assign temp[127:96]=key[6]?temp[31:0]:temp[63:32];
    
    assign temp_A=key[5]?temp[95:64]:temp[127:96]; //1
    assign temp_B=key[5]?temp[127:96]:temp[95:64];

    always @(temp_A or temp_B or ALU_OP)
    begin
        case(ALU_OP) //instruction decode

//////////////////////////////////////////////////////////////////////////////////////////
//
//   ALL KEYS ARE WITH REFERENCE TO 0011, key has been inverted in the subsequent muxes
//
////////////////KEY: 001 0011 0 /////////////////////////////////////////////////////////
        4'b0000: // Addition
           begin
           
           {temp_carry_0000[0], temp_out_0000[31:0]} = temp_A + temp_B;
           
           temp_out_0000[63:32]=key[4]?B:temp_out_0000[31:0];
           temp_out_0000[95:64]=key[3]?B:temp_out_0000[63:32];
           temp_out_0000[127:96]=key[2]?temp_out_0000[95:64]:temp_out_0000[31:0];
           temp_out_0000[159:128]=key[1]?temp_out_0000[127:96]:temp_out_0000[31:0];
           
           temp_carry_0000[1]=key[4]?key[4]:temp_carry_0000[0];
           temp_carry_0000[2]=key[3]?key[3]:temp_carry_0000[1];
           temp_carry_0000[3]=key[2]?temp_carry_0000[2]:key[2];
           temp_carry_0000[4]=key[1]?temp_carry_0000[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0000[4],temp_out_0000[159:128]};
           
           end
         
        4'b0001: // Subtraction
           begin
           
           {temp_carry_0001[0],temp_out_0001[31:0]} = temp_A - temp_B;
           
           temp_out_0001[63:32]=key[4]?B:temp_out_0001[31:0];
           temp_out_0001[95:64]=key[3]?B:temp_out_0001[63:32];
           temp_out_0001[127:96]=key[2]?temp_out_0001[95:64]:temp_out_0001[31:0];
           temp_out_0001[159:128]=key[1]?temp_out_0001[127:96]:temp_out_0001[31:0];
           
           temp_carry_0001[1]=key[4]?key[4]:temp_carry_0001[0];
           temp_carry_0001[2]=key[3]?key[3]:temp_carry_0001[1];
           temp_carry_0001[3]=key[2]?temp_carry_0001[2]:key[2];
           temp_carry_0001[4]=key[1]?temp_carry_0001[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0001[4],temp_out_0001[159:128]};
           
           end
           
        4'b0010: // Multiplication
           begin
           
           {temp_carry_0010[0],temp_out_0010[31:0]} = temp_A * temp_B;
           
           temp_out_0010[63:32]=key[4]?B:temp_out_0010[31:0];
           temp_out_0010[95:64]=key[3]?B:temp_out_0010[63:32];
           temp_out_0010[127:96]=key[2]?temp_out_0010[95:64]:temp_out_0010[31:0];
           temp_out_0010[159:128]=key[1]?temp_out_0010[127:96]:temp_out_0010[31:0];
           
           temp_carry_0010[1]=key[4]?key[4]:temp_carry_0010[0];
           temp_carry_0010[2]=key[3]?key[3]:temp_carry_0010[1];
           temp_carry_0010[3]=key[2]?temp_carry_0010[2]:key[2];
           temp_carry_0010[4]=key[1]?temp_carry_0010[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0010[4],temp_out_0010[159:128]};
           
           end
           
        4'b0011: // Division
           begin
           
           {temp_carry_0011[0],temp_out_0011[31:0]} = temp_A / temp_B;

           temp_out_0011[63:32]=key[4]?B:temp_out_0011[31:0];
           temp_out_0011[95:64]=key[3]?B:temp_out_0011[63:32];
           temp_out_0011[127:96]=key[2]?temp_out_0011[95:64]:temp_out_0011[31:0];
           temp_out_0011[159:128]=key[1]?temp_out_0011[127:96]:temp_out_0011[31:0];
           
           temp_carry_0011[1]=key[4]?key[4]:temp_carry_0011[0];
           temp_carry_0011[2]=key[3]?key[3]:temp_carry_0011[1];
           temp_carry_0011[3]=key[2]?temp_carry_0011[2]:key[2];
           temp_carry_0011[4]=key[1]?temp_carry_0011[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0011[4],temp_out_0011[159:128]};
           
           end
                     
////////////////KEY: 001 0101 0 /////////////////////
        4'b0100: // LSL
           begin
           
           {temp_carry_0100[0], temp_out_0100[31:0]} = temp_A<<1;
           
           temp_out_0100[63:32]=key[4]?B:temp_out_0100[31:0];
           temp_out_0100[95:64]=~key[3]?B:temp_out_0100[63:32];
           temp_out_0100[127:96]=~key[2]?temp_out_0100[95:64]:temp_out_0100[31:0];
           temp_out_0100[159:128]=key[1]?temp_out_0100[127:96]:temp_out_0100[31:0];
           
           temp_carry_0100[1]=key[4]?key[4]:temp_carry_0100[0];
           temp_carry_0100[2]=~key[3]?key[3]:temp_carry_0100[1];
           temp_carry_0100[3]=~key[2]?temp_carry_0100[2]:key[2];
           temp_carry_0100[4]=key[1]?temp_carry_0100[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0100[4],temp_out_0100[159:128]};
           
           end
         
        4'b0101: // LSR
           begin
           
           {temp_carry_0101[0],temp_out_0101[31:0]} = temp_A>>1;
           
           temp_out_0101[63:32]=key[4]?B:temp_out_0101[31:0];
           temp_out_0101[95:64]=~key[3]?B:temp_out_0101[63:32];
           temp_out_0101[127:96]=~key[2]?temp_out_0101[95:64]:temp_out_0101[31:0];
           temp_out_0101[159:128]=key[1]?temp_out_0101[127:96]:temp_out_0101[31:0];
           
           temp_carry_0101[1]=key[4]?key[4]:temp_carry_0101[0];
           temp_carry_0101[2]=~key[3]?key[3]:temp_carry_0101[1];
           temp_carry_0101[3]=~key[2]?temp_carry_0101[2]:key[2];
           temp_carry_0101[4]=key[1]?temp_carry_0101[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0101[4],temp_out_0101[159:128]};
           
           end
           
        4'b0110: // ROL
           begin
           
           {temp_carry_0110[0],temp_out_0110[31:0]} = {temp_A[30:0],temp_A[31]};
           
           temp_out_0110[63:32]=key[4]?B:temp_out_0110[31:0];
           temp_out_0110[95:64]=~key[3]?B:temp_out_0110[63:32];
           temp_out_0110[127:96]=~key[2]?temp_out_0110[95:64]:temp_out_0110[31:0];
           temp_out_0110[159:128]=key[1]?temp_out_0110[127:96]:temp_out_0110[31:0];
           
           temp_carry_0110[1]=key[4]?key[4]:temp_carry_0110[0];
           temp_carry_0110[2]=~key[3]?key[3]:temp_carry_0110[1];
           temp_carry_0110[3]=~key[2]?temp_carry_0110[2]:key[2];
           temp_carry_0110[4]=key[1]?temp_carry_0110[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0110[4],temp_out_0110[159:128]};
           
           end
           
        4'b0111: // ROR
           begin
           
           {temp_carry_0111[0],temp_out_0111[31:0]} = {temp_A[0],temp_A[31:1]};

           temp_out_0111[63:32]=key[4]?B:temp_out_0111[31:0];
           temp_out_0111[95:64]=~key[3]?B:temp_out_0111[63:32];
           temp_out_0111[127:96]=~key[2]?temp_out_0111[95:64]:temp_out_0111[31:0];
           temp_out_0111[159:128]=key[1]?temp_out_0111[127:96]:temp_out_0111[31:0];
           
           temp_carry_0111[1]=key[4]?key[4]:temp_carry_0111[0];
           temp_carry_0111[2]=~key[3]?key[3]:temp_carry_0111[1];
           temp_carry_0111[3]=~key[2]?temp_carry_0111[2]:key[2];
           temp_carry_0111[4]=key[1]?temp_carry_0111[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_0111[4],temp_out_0111[159:128]};
           
           end


////////////////KEY: 001 1100 0 /////////////////////
        4'b0000: // And
           begin
           
           {temp_carry_1000[0], temp_out_1000[31:0]} = temp_A & temp_B;
           
           temp_out_1000[63:32]=~key[4]?B:temp_out_1000[31:0];
           temp_out_1000[95:64]=~key[3]?B:temp_out_1000[63:32];
           temp_out_1000[127:96]=~key[2]?temp_out_1000[95:64]:temp_out_1000[31:0];
           temp_out_1000[159:128]=~key[1]?temp_out_1000[127:96]:temp_out_1000[31:0];
           
           temp_carry_1000[1]=~key[4]?key[4]:temp_carry_1000[0];
           temp_carry_1000[2]=~key[3]?key[3]:temp_carry_1000[1];
           temp_carry_1000[3]=~key[2]?temp_carry_1000[2]:key[2];
           temp_carry_1000[4]=~key[1]?temp_carry_1000[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1000[4],temp_out_1000[159:128]};
           
           end
         
        4'b0001: // Or
           begin
           
           {temp_carry_1001[0],temp_out_1001[31:0]} = temp_A | temp_B;
           
           temp_out_1001[63:32]=~key[4]?B:temp_out_1001[31:0];
           temp_out_1001[95:64]=~key[3]?B:temp_out_1001[63:32];
           temp_out_1001[127:96]=~key[2]?temp_out_1001[95:64]:temp_out_1001[31:0];
           temp_out_1001[159:128]=~key[1]?temp_out_1001[127:96]:temp_out_1001[31:0];
           
           temp_carry_1001[1]=~key[4]?key[4]:temp_carry_1001[0];
           temp_carry_1001[2]=~key[3]?key[3]:temp_carry_1001[1];
           temp_carry_1001[3]=~key[2]?temp_carry_1001[2]:key[2];
           temp_carry_1001[4]=~key[1]?temp_carry_1001[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1001[4],temp_out_1001[159:128]};
           
           end
           
        4'b0010: // XOR
           begin
           
           {temp_carry_1010[0],temp_out_1010[31:0]} = temp_A ^ temp_B;
           
           temp_out_1010[63:32]=~key[4]?B:temp_out_1010[31:0];
           temp_out_1010[95:64]=~key[3]?B:temp_out_1010[63:32];
           temp_out_1010[127:96]=~key[2]?temp_out_1010[95:64]:temp_out_1010[31:0];
           temp_out_1010[159:128]=~key[1]?temp_out_1010[127:96]:temp_out_1010[31:0];
           
           temp_carry_1010[1]=~key[4]?key[4]:temp_carry_1010[0];
           temp_carry_1010[2]=~key[3]?key[3]:temp_carry_1010[1];
           temp_carry_1010[3]=~key[2]?temp_carry_1010[2]:key[2];
           temp_carry_1010[4]=~key[1]?temp_carry_1010[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1010[4],temp_out_1010[159:128]};
           
           end
           
        4'b0011: // NOR
           begin
           
           {temp_carry_1011[0],temp_out_1011[31:0]} = ~(temp_A | temp_B);

           temp_out_1011[63:32]=~key[4]?B:temp_out_1011[31:0];
           temp_out_1011[95:64]=~key[3]?B:temp_out_1011[63:32];
           temp_out_1011[127:96]=~key[2]?temp_out_1011[95:64]:temp_out_1011[31:0];
           temp_out_1011[159:128]=~key[1]?temp_out_1011[127:96]:temp_out_1011[31:0];
           
           temp_carry_1011[1]=~key[4]?key[4]:temp_carry_1011[0];
           temp_carry_1011[2]=~key[3]?key[3]:temp_carry_1011[1];
           temp_carry_1011[3]=~key[2]?temp_carry_1011[2]:key[2];
           temp_carry_1011[4]=~key[1]?temp_carry_1011[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1011[4],temp_out_1011[159:128]};
           
           end
                     
////////////////KEY: 001 1010 0 /////////////////////
        4'b0100: // Logical NAND
           begin
           
           {temp_carry_1100[0], temp_out_1100[31:0]} = ~(temp_A & temp_B);
           
           temp_out_1100[63:32]=~key[4]?B:temp_out_1100[31:0];
           temp_out_1100[95:64]=key[3]?B:temp_out_1100[63:32];
           temp_out_1100[127:96]=key[2]?temp_out_1100[95:64]:temp_out_1100[31:0];
           temp_out_1100[159:128]=~key[1]?temp_out_1100[127:96]:temp_out_1100[31:0];
           
           temp_carry_1100[1]=~key[4]?key[4]:temp_carry_1100[0];
           temp_carry_1100[2]=key[3]?key[3]:temp_carry_1100[1];
           temp_carry_1100[3]=key[2]?temp_carry_1100[2]:key[2];
           temp_carry_1100[4]=~key[1]?temp_carry_1100[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1100[4],temp_out_1100[159:128]};
           
           end
         
        4'b0101: // Logical XNOR
           begin
           
           {temp_carry_1101[0],temp_out_1101[31:0]} = ~(temp_A ^ temp_B);
           
           temp_out_1101[63:32]=~key[4]?B:temp_out_1101[31:0];
           temp_out_1101[95:64]=key[3]?B:temp_out_1101[63:32];
           temp_out_1101[127:96]=key[2]?temp_out_1101[95:64]:temp_out_1101[31:0];
           temp_out_1101[159:128]=~key[1]?temp_out_1101[127:96]:temp_out_1101[31:0];
           
           temp_carry_1101[1]=~key[4]?key[4]:temp_carry_1101[0];
           temp_carry_1101[2]=key[3]?key[3]:temp_carry_1101[1];
           temp_carry_1101[3]=key[2]?temp_carry_1101[2]:key[2];
           temp_carry_1101[4]=~key[1]?temp_carry_1101[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1101[4],temp_out_0101[159:128]};
           
           end
           
        4'b0110: // Greater Than
           begin
           
           {temp_carry_1110[0],temp_out_1110[31:0]} = (temp_A>temp_B)?32'd1:32'd0;
           
           temp_out_1110[63:32]=~key[4]?B:temp_out_1110[31:0];
           temp_out_1110[95:64]=key[3]?B:temp_out_1110[63:32];
           temp_out_1110[127:96]=key[2]?temp_out_1110[95:64]:temp_out_1110[31:0];
           temp_out_1110[159:128]=~key[1]?temp_out_1110[127:96]:temp_out_1110[31:0];
          
           temp_carry_1110[1]=~key[4]?key[4]:temp_carry_1110[0];
           temp_carry_1110[2]=key[3]?key[3]:temp_carry_1110[1];
           temp_carry_1110[3]=key[2]?temp_carry_1110[2]:key[2];
           temp_carry_1110[4]=~key[1]?temp_carry_1110[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1110[4],temp_out_1110[159:128]};
           
           end
           
        4'b0111: // Equal TO
           begin
           
           {temp_carry_1111[0],temp_out_1111[31:0]} = (temp_A==temp_B)?32'd1:32'd0;

           temp_out_1111[63:32]=~key[4]?B:temp_out_1111[31:0];
           temp_out_1111[95:64]=key[3]?B:temp_out_1111[63:32];
           temp_out_1111[127:96]=key[2]?temp_out_1111[95:64]:temp_out_1111[31:0];
           temp_out_1111[159:128]=~key[1]?temp_out_1111[127:96]:temp_out_1111[31:0];
           
           temp_carry_1111[1]=~key[4]?key[4]:temp_carry_1111[0];
           temp_carry_1111[2]=key[3]?key[3]:temp_carry_1111[1];
           temp_carry_1111[3]=key[2]?temp_carry_1111[2]:key[2];
           temp_carry_1111[4]=~key[1]?temp_carry_1111[3]:key[1];
           
           {carry,ALU_Out} = {temp_carry_1111[4],temp_out_1111[159:128]};
           
           end
          default:
            {carry,ALU_Out} = 33'b0 ;         
        endcase
    end
    
    
    always@(ALU_Out|carry)
        begin
        if(ALU_Out<0)
            temp_APSR[31] = 1;  //Negative Flag
        else
            temp_APSR[31] = 0;
        if(ALU_Out==0)
            temp_APSR[30] = 1;  //Zero Flag
        else
            temp_APSR[30] = 0;
        temp_APSR[29] = carry;  //Carry Flag
        temp_APSR[28:0]=29'b0;
        
        APSR=key[0]?temp_APSR[31:0] | 32'hc000:temp_APSR[31:0]; //0
     end
endmodule