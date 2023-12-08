package testbench;

	import Real :: * ;
	import types :: *;
	import FIFO :: *;
	import Vector :: *;
	import exponential :: *;

	module mkTest(Empty);
	
		Ifc_exp  test_int <- mkExponent() ;
		Reg#(UInt#(32)) cycles <- mkReg(0) ;
		
		// Reg#(Cfloat_152) expx <- mkReg(cfloat_def) ;
		// Reg#(Cfloat_152) debug <- mkReg(cfloat_def) ;

		Reg#(Bit#(1)) expx_s <- mkReg(0) ;
		Reg#(Bit#(2)) expx_m <- mkReg(0) ;
		Reg#(UInt#(5)) expx_e <- mkReg(0) ;
		
		// (* descending_urgency = "every_cycle, test_int_one_cycle" *)
		// (* conflict_free = "every_cycle, test_int_one_cycle" *)
		rule every_cycle;
			$display("*****************************************",cycles);

			cycles <= cycles + 1 ;
			test_int.one_cycle() ;

			if(cycles==1)
				test_int.set_bias(7);

			if(cycles==3)
				begin
					Cfloat_152 inp;
					inp.sign = 1'b0 ;
					inp.mant = 2'b10 ;
					inp.exp = 9 ;

					test_int.set_inp(inp) ;
					cfloat_read(inp,7);
				end
				
			if(cycles==5)
				begin
					Cfloat_152 temp = test_int.debug_read() ;
					$display("Debug") ;

					Real mant=0;
					Real expon=0;
					// Real final_=0;
					Int#(7) final_exp = signExtend(unpack(pack(temp.exp))) - 7 ;
					Integer final_exp_int = int7_to_integer(final_exp);
					Real final_exp_real = fromInteger(final_exp_int);

					if(temp.exp==0)
						begin
							if(temp.mant==2'b00) 	mant = 0;
							else if(temp.mant==2'b01)	mant = 0.25;
							else if(temp.mant==2'b10)	mant = 0.50;
							else if(temp.mant==2'b11)	mant = 0.75;

							expon	= pow(2,final_exp_real) ;
						end
					else
						begin
							if(temp.mant==2'b00) 	mant = 1;
							else if(temp.mant==2'b01)	mant = 1.25;
							else if(temp.mant==2'b10)	mant = 1.50;
							else if(temp.mant==2'b11)	mant = 1.75;
							
							expon	= pow(2,final_exp_real) ;
						end
					if(temp.sign==1'b0) 
						$display("+%5.5f  * ",mant);
					else
						$display("-%5.5f  * ",mant);
					// if(temp.sign==1'b0) 
					// 	$display("+%5.5f",expon);
					// else
					// 	$display("+%5.5f",expon);
				end

			if(cycles>=36 && cycles<=40)
				begin
					Cfloat_152 temp = test_int.read_exp_1() ;
					$display("EXP_X - 1") ;
					Real mant=0;
					Real expon=0;
					// Real final_=0;
					Int#(7) final_exp = signExtend(unpack(pack(temp.exp))) - 7 ;
					Integer final_exp_int = int7_to_integer(final_exp);
					Real final_exp_real = fromInteger(final_exp_int);

					if(temp.exp==0)
						begin
							if(temp.mant==2'b00) 	mant = 0;
							else if(temp.mant==2'b01)	mant = 0.25;
							else if(temp.mant==2'b10)	mant = 0.50;
							else if(temp.mant==2'b11)	mant = 0.75;

							expon	= pow(2,final_exp_real) ;
						end
					else
						begin
							if(temp.mant==2'b00) 	mant = 1;
							else if(temp.mant==2'b01)	mant = 1.25;
							else if(temp.mant==2'b10)	mant = 1.50;
							else if(temp.mant==2'b11)	mant = 1.75;
							
							expon	= pow(2,final_exp_real) ;
						end
					// final_ = mant*expon;
					if(temp.sign==1'b0) 
						$display("+%5.5f  * +%5.5f",mant,expon);
					else
						$display("-%5.5f  * +%5.5f",mant,expon);
				end

			if(cycles==40)$finish(0);
		endrule  
		
	endmodule

endpackage : testbench



					// Real mant=0;
					// Real expon=0;
					// // Real final_=0;
					// Int#(7) final_exp = signExtend(unpack(pack(temp.exp))) - 7 ;
					// Integer final_exp_int = int7_to_integer(final_exp);
					// Real final_exp_real = fromInteger(final_exp_int);

					// if(temp.exp==0)
					// 	begin
					// 		if(temp.mant==2'b00) 	mant = 0;
					// 		else if(temp.mant==2'b01)	mant = 0.25;
					// 		else if(temp.mant==2'b10)	mant = 0.50;
					// 		else if(temp.mant==2'b11)	mant = 0.75;

					// 		expon	= pow(2,final_exp_real) ;
					// 	end
					// else
					// 	begin
					// 		if(temp.mant==2'b00) 	mant = 1;
					// 		else if(temp.mant==2'b01)	mant = 1.25;
					// 		else if(temp.mant==2'b10)	mant = 1.50;
					// 		else if(temp.mant==2'b11)	mant = 1.75;
							
					// 		expon	= pow(2,final_exp_real) ;
					// 	end
					// // final_ = mant*expon;
					// if(temp.sign==1'b0) 
					// 	$display("+%5.5f  * +%5.5f",mant,expon);
					// else
					// 	$display("-%5.5f  * +%5.5f",mant,expon);