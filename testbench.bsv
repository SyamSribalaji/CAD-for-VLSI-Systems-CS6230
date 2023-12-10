package testbench;


	import Real :: * ;
	import types :: *;
	import FIFO :: *;
	import Vector :: *;
	// import exponential :: *;
	import functions :: *;
	// import leaky_relu :: *;
	import condensed :: *;


	// module mkTestExp(Empty);
	// 	Ifc_exp dut <- mkExponent();
	// 	Reg#(UInt#(32)) cycles <- mkReg(0) ;



	// 	rule every_cycle_tb;
	// 		cycles <= cycles + 1;


	// 		if (cycles==0)
	// 			begin
	// 				// $display("Writing from TestBench_Exp-1 @",$time);
	// 				$display("************************************************************************");
	// 			end
	// 		if(cycles==3)
	// 			begin
	// 				dut.set_bias(7);
	// 				$display("Bias set @",$time);
	// 			end
	// 		if(cycles==5)
	// 			begin
	// 				Cfloat_152 inp;
	// 				inp.sign = 1'b0 ;
	// 				inp.mant = 2'b10 ;
	// 				inp.exp = 9 ;

	// 				dut.set_inp(inp) ;
	// 				$display("Input  6 set @",$time);
	// 			end

	// 		if(cycles==6)
	// 			begin
	// 				Cfloat_ret temp;
	// 				temp = dut.read_exp_1();
	// 				cfloat_read(temp.val,7);
	// 				// $display("Read from Dut @",$time);
	// 			end
	// 		if(cycles==100)
	// 			$display("DONE @",$time);
	// 		if(cycles==100)
	// 			$finish(0);
			
	// 	endrule
		
	
	// endmodule



	// (* conflict_free = "every_cycle_tb, dut_fill_exp_" *)	
	module mkTestCON(Empty);
		Ifc_cond dut <- mkCondensed();
		Reg#(UInt#(32)) cycles <- mkReg(0) ;



		rule every_cycle_tb_wr;
			cycles <= cycles + 1;


			
			$display("************************************************************************",cycles);
			
			if(cycles==2)
				begin
					dut.set_mode(2);
					$display($time,":Mode set");
				end	
			if(cycles==3)
				begin
					dut.set_bias(11);
					$display($time,":Bias set");
				end
			if(cycles==5)
				begin
					Cfloat_152 inp;
					inp.sign = 1'b0 ;
					inp.mant = 2'b01 ;
					inp.exp = 00 ;

					dut.set_inp(inp) ;
					$display($time,":Input   set");
				end
			if(cycles==6)
				begin
					Cfloat_152 inp;
					inp.sign = 1'b1 ;
					inp.mant = 2'b00 ;
					inp.exp = 20 ;

					dut.set_inp(inp) ;
					$display($time,":Input   set");
				end
			if(cycles==40)
				begin
					$display($time,":DONE");
					$finish(0);
				end
			
		endrule
		rule every_cycle_tb_rd;

			if(cycles==9 || cycles==8)
				begin
					Cfloat_ret temp;
					temp = dut.read_out();
					$display($time,":Reading  Output");
					cfloat_read(temp.val,11);
				end
			
		endrule
	
	endmodule
endpackage : testbench