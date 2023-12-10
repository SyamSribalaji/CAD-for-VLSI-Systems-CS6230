package condensed;

	import Real :: * ;
	import types :: *;
	import FIFO :: *;
	import Vector :: *;
	import functions :: *;


		// RETURN EXP(X)-1
	function Cfloat_ret calc_exp_1(Cfloat_152 x, Bool x_is_denorm, UInt#(6) bias);

		Cfloat_ret exp_1 =  cfloat_ret_def();						// return value

		Bool x_is_neg	= unpack(x.sign);
		Int#(7)	order	= signExtend(unpack(pack(x.exp))) - signExtend(unpack(pack(bias)));
		Int#(7) temp_add_exp = 0, temp_sum=0 ;

		if(x_is_denorm)									// denormal
			begin
				if((x_is_neg) && (order==0) && (x.mant==2'b11))			// denormal negative - only case in denormal with change
					begin		
						begin
							exp_1.val.sign		= x.sign;
							exp_1.val.mant		= 2'b10;
							exp_1.val.exp		= x.exp;
						end
					end
				else								// denormal positive
					begin
						exp_1.val	= x;
					end
				exp_1.val_is_denorm	= True;
				exp_1.val_overflow	= False;
			end
		else										// normal
			begin
				if(x_is_neg)							// normal negative
					begin
						Bool mant_00	= ((order==-3)&&(x.mant[1]==1'b0)) || ((order==-2)&&(x.mant==2'b01)) || ((order==-1)&&(x.mant[1]==1'b1)) || ((order==1)&&(x.mant[1]==1'b1)) ;
						Bool mant_01	= ((order==-3)&&(x.mant==2'b10)) || ((order==-2)&&(x.mant==2'b10)) || ((order==0)&&(x.mant==2'b00)) ;
						Bool mant_10	= ((order==-3)&&(x.mant==2'b11)) || ((order==-2)&&(x.mant==2'b11)) || ((order==-1)&&(x.mant==2'b00)) || ((order==0)&&(x.mant[1]!=x.mant[0])) ;
						Bool mant_11	= ((order==-2)&&(x.mant==2'b00)) || ((order==-1)&&(x.mant==2'b01)) || ((order==0)&&(x.mant==2'b11)) || ((order==1)&&(x.mant[1]==1'b0)) ;

						if(order<=-4)	exp_1.val.mant = x.mant ;
						else if(mant_11) exp_1.val.mant = 2'b11;	 
						else if(mant_00) exp_1.val.mant = 2'b00;
						else if(mant_01) exp_1.val.mant = 2'b01;
						else if(mant_10) exp_1.val.mant = 2'b10;
						else if(order>=2) exp_1.val.mant = 2'b00;	//1

						
						// Bool expon_0 	= ;
						Bool expon_1	= ((order==-2)&&(x.mant==2'b0)) || ((order==-1)&&(x.mant[1]==1'b0)) || ((order==0)&&(x.mant!=2'b01)) || ((order==1)&&(x.mant[1]==1'b1));
						Bool expon_2	= ((order==1)&&(x.mant[1]==1'b0));
						

						
						if(order<=-4)	exp_1.val.exp = x.exp;
						else if (order>=2)		// = -1
							begin
								if(bias==0)
									begin
										exp_1.val.exp = 0 ;
										exp_1.val.mant = 2'b11 ; // changed from prev closest rep 0.11
										exp_1.val_is_denorm = True;
									end
								else if (bias>31)
									begin
										exp_1.val.exp = 31 ;
										exp_1.val.mant = 2'b11;
										exp_1.val_is_denorm = False;
									end
								else
									begin
										exp_1.val.exp = truncate(bias) ;
										exp_1.val_is_denorm = False;
									end
							end
						else 
							begin
								if (expon_1) temp_add_exp = 1;
								else if (expon_2) temp_add_exp = 2;
								else temp_add_exp = 0;

								temp_sum = signExtend(unpack(pack(x.exp))) - temp_add_exp ;
								if (temp_sum==0)
									begin
										if(exp_1.val.mant[1]==1'b0)
											begin
												exp_1.val.mant = 2'b11;
												exp_1.val.exp = 0 ;
												exp_1.val_is_denorm = True;
											end
										else
											begin
												exp_1.val.exp = 1 ;
												exp_1.val.mant = 2'b00;
												exp_1.val_is_denorm = False;
											end
									end
								else if(temp_sum==-1)  // cannot be = -2 as denormal covered elsewhere
									begin
										exp_1.val.exp = 0 ;
										exp_1.val.mant = {1'b1,exp_1.val.mant[1]};
										exp_1.val_is_denorm = True;
									end
								else
									begin
										exp_1.val.exp = truncate(unpack(pack(temp_sum))) ;
										exp_1.val_is_denorm = False;
									end	

							end

						if(order>=2 && bias>31) exp_1.val_overflow = True;
						else exp_1.val_overflow = False;
						
					end
					
				else								// normal positive
					begin
						Bool overflow	= (order>=5) || ((order==4)&&(x.mant[1]==1'b1));
						Bool mant_00	= ((order==-2)&&(x.mant[1]==x.mant[0])) || ((order==-1)&&(x.mant==2'b10)) || ((order==1)&&(x.mant==2'b11)) || ((order==2)&&(x.mant[0]==1'b1)) || ((order==3)&&(x.mant==2'b11)) || ((order==4)&&(x.mant==2'b00));
						Bool mant_01	= ((order==-1)&&(x.mant[1]==x.mant[0])) || ((order==0)&&(x.mant[0]==1'b1))  || ((order==1)&&(x.mant[1]!=x.mant[0])) || ((order==3)&&(x.mant[1]!=x.mant[0])) ;
						Bool mant_10	= ((order==-2)&&(x.mant==2'b01)) || ((order==1)&&(x.mant==2'b00)) || ((order==2)&&(x.mant[0]==1'b0)) || ((order==3)&&(x.mant==2'b00)) ;
						Bool mant_11	= ((order==-2)&&(x.mant==2'b10)) || ((order==-1)&&(x.mant==2'b01)) || ((order==0)&&(x.mant[0]==1'b0)) || ((order==4)&&(x.mant==2'b01)) ;

						if(order<=-3)	exp_1.val.mant = x.mant ;	 
						else if(mant_00) exp_1.val.mant = 2'b00;
						else if(mant_01) exp_1.val.mant = 2'b01;
						else if(mant_10) exp_1.val.mant = 2'b10;
						else if((overflow)||(mant_11))	 exp_1.val.mant = 2'b11;

						// Bool expon_0 	= ;
						Bool expon_1	= (order==0 && x.mant[1]!=x.mant[0])||(order==-1 && x.mant[1]==1'b1)||(order==1 && x.mant==2'b00)||(order==-2 && x.mant==2'b11) ;
						Bool expon_2	= (order==1 && x.mant==2'b01)||(order==0 && x.mant==2'b11) ; 
						Bool expon_3	= (order==1 && x.mant==2'b10)||(order==3 && x.mant==2'b00) ;
						Bool expon_4	= (order==1 && x.mant==2'b11) ;
						Bool expon_5	= (order==2 && x.mant==2'b01) ;
						Bool expon_6	= (order==2 && x.mant==2'b10) ;
						Bool expon_8	= (order==3 && x.mant==2'b00)||(order==2 && x.mant==2'b11) ; 
						Bool expon_11	= (order==3 && x.mant==2'b01) ;
						Bool expon_14	= (order==3 && x.mant==2'b10) ;
						Bool expon_17	= (order==3 && x.mant==2'b11) ;
						Bool expon_19	= (order==4 && x.mant==2'b00) ;
						Bool expon_24	= (order==4 && x.mant==2'b01) ;
						// UInt#(5) temp_add_exp ;

						if(order<=-3)	exp_1.val.exp = x.exp;
						else if (overflow) exp_1.val.exp = 31;
						else 
							begin
								if (expon_1) temp_add_exp = 1;
								else if (expon_2) temp_add_exp = 2;
								else if (expon_3) temp_add_exp = 3;
								else if (expon_4) temp_add_exp = 4;
								else if (expon_5) temp_add_exp = 5;
								else if (expon_6) temp_add_exp = 6;
								else if (expon_8) temp_add_exp = 8;
								else if (expon_11) temp_add_exp = 11;
								else if (expon_14) temp_add_exp = 14;
								else if (expon_17) temp_add_exp = 17;
								else if (expon_19) temp_add_exp = 19;
								else if (expon_24) temp_add_exp = 24;
								else temp_add_exp = 0;

								// temp_sum 	= order + temp_add ;		// cannot overflow/underflow
								// temp_sum 	= exp_1.val.exp  + bias ;
								exp_1.val.exp	= x.exp + truncate(unpack(pack(temp_add_exp))) ;
							end


						if(overflow) 	exp_1.val_overflow	= True;
						else		exp_1.val_overflow	= False;
						exp_1.val_is_denorm = False;
					end
				exp_1.val.sign	= x.sign;
			end
		exp_1.val_underflow	= False;
		// $display(exp_1.val.mant);
		return exp_1;
	endfunction

	// INTERFACE OF  CONDENSED 
	interface Ifc_cond ;					
		method  Action set_bias (UInt#(6) bias_val);			// to set bias 0-63
		method  Action set_mode (UInt#(2) mode);			// to set mode 0- selu  1-relu 2-sigmoid 3-tanh
		method  Action set_inp (Cfloat_152 val);			// to input x into the design

		method Cfloat_ret read_out();					// to read output stream
	endinterface


	// MODULE CONTAINING ALL 4
	module mkCondensed(Ifc_cond);				
	
		Reg#(UInt#(6))	bias	<- mkReg(0) ;							// Configurable bias 0-63
		Reg#(Cfloat_152) x			<- mkReg(cfloat_def) ;				// input is stored here
		Reg#(Bool) x_is_denorm			<- mkReg(True);					// denormal flag

		Reg#(Cfloat_152) x_2			<- mkReg(cfloat_def) ;				// copy of x to be used for selu (2nd stage)
		Reg#(Bool) x2_is_denorm			<- mkReg(True);					// denormal flag

		Reg#(Cfloat_152) exp_term		<- mkReg(cfloat_def) ;				// stores e^x-1 or e^2x-1
		Reg#(Bool) exp_is_denorm			<- mkReg(True);				// denormal flag
		Reg#(Bool) exp_overflow			<- mkReg(False);				// Overflow flag
		Reg#(Bool) exp_underflow			<- mkReg(False);			// Underflow flag

		Reg#(UInt#(2)) mode			<- mkReg(0);					// 0- selu  1-relu 2-sigmoid 3-tanh

		Reg#(Cfloat_152) out_term		<- mkReg(cfloat_def) ;				// stores e^x-1 or e^2x-1
		Reg#(Bool) out_is_denorm			<- mkReg(True);				// denormal flag
		Reg#(Bool) out_overflow			<- mkReg(False);				// Overflow flag
		Reg#(Bool) out_underflow			<- mkReg(False);			// Underflow flag	

		// calculates exp(x)-1 or exp(-x)-1 according to mode; and x_2
		rule fill_exp_(mode==0 || mode==2);
			Cfloat_ret temp = cfloat_ret_def();
			Cfloat_152 temp_in = x ;

			if(mode==0)
				begin
					temp = calc_exp_1(temp_in,x_is_denorm,bias);
				end
			else
				begin
					temp_in.sign = ~temp_in.sign ;
					temp = calc_exp_1(temp_in,x_is_denorm,bias);
				end
			exp_term <= temp.val ;
			exp_is_denorm <= temp.val_is_denorm ;
			exp_underflow <= temp.val_underflow ;
			exp_overflow <= temp.val_overflow ;

			// $display("x to exp_x-1");
			// $display(x.sign,"-%b",x.exp,"-%b",x.mant,"-",x_is_denorm);
			// $display(temp.val.sign,"-%b",temp.val.exp,"-%b",temp.val.mant,"-",temp.val_is_denorm,"-",temp.val_underflow);


			x_2 <= x ;
			x2_is_denorm <= x_is_denorm ;
		endrule
		// Write SELU(X) into output
		rule write_selu(mode==0);								// be sure to read this value after setting proper mode. reads from 2nd stage x
			// x>0  output is x = x2
			// x<0  output is 1.75 (exp(x)-1) = 1.75 * exp_term
			Cfloat_ret res ;

			Cfloat_152 temp ;
			temp.sign	= exp_term.sign ;
			temp.mant	= exp_term.mant ;
			temp.exp 	= 0 ;			// will add actual exponent later. this 0 does not mean denormal. that info goes with flag

			Cfloat_152 temp2 = mul_111(temp,exp_is_denorm);
			Int#(7) temp_exp_sum  = signExtend(unpack(pack(temp2.exp))) + signExtend(unpack(pack(exp_term.exp))) ;

			// $display(" exp_x-1 to selu");
			// $display(exp_term.sign,"-%b",exp_term.exp,"-%b",exp_term.mant,"-",exp_is_denorm,"-",exp_overflow);
			// $display(temp2.sign,"-%b",temp_exp_sum,"-%b",temp2.mant);

			if (x.sign==1'b0) 
				begin
					res.val			= x_2;
					res.val_is_denorm	= x2_is_denorm ;
					res.val_overflow	= False;
					res.val_underflow	= False;
				end
			else
				begin
					if(temp_exp_sum ==32)				// could not have been denormal input
						begin			
							res.val.sign = exp_term.sign ;
							res.val.mant = 2'b11;
							res.val.exp  = 31 ;
							res.val_is_denorm = False;
							res.val_overflow = True;
							res.val_underflow = False;
							
						end
					else
						begin
							res.val.sign	= temp2.sign;
							res.val.mant	= temp2.mant;
							res.val.exp	= truncate(unpack(pack(temp_exp_sum)));
							res.val_is_denorm = exp_is_denorm;	
							res.val_overflow = False;
							res.val_underflow = False;		// previous underflows forgotten at this point. can be changed to exp_underflow if required.

						end
				end


			out_term <= res.val;
			out_is_denorm <= res.val_is_denorm;
			out_underflow <= res.val_underflow;
			out_overflow <= res.val_overflow;

		endrule
		// Write LEAKY_RELU(X) into output
		rule write_lru(mode==1);
			// x>0  output is x
			// x<0  output is 0.01x 
			Cfloat_ret res;									// result


			Cfloat_152 temp ;
			temp.sign	= x.sign ;
			temp.mant	= x.mant;
			temp.exp	= 0;			// will add actual exponent later. this 0 does not mean denormal. that info goes with flag
			
			Cfloat_152 temp2 = mul_101(temp,x_is_denorm);
			Int#(7) temp_exp_sum  = signExtend(unpack(pack(temp2.exp))) -7 ;
			temp_exp_sum	= temp_exp_sum + signExtend(unpack(pack(x.exp))) ;
			
			if (x.sign==1'b0) 
				begin
					res.val		= x;
					res.val_is_denorm	= x_is_denorm ;
					res.val_overflow	= False;
					res.val_underflow	= False;
				end
			else
				begin
					if(temp_exp_sum <0)
						begin
							if(x_is_denorm)
								begin
									res.val.sign = x.sign ;
									res.val.mant = 2'b00;
									res.val.exp  = 0 ;
									res.val_is_denorm = True;
									res.val_overflow = False;
									res.val_underflow = True;
								end
							else 
								begin		 
									if(temp_exp_sum==-1) //1.ab * 2^-1 = 0.1a
										begin
											res.val.sign = x.sign ;
											res.val.mant = {1'b1,temp2.mant[1]};
											res.val.exp  = 0 ;
											res.val_is_denorm = True;
											res.val_overflow = False;
											res.val_underflow = False;
										end
									else if(temp_exp_sum==-2)  // 1.ab * 2^-2 = 0.01 
										begin
											res.val.sign = x.sign ;
											res.val.mant = 2'b01;
											res.val.exp  = 0 ;
											res.val_is_denorm = True;
											res.val_overflow = False;
											res.val_underflow = False;
										end
									else
										begin
											res.val.sign = x.sign ;
											res.val.mant = 2'b00;
											res.val.exp  = 0 ;
											res.val_is_denorm = True;
											res.val_overflow = False;
											res.val_underflow = True;

										end
								end
						end
					else if(temp_exp_sum ==0)				// could not have been denormal input
						begin				
							if(temp2.mant[1]==1'b0)			// rounding off 1.00,1.01 to 0.11 and 1.10,1.11 to 1.00&exp+=1
								begin
									res.val.sign = x.sign ;
									res.val.mant = 2'b11;
									res.val.exp  = 0 ;
									res.val_is_denorm = True;
									res.val_overflow = False;
									res.val_underflow = False;
								end
							else
								begin
									res.val.sign = x.sign ;
									res.val.mant = 2'b00;
									res.val.exp  = 1 ;
									res.val_is_denorm = False;
									res.val_overflow = False;
									res.val_underflow = False;
								end
						end
					else
						begin
							res.val.sign	= x.sign;
							res.val.mant	= temp2.mant;
							res.val.exp	= truncate(unpack(pack(temp_exp_sum)));
							res.val_is_denorm = False;
							res.val_overflow = False;
							res.val_underflow = False;

						end
				end
	
			out_term <= res.val;
			out_is_denorm <= res.val_is_denorm;
			out_underflow <= res.val_underflow;
			out_overflow <= res.val_overflow;
		endrule
		// Write SIGMOID(X) into output
		rule write_sigmoid(mode==2);
			// add 2 to exp_term (in this case this sum is always >1)(sigmoid always >0)
			// then invert and store it in out_term
			Cfloat_ret res = cfloat_ret_def();
			Int#(7)	order	= signExtend(unpack(pack(exp_term.exp))) - signExtend(unpack(pack(bias)));
			Int#(7) temp_exp_sum = 0;
			
			Cfloat_152 temp = exp_term;

			if(order< -1)				// 1/(2+0) in that bias; exp_term ignored; = 1.00 * 2^(bias-1 - bias)
				begin
					res.val.sign = 1'b0;
					if(bias==0)
						begin
							res.val.exp = 0 ;
							res.val.mant = 2'b10 ;
							res.val_is_denorm = True;
							res.val_overflow	= False;
						end
					else if (bias==1)
						begin
							res.val.exp = 0 ;
							res.val.mant = 2'b11 ; //  closest rep 0.11 * 2^ (0 - 1)
							res.val_is_denorm = True;
							res.val_overflow	= False;
						end
					else if (bias>32)
						begin
							res.val.exp = 31 ;
							res.val.mant = 2'b11;
							res.val_is_denorm = False;
							res.val_overflow	= True;
						end
					else
						begin
							res.val.exp = truncate(bias-1) ;
							res.val.mant = 2'b00;
							res.val_is_denorm = False;
							res.val_overflow	= False;
						end
					res.val_underflow	= False;
					
				end
			else if(order>3)					// 1/(0+exp_term); 2 ignored ; this number is can not be denormal
				begin
					res.val.sign = 1'b0;
					if(exp_term.mant==2'b00) temp_exp_sum = - order ;
					else temp_exp_sum = -order -1 ;

					if (exp_term.mant[1]==exp_term.mant[0]) res.val.mant = 2'b00 ;
					else res.val.mant = {exp_term.mant[0],exp_term.mant[1]} ; // see truth table

					if (temp_exp_sum==0)
						begin
							if(exp_term.mant[1]==1'b0)			// denormal approx to lower and higher
								begin
									res.val.mant = 2'b11;
									res.val.exp = 0 ;
									res.val_is_denorm = True;
									res.val_underflow = False;
									res.val_overflow = False;
								end
							else
								begin
									res.val.exp = 1 ;
									res.val.mant = 2'b00;
									res.val_is_denorm = False;
									res.val_underflow = False;
									res.val_overflow = False;
								end
						end
					else if(temp_exp_sum==-1)
						begin
							res.val.exp = 0 ;
							res.val.mant = {1'b1,res.val.mant[1]};
							res.val_is_denorm = True;
							res.val_underflow = False;
							res.val_overflow = False;
						end
					else if(temp_exp_sum==-2)
						begin
							res.val.exp = 0 ;
							res.val.mant = 2'b01 ;
							res.val_is_denorm = True;
							res.val_underflow = False;
							res.val_overflow = False;
						end
					else if(temp_exp_sum<0)
						begin
							res.val.exp = 0 ;
							res.val.mant = 2'b00 ;
							res.val_is_denorm = True;
							res.val_underflow = True;
							res.val_overflow = False;
						end
					else
						begin
							res.val.exp = truncate(unpack(pack(temp_exp_sum))) ;
							res.val_is_denorm = False;
							res.val_underflow = False;
							res.val_overflow = False;
						end
						
				end
			else
				begin					// sum with 2 is first 'held' in res.val ; then inversed 'into the same' 
					res.val.sign = 1'b0;
					if(exp_is_denorm)
						begin
							if(order==0)
								begin
									if(exp_term.mant[1]==1'b1) // 0.1b
										begin
											if(exp_term.sign==1'b0)
												begin
													if(bias==31) res.val.exp = 31;
													else res.val.exp = truncate(bias) + 1;
													res.val.mant = 2'b01 ;
													res.val_is_denorm = False;
												end
											else
												begin
													res.val.mant = 2'b10 ;
													if(bias==0)
														begin
															res.val.mant = 2'b00 ;
															res.val.exp = 1;
														end
													else res.val.exp = truncate(bias);
													res.val_is_denorm = False;
												end
										end
									else			// 0.0b
										begin
											if(bias==31) res.val.exp = 31;
											else res.val.exp = truncate(bias) + 1;
											res.val.mant = 2'b00 ;
											res.val_is_denorm = False;
										end
								end
							else			// order==-1 is the only case
								begin
									if(bias==31) res.val.exp = 31;
									else res.val.exp = truncate(bias) + 1;
									res.val.mant = 2'b00 ;
									res.val_is_denorm = False;
								end
						end
					else
						begin
							if(order==-1)
								begin
									// $display("EXecuting order -1");
									if(exp_term.sign==1'b0)
										begin
											if(bias==31) res.val.exp = 31;
											else res.val.exp = truncate(bias) + 1;
											res.val.mant = 2'b01 ;
											res.val_is_denorm = False;
										end
									else
										begin
											res.val.mant = 2'b10 ;
											if(bias==0)
												begin
													res.val.mant = 2'b00 ;
													res.val.exp = 1;
													res.val_is_denorm = False;
												end
											else 
												begin
													res.val.exp = truncate(bias);
													res.val_is_denorm = False;
												end
										end
									// $display($time,"before inv:",res.val.sign,"-%b",res.val.exp,"-%b",res.val.mant);
								end
							else if(order==0)
								begin
									
									if(exp_term.sign==1'b1)
										begin
											res.val.mant = 2'b00 ;     // 00 for both cases
											if(exp_term.mant[1]==1'b1) // 0.5
												begin
													if(bias==0)
														begin
															res.val.exp = 0; 
															res.val.mant = 2'b10;
															res.val_is_denorm = True;
														end 
													else if(bias == 1)
														begin
															res.val.exp = 1; 
															res.val.mant = 2'b11;//approx =0.375 next value in this bias is 1
															res.val_is_denorm = False;
														end 
													else 
														begin
															res.val.exp = truncate(bias) - 1;
															res.val_is_denorm = False;
														end
												end
											else			// 1
												begin
													if(bias==0)
														begin
															res.val.exp = 0; 
															res.val.mant = 2'b11;  // approx
															res.val_is_denorm = True;
														end 
													else 
														begin
															res.val.exp = truncate(bias) - 1;
															res.val_is_denorm = False;
														end

												end
										end
									else
										begin
											res.val.mant = {1'b1,exp_term.mant[1]};
											if(bias==31) res.val.exp = 31;
											else res.val.exp = truncate(bias) + 1;
											res.val_is_denorm = False;
											
										end
								end
							else if(order==1)	// only + case
								begin
									res.val.mant = {1'b0,exp_term.mant[1]};
									if(bias < 30) res.val.exp = truncate(bias) +2;
									else res.val.exp = 31;
											res.val_is_denorm = False;
								end
							else if(order==2)	// only + case
								begin
									if(exp_term.mant[1]==1'b1)
										begin
											res.val.mant = 2'b00;
											if(bias < 29) res.val.exp = truncate(bias) +3;
											else res.val.exp = 31;
										end
									else
										begin
											res.val.mant = {1'b1,exp_term.mant[0]};
											if(bias < 30) res.val.exp = truncate(bias) +2;
											else res.val.exp = 31;
										end
											res.val_is_denorm = False;
								end
							else if(order==3)	// only + case
								begin
									if(exp_term.mant==2'b11)
										begin
											if(bias < 28) res.val.exp = truncate(bias) +4;
											else res.val.exp = 31;
										end
									else
										begin
											if(bias < 29) res.val.exp = truncate(bias) +3;
											else res.val.exp = 31;
										end

									if(exp_term.mant==2'b11) res.val.mant = 2'b00;
									else if (exp_term.mant==2'b00) res.val.mant = 2'b01;
									else if (exp_term.mant==2'b01) res.val.mant = 2'b10;
									else if (exp_term.mant==2'b10) res.val.mant = 2'b11;
									res.val_is_denorm = False;
									
								end
						end 

					// copied from order>3 part  - // some of these may be denormal - possible bugs
					order	= signExtend(unpack(pack(res.val.exp))) - signExtend(unpack(pack(bias)));
					// $display($time,"THIS ORDer %b",order);
					if(res.val_is_denorm)
						begin
							if(res.val.mant==2'b01)	// 00 can not occur
								begin
									res.val.mant = 2'b00;
									if(bias<15)
										begin
											res.val.exp = truncate(bias) + 2 + truncate(bias) ;
											res.val_is_denorm = False;
											res.val_overflow = False;
											res.val_underflow = False;
										end
									else
										begin
											res.val.mant= 2'b11;
											res.val.exp = 31;
											res.val_is_denorm = False;
											res.val_overflow = True;
											res.val_underflow = False;
										end
								end
							else if(res.val.mant==2'b10)
								begin
									res.val.mant = 2'b00;
									if(bias<16)
										begin
											res.val.exp = truncate(bias) + 1 + truncate(bias) ;
											res.val_is_denorm = False;
											res.val_overflow = False;
											res.val_underflow = False;
										end
									else
										begin
											res.val.mant= 2'b11;
											res.val.exp = 31;
											res.val_is_denorm = False;
											res.val_overflow = True;
											res.val_underflow = False;
										end
								end
							else			// 11
								begin
									res.val.mant = 2'b01;
									if(bias<16)
										begin
											res.val.exp = truncate(bias) + truncate(bias) ;
											res.val_is_denorm = False;
											res.val_overflow = False;
											res.val_underflow = False;
										end
									else
										begin
											res.val.mant= 2'b11;
											res.val.exp = 31;
											res.val_is_denorm = False;
											res.val_overflow = True;
											res.val_underflow = False;
										end
								end
						end
					else
						begin
							if(res.val.mant==2'b00) temp_exp_sum = - order ;
							else temp_exp_sum = -order -1 ;
							temp_exp_sum = temp_exp_sum + extend(unpack(pack(bias))) ;

							// $display($time,"old mant %b",res.val.mant);
							// $display($time,"THIS temp_exp ",temp_exp_sum);
							if (res.val.mant[1]==res.val.mant[0]) res.val.mant = 2'b00 ;
							else res.val.mant = {res.val.mant[0],res.val.mant[1]} ; // see truth table
							// $display($time,"new mant %B",res.val.mant);
							if (temp_exp_sum==0)
								begin
									if(res.val.mant[1]==1'b0)			// denormal approx to lower and higher
										begin
											res.val.mant = 2'b11;
											res.val.exp = 0 ;
											res.val_is_denorm = True;
											res.val_underflow = False;
											res.val_overflow = False;
										end
									else
										begin
											res.val.exp = 1 ;
											res.val.mant = 2'b00;
											res.val_is_denorm = False;
											res.val_underflow = False;
											res.val_overflow = False;
										end
								end
							else if(temp_exp_sum==-1)
								begin
									res.val.exp = 0 ;
									res.val.mant = {1'b1,res.val.mant[1]};
									res.val_is_denorm = True;
									res.val_underflow = False;
									res.val_overflow = False;
								end
							else if(temp_exp_sum==-2)
								begin
									res.val.exp = 0 ;
									res.val.mant = 2'b01 ;
									res.val_is_denorm = True;
									res.val_underflow = False;
									res.val_overflow = False;
								end
							else if(temp_exp_sum<0)
								begin
									res.val.exp = 0 ;
									res.val.mant = 2'b00 ;
									res.val_is_denorm = True;
									res.val_underflow = True;
									res.val_overflow = False;
								end
							else
								begin
									res.val.exp = truncate(unpack(pack(temp_exp_sum))) ;
									res.val_is_denorm = False;
									res.val_underflow = False;
									res.val_overflow = False;
								end
								end
					
				end

			out_term <= res.val;
			out_is_denorm <= res.val_is_denorm;
			out_underflow <= res.val_underflow;
			out_overflow <= res.val_overflow;
			

			// $display(" exp_x-1 to sigmoid");
			// $display(exp_term.sign,"-%b",exp_term.exp,"-%b",exp_term.mant,"-",exp_is_denorm,"-",exp_overflow);
			// $display($time,"after inv:",res.val.sign,"-%b",res.val.exp,"-%b",res.val.mant);

		endrule	
		// Write TANH(X) into output
		rule write_tanh(mode==3);
			// small x - tanhx = x
			// big x - tanhx = 1 
			Cfloat_ret res = cfloat_ret_def();
			Int#(7)	order	= signExtend(unpack(pack(x.exp))) - signExtend(unpack(pack(bias)));

			if(x_is_denorm)
				begin
					res.val		= x;
					res.val_is_denorm = x_is_denorm ;
					res.val_underflow	= False;
					res.val_overflow	= False;
				end
			else
				begin
					if(order<=-2)
						begin
							res.val		= x;
							res.val_is_denorm = x_is_denorm ;
							res.val_underflow	= False;
							res.val_overflow	= False;
						end
					else if(order==-1)
						begin
							res.val.sign	= x.sign;
							res.val.exp	= x.exp;

							if(x.mant==2'b11) res.val.mant = 2'b10;
							else if(x.mant==2'b10) res.val.mant = 2'b01;
							else res.val.mant = 2'b00;

							res.val_is_denorm = x_is_denorm ;
							res.val_underflow	= False;
							res.val_overflow	= False;
						end
					else if(order==0)
						begin
							res.val.sign	= x.sign;
							res.val.exp	= x.exp-1;

							 if(x.mant==2'b00) res.val.mant = 2'b10;
							else if(x.mant==2'b01) res.val.mant = 2'b11;
							else if(x.mant==2'b10) res.val.mant = 2'b01;
							else if(x.mant==2'b11) res.val.mant = 2'b00;

							if(res.val.exp==0)
								begin
									res.val.mant = {1'b1,res.val.mant[1]};
								end
							
							res.val_is_denorm = x_is_denorm ;
							res.val_underflow	= False;
							res.val_overflow	= False;

						end
					else if(order>=1)	// 1 or -1 in this bias
						begin
							res.val.sign = x.sign;
							if(bias==0)
								begin
									res.val.exp = 0 ;
									res.val.mant = 2'b11 ; // changed from prev closest rep 0.11
									res.val_is_denorm = True;
									res.val_overflow	= False;
								end
							else if (bias>31)
								begin
									res.val.exp = 31 ;
									res.val.mant = 2'b11;
									res.val_is_denorm = False;
									res.val_overflow	= True;
								end
							else
								begin
									res.val.exp = truncate(bias) ;
									res.val_is_denorm = False;
									res.val_overflow	= False;
								end
							res.val_underflow	= False;
							
						end
				end
			
			out_term <= res.val;
			out_is_denorm <= res.val_is_denorm;
			out_underflow <= res.val_underflow;
			out_overflow <= res.val_overflow;

		endrule


		// INPUT BIAS
		method  Action set_bias (UInt#(6) bias_val);
			bias <= bias_val ;
		endmethod
		// INPUT MODE
		method  Action set_mode (UInt#(2) mode_val);
			mode <= mode_val ;
		endmethod
		// INPUT X
		method  Action set_inp (Cfloat_152 val);						// single stage pipeline. just to hold value
			x	<= val ;
			
			Bool denorm		= unpack(~|(pack(val.exp))) ;
			x_is_denorm		<= denorm ;
		endmethod
		// RETURN OUTPUT STREAM
		method Cfloat_ret read_out();
			Cfloat_ret temp ;
			temp.val = out_term;
			temp.val_is_denorm = out_is_denorm ;
			temp.val_underflow = out_underflow;
			temp.val_overflow = out_overflow ;

			return temp;
		endmethod
	

	endmodule


endpackage : condensed