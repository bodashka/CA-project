module update 
  # (parameter N = 25000000,
     parameter WIDTH = 25)
  
  ( input   clk,
		input hit,
   	output reg upd,
		output reg [24:0] base);
	reg [WIDTH-1:0] count;
	reg hitprev = 0;
	always @ (posedge clk) begin
      if (count == N-1) begin
        count <= 0;
		  upd = ~upd;
      end else begin
        count <= count + 1;
		end
		if (hit != hitprev) begin
			base <= count;
		end
		hitprev <= hit;
  end
endmodule