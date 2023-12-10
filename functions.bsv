package functions;

	import Real :: * ;
	import types :: *;
	import FIFO :: *;
	import Vector :: *;


	// NO INBUILT FN FOR THIS CONVERSION
	function Integer int7_to_integer(Int#(7) inp);		 
		Integer val=0;
		if (inp == -64) val = -64;
		else if (inp == -63) val = -63;
		else if (inp == -62) val = -62;
		else if (inp == -61) val = -61;
		else if (inp == -60) val = -60;
		else if (inp == -59) val = -59;
		else if (inp == -58) val = -58;
		else if (inp == -57) val = -57;
		else if (inp == -56) val = -56;
		else if (inp == -55) val = -55;
		else if (inp == -54) val = -54;
		else if (inp == -53) val = -53;
		else if (inp == -52) val = -52;
		else if (inp == -51) val = -51;
		else if (inp == -50) val = -50;
		else if (inp == -49) val = -49;
		else if (inp == -48) val = -48;
		else if (inp == -47) val = -47;
		else if (inp == -46) val = -46;
		else if (inp == -45) val = -45;
		else if (inp == -44) val = -44;
		else if (inp == -43) val = -43;
		else if (inp == -42) val = -42;
		else if (inp == -41) val = -41;
		else if (inp == -40) val = -40;
		else if (inp == -39) val = -39;
		else if (inp == -38) val = -38;
		else if (inp == -37) val = -37;
		else if (inp == -36) val = -36;
		else if (inp == -35) val = -35;
		else if (inp == -34) val = -34;
		else if (inp == -33) val = -33;
		else if (inp == -32) val = -32;
		else if (inp == -31) val = -31;
		else if (inp == -30) val = -30;
		else if (inp == -29) val = -29;
		else if (inp == -28) val = -28;
		else if (inp == -27) val = -27;
		else if (inp == -26) val = -26;
		else if (inp == -25) val = -25;
		else if (inp == -24) val = -24;
		else if (inp == -23) val = -23;
		else if (inp == -22) val = -22;
		else if (inp == -21) val = -21;
		else if (inp == -20) val = -20;
		else if (inp == -19) val = -19;
		else if (inp == -18) val = -18;
		else if (inp == -17) val = -17;
		else if (inp == -16) val = -16;
		else if (inp == -15) val = -15;
		else if (inp == -14) val = -14;
		else if (inp == -13) val = -13;
		else if (inp == -12) val = -12;
		else if (inp == -11) val = -11;
		else if (inp == -10) val = -10;
		else if (inp == -9) val = -9;
		else if (inp == -8) val = -8;
		else if (inp == -7) val = -7;
		else if (inp == -6) val = -6;
		else if (inp == -5) val = -5;
		else if (inp == -4) val = -4;
		else if (inp == -3) val = -3;
		else if (inp == -2) val = -2;
		else if (inp == -1) val = -1;
		else if (inp == 0) val = 0;
		else if (inp == 1) val = 1;
		else if (inp == 2) val = 2;
		else if (inp == 3) val = 3;
		else if (inp == 4) val = 4;
		else if (inp == 5) val = 5;
		else if (inp == 6) val = 6;
		else if (inp == 7) val = 7;
		else if (inp == 8) val = 8;
		else if (inp == 9) val = 9;
		else if (inp == 10) val = 10;
		else if (inp == 11) val = 11;
		else if (inp == 12) val = 12;
		else if (inp == 13) val = 13;
		else if (inp == 14) val = 14;
		else if (inp == 15) val = 15;
		else if (inp == 16) val = 16;
		else if (inp == 17) val = 17;
		else if (inp == 18) val = 18;
		else if (inp == 19) val = 19;
		else if (inp == 20) val = 20;
		else if (inp == 21) val = 21;
		else if (inp == 22) val = 22;
		else if (inp == 23) val = 23;
		else if (inp == 24) val = 24;
		else if (inp == 25) val = 25;
		else if (inp == 26) val = 26;
		else if (inp == 27) val = 27;
		else if (inp == 28) val = 28;
		else if (inp == 29) val = 29;
		else if (inp == 30) val = 30;
		else if (inp == 31) val = 31;
		else if (inp == 32) val = 32;
		else if (inp == 33) val = 33;
		else if (inp == 34) val = 34;
		else if (inp == 35) val = 35;
		else if (inp == 36) val = 36;
		else if (inp == 37) val = 37;
		else if (inp == 38) val = 38;
		else if (inp == 39) val = 39;
		else if (inp == 40) val = 40;
		else if (inp == 41) val = 41;
		else if (inp == 42) val = 42;
		else if (inp == 43) val = 43;
		else if (inp == 44) val = 44;
		else if (inp == 45) val = 45;
		else if (inp == 46) val = 46;
		else if (inp == 47) val = 47;
		else if (inp == 48) val = 48;
		else if (inp == 49) val = 49;
		else if (inp == 50) val = 50;
		else if (inp == 51) val = 51;
		else if (inp == 52) val = 52;
		else if (inp == 53) val = 53;
		else if (inp == 54) val = 54;
		else if (inp == 55) val = 55;
		else if (inp == 56) val = 56;
		else if (inp == 57) val = 57;
		else if (inp == 58) val = 58;
		else if (inp == 59) val = 59;
		else if (inp == 60) val = 60;
		else if (inp == 61) val = 61;
		else if (inp == 62) val = 62;
		else if (inp == 63) val = 63;

		return val;
	endfunction


	// READS AND PRINTS VALUE OF CFLOAT
	function Action cfloat_read(Cfloat_152 val,UInt#(6) bias);
		Real x=2;
		Real y=pow(2.718281,x);
		Real mant=0;
		Real expon=0;
		UInt#(7) final_expp = extend(val.exp);
		Int#(7) final_exp = unpack(pack(final_expp)) - extend(unpack(pack(bias))) ;
		Integer final_exp_int = int7_to_integer(final_exp);
		Real final_exp_real = fromInteger(final_exp_int);

		if(val.exp==0)
			begin
				if(val.mant==2'b00) 	mant = 0;
				else if(val.mant==2'b01)	mant = 0.25;
				else if(val.mant==2'b10)	mant = 0.50;
				else if(val.mant==2'b11)	mant = 0.75;

				expon	= pow(2,final_exp_real) ;
			end
		else
			begin
				if(val.mant==2'b00) 	mant = 1;
				else if(val.mant==2'b01)	mant = 1.25;
				else if(val.mant==2'b10)	mant = 1.50;
				else if(val.mant==2'b11)	mant = 1.75;
				
				expon	= pow(2,final_exp_real) ;
			end
		if(val.sign==1'b0) 
			$display("+%5.2f  x +%5.9f (2^%d-%d = %d)",mant,expon,val.exp,bias,final_exp);
		else
			$display("-%5.2f  x +%5.9f (2^%d-%d = %d)",mant,expon,val.exp,bias,final_exp);
	endfunction


	// FUNCTION TO MULTIPLY 1.25 = 1.01 - cannot do overflow checks; use carefully
	function Cfloat_152 mul_101(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool add_exp	= unpack((&(val.mant)) & (~(pack(x_is_denorm)))) ;	// only if not denormal
		UInt #(2) temp	= unpack(val.mant) + 1 ;

		res.sign	= val.sign ;
		if (x_is_denorm) 
			begin	
				res.mant	= val.mant ;
			end
		else
			begin
				res.mant	= pack(temp) ;
			end
		if (add_exp)
			begin
				res.exp	= val.exp + 1 ;
			end
		else
			begin
				res.exp	= val.exp ;
			end

		return res;
	endfunction
	// FUNCTION TO MULTIPLY 1.75 = 1.11 - cannot do overflow checks; use carefully 
	function Cfloat_152 mul_111(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool add_exp	= unpack((|(val.mant) & (~(pack(x_is_denorm))))) ;		// only if not denormal
		UInt #(2) temp	= unpack(val.mant) + 3 ;

		res.sign	= val.sign ;
		if (x_is_denorm) 
			begin	
				res.mant[0]	= val.mant[1] ;			// could interchange lhs for these 2. look at onenote. 
				res.mant[1]	= val.mant[0] | val.mant[1] ;	// if you change here change in 111_110
			end
		else
			begin
				res.mant	= pack(temp) ;
				
			end
		if (add_exp)
			begin
				res.exp	= val.exp + 1 ;
			end
		else
			begin
				res.exp	= val.exp ;
			end
		
		return res;
	endfunction
endpackage : functions