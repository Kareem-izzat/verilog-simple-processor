module alu (opcode, a, b, result );	  
input signed [5:0] opcode; 
input signed [31:0] a, b; 
output reg signed  [31:0] result;	

always @(*)
	case(opcode)   
		// op codes will be based on the last digit of my id which is 6 
		6'b000100: result=a+b;
		6'b001010: result=a-b;
		6'b000011: if(a<0) result= -a; else result = a;	  // to get absolute value if input less than 0 we will make it positve by puting a negative sign before it
		6'b001100: result=-a;
		6'b000111: if(a>b) result =a ;else result=b;
		6'b000010: if(a<b) result =a ;else result=b;
		6'b000110: result=(a+b)>>1;	// the right shift will divide by 2 which will divide t=by 2 ti get the average 
		6'b001101: result=~a;
		6'b001110: result= a|b;
		6'b001011: result = a &b;
		6'b001000: result= a ^ b;	 
	
	endcase

endmodule	 




module reg_file (clk,valid_opcode, addr1, addr2, addr3, in , out1, out2);
input clk;
input valid_opcode;
input [4:0] addr1, addr2, addr3; 
input signed [31:0] in; 
output reg signed [31:0] out1, out2;  
reg [31:0] memory [31:0];	  
initial 
	begin	 	/// initializing memory based on my second to last number in my id which is 5
		memory[0]=0;
		memory[1] =11930;
		memory[2] =5348;
		memory[3] =7308;
		memory[4] =15684;
		memory[5] =12346;
		memory[6] =9716;
		memory[7] =7820;
		memory[8] =5190;
		memory[9] =14702;
		memory[10] =5630;
		memory[11] =2352;
		memory[12] =15424;
		memory[13] =2670;
		memory[14] =4172;
		memory[15] =4300;
		memory[16] =4744;
		memory[17] =1286;
		memory[18] =8122;
		memory[19] =4558;
		memory[20] =8534;
		memory[21] =13340;
		memory[22] =6918;
		memory[23] =11700;
		memory[24] =10722; 
		memory[25] =3346;
		memory[26] =3300;
		memory[27] =2386;
		memory[28] =11212;
		memory[29] =3504;
		memory[30] =8712;
		memory[31] =0;
	end		

	
always @(posedge clk)
	begin	
		if(valid_opcode) // work as enable 
			begin
			out1 <= memory[addr1];
  			out2 <= memory[addr2];
    			memory[addr3] <= in;
			end
	end
endmodule  	


module Buffer (
  input wire [5:0] in,
  input wire clk,
  output wire [5:0] out
);

  reg [5:0] buffer_out;

  always @(posedge clk) begin
    buffer_out <= in;
  end

  assign out = buffer_out;

endmodule	  
	
module rTest;	   
reg clk,valid;
reg [4:0] addr1, addr2, addr3;   
reg  [31:0] in; 
wire [31:0] out1, out2; 	 

reg_file testReg(clk,valid,addr1,addr2,addr3,in,out1,out2);
initial
	begin 						   	 
	$display("Time   clk   valid   addr1		addr2	addr3	in	out1		out2");
	$monitor("%0t	    %d     %d     %d	      %d	       %d       %d	  %d	      %d	", $time,clk,valid,addr1,addr2,addr3,in , out1,out2);
	// this will be a very basic test bench that will check if the saving is right and if there are colision or not	 
    addr1 = 2; addr2 = 1; addr3 = 2; in = 99; clk = 0; valid = 0; 
	#20 valid =1;
	#40	addr3=5;

  
    #80 $finish;

	end	   	 
	always #10 clk=~clk;

	
endmodule

module mp_top (clk, instruction , result );
input clk;
input [31:0] instruction; 
output  reg signed [31:0] result;		

 wire [4:0]addr1,addr2,addr3;
 wire [5:0]opcode;	
 reg valid=0;	// will work as an enable bit for register	
 wire [32:0]out1,out2;
 assign opcode=instruction[5:0];	// dividing the instruction based on bits to opcode and the used adresess
 assign addr1=instruction[10:6];
 assign addr2=instruction[15:11];
 assign addr3=instruction[20:16];	
 wire [5:0]opcode_alu;
 

