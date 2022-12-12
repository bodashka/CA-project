module gameSV ( input hit,
	input check,
	input clk,
	input test,
	output reg flash,
	output reg [7:0] display [0:5]);


	bit [3:0] crh;
	//bit [3:0] crh_values [20];
	bit [5:0] target;
	reg lastop = 0, frc = 0, neg = 0;
	integer score, i, cnt, test_count;
	integer t0=0, t1=0, t2=0, t3=0, t4=0, t5=0;
	reg [24:0] basepp;
	reg [24:0] basep;
	reg [24:0] base;
	reg [24:0] baset; //2 modifications by different modules (idk)
	
	reg [7:0] codes [0:9];
	reg [7:0] none;
	reg [7:0] enemy;
	reg [7:0] minus;
	
	reg upd = 0;
	initial begin
		
		codes[0] <= 8'b11000000;
		codes[1] <= 8'b11111001;
		codes[2] <= 8'b10100100;
		codes[3] <= 8'b10110000;
		codes[4] <= 8'b10011001;
		codes[5] <= 8'b10010010;
		codes[6] <= 8'b10000010;
		codes[7] <= 8'b11111000;
		codes[8] <= 8'b10000000;
		codes[9] <= 8'b10010000;
		
		/*crh_values[0] <= 0;
		crh_values[1] <= 4;
		crh_values[2] <= 5;
		crh_values[3] <= 2;
		crh_values[4] <= 4;
		crh_values[5] <= 5;
		crh_values[6] <= 1;
		crh_values[7] <= 3;
		crh_values[8] <= 3;
		crh_values[9] <= 3;
		crh_values[10] <= 1;
		crh_values[11] <= 2;
		crh_values[12] <= 1;
		crh_values[13] <= 0;
		crh_values[14] <= 2;
		crh_values[15] <= 4;
		crh_values[16] <= 0;
		crh_values[17] <= 5;
		crh_values[18] <= 0;
		crh_values[19] <= 3;
		crh_values[20] <= 0;*/
		/*codes[0] <= 8'b11111111; //0
		codes[1] <= 8'b11111111; //1
		codes[2] <= 8'b01111111; //2
		codes[3] <= 8'b00111111; //3
		codes[4] <= 8'b01011111; //4
		codes[5] <= 8'b01101111; //5
		codes[6] <= 8'b01110111; //6
		codes[7] <= 8'b01111011; //7
		codes[8] <= 8'b01111101; //8
		codes[9] <= 8'b01111110; //9*/
		
		none <= 8'b11110111;
		enemy <= 8'b11110001;
		minus <= 8'b10111111;
		base <= 25'b100100100100101010010100;
		basep <= 25'b100100100100101010010100;
		basepp <= 25'b100100100100101010010101;
		
		crh <= 0;
		target <= 0;
		flash <= 0;
		test_count <= 0;
		cnt <= 0;
	end
	
	update m0 (.clk(clk), .upd(upd), .hit(hit), .base(baset));
	
	always @ (posedge upd) begin
		flash <= ~flash;
		if (test == 0) begin
			if (check == 1) begin // game in progress branch
				if (lastop == 1) begin //change the score only if the last operation was game
					if ((target[crh] == 1 && hit == 0) || (target[crh] == 0 && hit == 1)) begin
						if (neg == 1) begin
							score <= score + 1;
						end else begin
							if (score == 0) begin
								neg <= 1;
								score <= 1;
							end else begin
								score <= score - 1;
							end
						end
					end else begin
						if (neg == 1) begin
							if (score == 1) begin
								neg <= 0;
								score <= 0;
							end else begin
								score <= score - 1;
							end
						end else begin
							score <= score + 1;
						end
					end
				end
				
				//randomize
				base <= baset;
				if (base == basep) begin
					base <= basep + basepp;
				end
				target <= base%32;
				crh <= base%6;
				frc <= ~frc;
				
				basepp <= basep;
				basep <= base;
				
				if (target[0] == 1) begin
					display[0] <= enemy;
				end else begin 
					display[0] <= none;
				end
				if (target[1] == 1) begin
					display[1] <= enemy;
				end else begin 
					display[1] <= none;
				end
				if (target[2] == 1) begin
					display[2] <= enemy;
				end else begin 
					display[2] <= none;
				end
				if (target[3] == 1) begin
					display[3] <= enemy;
				end else begin 
					display[3] <= none;
				end
				if (target[4] == 1) begin
					display[4] <= enemy;
				end else begin 
					display[4] <= none;
				end
				if (target[5] == 1) begin
					display[5] <= enemy;
				end else begin 
					display[5] <= none;
				end
				
				display[crh][7] <= 0;
			end else begin // game score check branch
				if (neg == 1) begin
					display[5] <= minus;
				end else begin
					display[5] <= 8'b11111111;
				end
				t0 = score%10;
				t1 = (score/10)%10;
				t2 = (score/100)%10;
				t3 = (score/1000)%10;
				t4 = (score/10000)%10;
				display[0] <= codes[t0];
				display[1] <= codes[t1]; 
				display[2] <= codes[t2];
				display[3] <= codes[t3];
				display[4] <= codes[t4];
			end
			lastop <= check;
		end else begin
			/*if (t0 == 9) begin
			  t0 <= 0;
			  t1 <= t1 + 1;
			end else begin
				t0 <= t0+1;
			end
			if (t1 == 10) begin
				t1 <= 0;
				t2 <= t2+1;
			end
			if (t2 == 10) begin
				t2 <= 0;
				t3 <= t3+1;
			end
			if (t3 == 10) begin
				t3 <= 0;
				t4 <= t4+1;
			end
			if (t4 == 10) begin
				t4 <= 0;
			end*/
			if (test_count == 99999) begin
			  test_count <= 0;
			end else begin
			  test_count <= test_count + 1;
			end
			t0 = test_count%10;
			t1 = (test_count/10)%10;
			t2 = (test_count/100)%10;
			t3 = (test_count/1000)%10;
			t4 = (test_count/10000)%10;
			display[0] <= codes[t0];
			display[1] <= codes[t1]; 
			display[2] <= codes[t2];
			display[3] <= codes[t3];
			display[4] <= codes[t4];
		end
	end
	
endmodule