reg [5:0] opcode_array [10:0];
initial
	begin		   // initialising valid opcodes in an array so we can check incoming ones
		opcode_array[0]=4;
		opcode_array[1]=10;
		opcode_array[2]=3;
		opcode_array[3]=12;
		opcode_array[4]=7;
		opcode_array[5]=2;
		opcode_array[6]=6;
		opcode_array[7]=13;
		opcode_array[8]=14;
		opcode_array[9]=11;
		opcode_array[10]=8;
	end	   
	int  i;	  		
	always@(opcode)		// this loop will check if entered opcode is one of the valid ones 
		begin
			for(int i=0;i<11;i=i+1)	 
			begin 
			if(opcode==opcode_array[i]) 
				valid=1;
			end	  
	    end	 
	reg_file register(clk,valid,addr1,addr2,addr3,result,out1,out2);	 
  
	Buffer bf(opcode,clk,opcode_alu);	// opcode will go into a buffer to prevent worng output 
	alu ALU(opcode_alu,out1,out2,result) ;  
	
	
	
endmodule 

module TestMp;  
  reg clk;
  reg [31:0] instruction;
  wire [31:0] result;
  reg [31:0] instructions [12:0];   // arrays of used instruction to test
  reg [31:0] expected_answers[12:0];  //excpected outputs
  reg valid;
  reg [3:0] counter; 	// this counter is essintial to the checking of validation because we only want to test the output when it is stable 
  reg [31:0] answer;
  // becuae my code use 2 clock cycle the output will not change immeadiatly
  mp_top Processor(clk, instruction, result);		  // the instance we want to test 
	
  initial
    begin 			  
		// initialising instructions
      instructions[0] = 32'h000d5004;
      instructions[1] = 32'h000e484a;
      instructions[2] = 32'h000f4083;
      instructions[3] = 32'h001038cc;
      instructions[4] = 32'h00113107;
      instructions[5] = 32'h00122942;
      instructions[6] = 32'h00132186;
      instructions[7] = 32'h001419cd;
      instructions[8] = 32'h0015120e;
      instructions[9] = 32'h00160a4b;
      instructions[10] = 32'h00170288; // this instructions is invalid 
	  instructions[11] = 0;	
	  instructions[12]= 32'h00011044;	 // this instruction to check if there are no overlab between reading and writing
      expected_answers[0] = 5630; 
      expected_answers[1] = 4294964524;
      expected_answers[2] = 5348;
      expected_answers[3] = 4294959988;
      expected_answers[4] = 15684;
      expected_answers[5] = 12346;
      expected_answers[6] = 12700;
      expected_answers[7] = 4294959475;
      expected_answers[8] = 5350;
      expected_answers[9] = 10250;
      expected_answers[10] = 5630;
	  expected_answers[11] = 5630;	 
	  expected_answers[12] = 17278;
      clk = 0;
      valid = 1;
     
      counter = 0; 
	   instruction = instructions[0];
      $display("Time   clk    instruction      result	excpected results"); 
    

      for (int i = 0; i < 13; i = i + 1)  // this loop will iterate over instructions
        begin		
		  
          #10ns clk = ~clk;
          instruction = instructions[i]; 
		  answer= expected_answers[i] ;
          #10ns clk = ~clk;
          #10ns;  
		
			$monitor("%0t   %b    %h      %d	%d", $time, clk, instruction, result,answer);
          // Check validity every two clock cycles	 
          if (counter == 1) 
            begin
              if (result != expected_answers[i]) // if wrong output the test will fail
                valid = 0;			  
			
            end
          
          counter = counter + 1;
          if (counter == 2)
            counter = 0;	   
        end   

      if (valid)		 // after ending the test cases we check if it was a succesfull run
        $display("PASS");
      else
        $display("FAIL");
    
      $finish;
    end
endmodule
