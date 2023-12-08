package exponential;

	import Real :: * ;
	import types :: *;
	import FIFO :: *;
	import Vector :: *;

	// FOLLOWING FUNCTIONS ARE FOR TEMP_SUM & FINAL_SUM CALC ONLY - CHECKING REQ AFTERWARDS
	// FUNCTION TO ADD 2 CFLOAT152's
	function Cfloat_152 bin_add(Cfloat_152 val1, Cfloat_152 val2);
		Cfloat_152 res;
		
		Bit #(5) exp1 = pack(val1.exp) ;
		Bit #(5) exp2 = pack(val2.exp) ;
		Bit #(6) exp_diff = signExtend(exp1) - signExtend(exp2) ;
		Int #(6) exp_diff_i = unpack(exp_diff) ;

		Bit #(1) exp_chk_plus_0 = ~(exp_diff[5] | exp_diff[4]) ;
		Bit #(1) exp_chk_plus_1 = ~(exp_diff[3] | exp_diff[2]) ;
		Bit #(1) exp_chk_plus_2 = ~(exp_diff[1] & exp_diff[0]) ;
		Bit #(1) exp_chk_plus	= exp_chk_plus_0 & exp_chk_plus_1 & exp_chk_plus_2 ;  
		Bit #(1) exp_chk_minus  = & exp_diff[5:1] ;						// refer onenote
		
		Bool have_to_add	= unpack(exp_chk_minus & exp_chk_plus) ;
		Bool diff_pos		= unpack(~exp_diff[5]);						// means exp1 is bigger

		UInt #(2) shamt ;
		UInt #(5) big_exp ;

		UInt #(3) augend	= unpack({ |(pack(val1.exp)) , val1.mant}) ;			// randomly assigning augend,addend
		UInt #(3) addend	= unpack({ |(pack(val2.exp)) , val2.mant}) ;			// unary or- exp=0 means 0.xy else 1.xy. HACK!
		
		Bool aug_neg		= unpack(val1.sign) ;
		Bool add_neg		= unpack(val2.sign) ;

		Int #(4) augs ;
		Int #(4) adds ;

		if(aug_neg)								// assigning 4 bit value
			augs		= signExtend(unpack(pack(-augend))) ;
		else
			augs		= signExtend(unpack(pack(+augend))) ;
		if(add_neg)
			adds		= signExtend(unpack(pack(-addend))) ;
		else
			adds		= signExtend(unpack(pack(+addend))) ;

		
		if(diff_pos) 							// exp1>exp2
			begin
				shamt	= truncate(unpack(pack(exp_diff_i))) ;
				adds	= adds >> shamt ;
				augs	= augs ;//?
				big_exp	= unpack(exp1) ;
			end
		else								// exp1<exp2
			begin
				shamt	= truncate(unpack(pack(-exp_diff_i))) ; 
				augs	= augs >> shamt ;
				adds	= adds ;//?
				big_exp = unpack(exp2) ;
			end

		Int #(5) temp_sum ;
		Bit #(5) temp_sum_b;

		temp_sum		= signExtend(augs) + signExtend(adds) ;
		temp_sum_b		= pack(temp_sum) ;

		Bool temp_sum_neg	= unpack(temp_sum_b[4]) ;
		Bit #(4) temp_mant ;

		res.sign		= temp_sum_b[4] ;				// sign of result
		if (temp_sum_neg)
			begin
				temp_mant	= truncate(pack(-temp_sum)) ; 
			end
		else
			begin
				temp_mant	= truncate(pack(+temp_sum)) ; 
			end
		
		
		Bool mant_3_1	= unpack(temp_mant[3]) ;				// mantissa, exp of result
		Bool mant_2_1	= unpack(temp_mant[2]) ;
		Bool mant_1_1	= unpack(temp_mant[2]) ;
		Bool mant_0_1	= unpack(temp_mant[0]) ;
		if (mant_3_1)
			begin
				res.mant	= temp_mant[2:1] ;
				res.exp		= big_exp + 5'b00001 ;
			end
		else if (mant_2_1)
			begin
				res.mant	= temp_mant[1:0] ;
				res.exp		= big_exp ;
			end
		else if (mant_1_1)
			begin
				res.mant	= {temp_mant[0],1'b0} ;
				res.exp		= big_exp - 5'b00001 ;
			end
		else if (mant_0_1)
			begin
				res.mant	= 2'b00 ;
				res.exp		= big_exp - 5'b00010 ;
			end	
		else
			begin
				res.mant	= 2'b00;
				res.exp		= big_exp ;
			end

		if (have_to_add)
			return res;	
		else if (diff_pos)
			return val1 ;
		else
			return val2 ;
		
	endfunction
	// END OF SUM FUNCTIONS

	// FOLLOWING FUNCTIONS ARE FOR STAGE TERM CALC ONLY - CHECKING REQ AFTERWARDS
	// FUNCTION TO CALCULATE NEXT STAGE TERM
	function Cfloat_chk stage_Term_mul(Cfloat_152 stage , Cfloat_152 x_term, UInt#(6) bias, Bool x_is_denorm, Bool stage_is_denorm, Int#(5) addl_bias);
		Cfloat_152 res ;
		Cfloat_chk val ;

		Bit #(2) temp_mant ;
		Int #(7) temp_exp0,temp_exp1,temp_exp_final ;
		UInt #(2) temp_mant_sum = unpack(stage.mant) + unpack(x_term.mant) ;

		Bit #(1) m_0111	= ~(stage.mant[1]) & (stage.mant[0]) & (&(x_term.mant)) ;
		Bit #(1) m_101x = (stage.mant[1]) & ~(stage.mant[0]) & (x_term.mant[1]) ;
		Bit #(1) m_11xy = (stage.mant[1]) & (stage.mant[0]) & (|(x_term.mant)) ;
		Bool both_norm	= !(x_is_denorm) && !(stage_is_denorm) ;
 
		res.sign	= stage.sign ^ x_term.sign ;

		temp_exp0	= signExtend(unpack(pack(stage.exp))) - signExtend(unpack(pack(bias))) ;
		temp_exp1	= signExtend(unpack(pack(x_term.exp))) + signExtend(unpack(m_0111 & m_101x & m_11xy & pack(both_norm))) ; // see onenote

		temp_exp_final	= temp_exp0 + temp_exp1 ;
		temp_exp_final	= temp_exp_final + signExtend(addl_bias) ;

		if (x_is_denorm)
			begin
				temp_mant[1]	= stage.mant[1] & stage.mant[0] & x_term.mant[1] & x_term.mant[0] ; 
				temp_mant[0]	= stage.mant[1] & x_term.mant[1] & ~(stage.mant[0] & x_term.mant[0]) ; // 101x,1x10 see onenote
			end
		else if (stage_is_denorm)
			begin
				temp_mant[1]	= stage.mant[1] ;
				temp_mant[0]	= stage.mant[0] | (x_term.mant[1] & stage.mant[1]) ; // see onenote 
			end
		else
			begin
				temp_mant	= pack(temp_mant_sum) ;
			end
		Bit#(3) norm_mant	= {1'b1, temp_mant} ;
		Bit#(3) denorm_mant	= {1'b0, temp_mant} ;
		
		
		// checker seems horrible
		if (temp_exp_final<0)					
			begin
				res.exp		= 0 ;
				val.stage_is_denorm	= True ;
				if (stage_is_denorm)	// 0.xy
					begin
						if(temp_exp_final == -1)
							begin
								res.mant	= denorm_mant[2:1] ;
							end
						else
							begin
								res.mant	= 2'b0 ;
							end
					end
				else			// 1.xy
					begin
						if(temp_exp_final == -2)
							begin
								res.mant	= 2'b01 ;
							end
						else if(temp_exp_final == -1)
							begin
								res.mant	= norm_mant[2:1] ;
							end
						else
							begin
								res.mant	= 2'b0 ;
							end
					end
			end
		else if (temp_exp_final == 0)
			begin
				if (stage_is_denorm)
					begin
						res.mant	= temp_mant ;
						res.exp		= truncate(unpack(pack(temp_exp_final))) ;
						val.stage_is_denorm	= True ;
					end
				else	// 1.00 , 1.01 > 0.11     1.10,1.11 >1.00 exp+=1
					begin
						if(temp_mant[1]==1'b0)
							begin
								res.mant	= 2'b11 ;
								res.exp		= 0 ;
								val.stage_is_denorm	= True ;
							end
						else
							begin
								res.mant	= 2'b00 ;
								res.exp		= 1 ;
								val.stage_is_denorm	= False ;
							end
					end
			end
		else
			begin
				res.mant	= temp_mant ;
				res.exp		= truncate(unpack(pack(temp_exp_final))) ;
				val.stage_is_denorm	= False ;
			end

		val.cfloat	= res;
		// $display(stage.exp,x_term.exp,addl_bias,bias,res.exp) ; //,m_0111 & m_101x & m_11xy & pack(both_norm)
		return val ;
	endfunction
	// END OF STAGE TERM FUNCTIONS

	// FOLLOWING 6 FUNCTIONS ARE FOR MID TERM CALC ONLY - NO CHECKING REQ AFTERWARDS
	// FUNCTION TO MULTIPLY 1.25 = 1.01 
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
	// FUNCTION TO MULTIPLY 1.50 = 1.10 
	function Cfloat_152 mul_110(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool add_exp	= unpack((val.mant[1]) & (~(pack(x_is_denorm)))) ;	// only if not denormal
		UInt #(2) temp	= unpack(val.mant) + 2 ;

		res.sign	= val.sign ;
		if (x_is_denorm) 
			begin	
				res.mant[1]	= val.mant[1] ;
				res.mant[0]	= val.mant[0] | val.mant[1] ;
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
	// FUNCTION TO MULTIPLY 1.75 = 1.11 
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
	// FUNCTION TO BRING DOWN FROM 1.75 TO 1.50
	function Cfloat_152 down_111_110(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool sub_exp	= unpack((~|(val.mant)) & (~(pack(x_is_denorm)))) ;				// only if not denormal
		UInt #(2) temp	= unpack(val.mant) - 1 ;
		
		res.sign	= val.sign ;
		if (x_is_denorm)
			begin
				res.mant = val.mant ;
			end
		else
			begin
				res.mant= pack(temp) ;
			end
		if (sub_exp)
			begin
				res.exp	= val.exp - 1 ;
			end
		else
			begin
				res.exp	= val.exp ;
			end
		return res ;
	endfunction
	// FUNCTION TO BRING DOWN FROM 1.50 TO 1.25
	function Cfloat_152 down_110_101(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool sub_exp	= unpack((~|(val.mant) & (~(pack(x_is_denorm))))) ;			// only if not denormal
		Bool ch_mant_d	= unpack(val.mant[1] & val.mant[0]) ;			// only if denormal and 11 -- 10
		UInt #(2) temp	= unpack(val.mant) - 1 ;
	
		res.sign	= val.sign ;
		if (x_is_denorm)
			begin
				if(ch_mant_d)
					res.mant = 2'b10 ;
				else
					res.mant = val.mant ;
			end
		else
			begin
				res.mant	= pack(temp) ;
			end
		if (sub_exp)
			begin
				res.exp	= val.exp - 1 ;
			end
		else
			begin
				res.exp	= val.exp ;
			end
		return res ;
	endfunction
	// FUNCTION TO BRING DOWN FROM 1.25 TO 1.00
	function Cfloat_152 down_101_100(Cfloat_152 val, Bool x_is_denorm);
		Cfloat_152 res ;
		Bool sub_exp	= unpack((~|(val.mant) & (~(pack(x_is_denorm))))) ;		// only if not denormal
		UInt #(2) temp	= unpack(val.mant) - 1 ;
	
		res.sign	= val.sign ;
		if (x_is_denorm)
			begin
				res.mant = val.mant ;
			end
		else
			begin
				res.mant= pack(temp) ;
			end
		if (sub_exp)
			begin
				res.exp	= val.exp - 1 ;
			end
		else
			begin
				res.exp	= val.exp ;
			end

		return res ;
	endfunction
	// END OF MID TERM FUNCTIONS


	// INTERFACE OF ENTIRE EXP BLOCK- also to support exp(x)-1
	interface Ifc_exp ;					
		method  Action set_bias (UInt#(6) bias_val);			// to set bias 0-63
		method  Action set_inp (Cfloat_152 val);			// to input into exp block
		method  Cfloat_152 read_exp ();					// to read exp(x)
		method  Cfloat_152 read_exp_1 ();				// to read exp(x)-1 : one stage before the end
		method Action one_cycle;
		method Cfloat_152 debug_read();
	endinterface

	// MODULE DEFINITION - TOTAL
	module mkExponent(Ifc_exp);

		Reg#(UInt#(6))	bias	<- mkReg(0) ;							// Configurable bias 0-63

		Vector #(32,Reg#(Cfloat_152))  stage_term	<- replicateM(mkReg(cfloat_def)) ;	// stage term			[31] NOT NEEDED?
		Vector #(32,Reg#(Cfloat_152))  mid_term		<- replicateM(mkReg(cfloat_def)) ;	// mid term or x term		[0] NOT NEEDED?
		Vector #(32,Reg#(Bool))  x_is_denorm		<- replicateM(mkReg(True)) ;		// if x(not mid_term) is denormal
		Vector #(32,Reg#(Bool))  stage_is_denorm	<- replicateM(mkReg(True)) ;		// if stage_term is denormal
		Vector #(32,Reg#(Cfloat_152))  temp_sum		<- replicateM(mkReg(cfloat_def)) ;	// sum accumulator

		Int#(5) addl_bias[32];
		for (Integer k=0 ; k<=31 ; k = k+1)
			begin
				Integer m=k+1;
				if (m==1) addl_bias[k]	= -1 ;
				else if (m>=2 && m<=3) addl_bias[k]	= -2 ;
				else if (m>=4 && m<=7) addl_bias[k]	= -3 ;
				else if (m>=8 && m<=16) addl_bias[k]	= -4 ;
				else if (m>=17 && m<=31) addl_bias[k]	= -5 ;
			end

		Reg#(Cfloat_152) total_sum			<- mkReg(cfloat_def) ;			// total sum       NOT NEEDED?

		// STRUCTURE OF THE PIPELINE
		method  Action one_cycle;
			for (Integer k=1 ; k<=31 ; k = k+1)					// x denormal flags
				x_is_denorm[k]			<= x_is_denorm[k-1] ; 

			for (Integer k=1 ; k<=31 ; k = k+1)					// mid terms
				begin	
					if (k==1)
						mid_term[k]	<= mul_101(mid_term[k-1],x_is_denorm[k-1]); 
					else if (k==3)
						mid_term[k]	<= mul_110(mid_term[k-1],x_is_denorm[k-1]); 
					else if (k==7 || k==17)
						mid_term[k]	<= mul_111(mid_term[k-1],x_is_denorm[k-1]); 
					else if(k==2 || k==6 || k==14 || k==28)						// prob
						mid_term[k]	<= down_101_100(mid_term[k-1],x_is_denorm[k-1]) ;
					else if(k==4 || k==11 || k==23)							// prob
						mid_term[k]	<= down_110_101(mid_term[k-1],x_is_denorm[k-1]) ;
					else if(k==8 || k==19)								// prob
						mid_term[k]	<= down_111_110(mid_term[k-1],x_is_denorm[k-1]) ;
					else
						mid_term[k]	<= mid_term[k-1] ;
				end

			for (Integer k=1 ; k<=31 ; k = k+1)					// stage terms and stage flags
				begin
					Cfloat_chk temp		= stage_Term_mul(stage_term[k-1],mid_term[k-1],bias,x_is_denorm[k-1],stage_is_denorm[k-1],addl_bias[k-1]) ;
					// $display(stage_term[k-1].exp,mid_term[k-1].exp,addl_bias[k-1],bias,temp.cfloat.exp) ;
					stage_term[k]		<= temp.cfloat ;
					stage_is_denorm[k]	<= temp.stage_is_denorm ;
				end	

			for (Integer k=1 ; k<=31 ; k = k+1)					// accumulation - temp sums
				begin
					temp_sum[k]			<= bin_add(temp_sum[k-1], stage_term[k]) ;

				end
			
			$display("stage_Term        x_term          temp_sum        stage_den       x_den");
			for (Integer k=0 ; k<=31 ; k = k+1)					
				begin   
					$display(k,"--%b",stage_term[k].sign,"-%b",stage_term[k].exp,"-%b",stage_term[k].mant,"--%b",mid_term[k].sign,"-%b",mid_term[k].exp,"-%b",mid_term[k].mant,"--%b",temp_sum[k].sign,"-%b",temp_sum[k].exp,"-%b",temp_sum[k].mant,"--",stage_is_denorm[k],"--",x_is_denorm[k]) ;
				end	
					
			temp_sum[0]				<= stage_term[0] ;

			// if(bias>=32)
		endmethod
		
		// INPUT BIAS
		method  Action set_bias (UInt#(6) bias_val);
			bias <= bias_val ;
		endmethod
		// INPUT X
		method  Action set_inp (Cfloat_152 val);
			stage_term[0]	<= val ;
			mid_term[0]	<= val ;						//NOT NEEDED?
			
			Bool denorm		= unpack(~|(pack(val.exp))) ;
			x_is_denorm[0]		<= denorm ;
			stage_is_denorm[0]	<= denorm ;
			$display("INPUT SENT");
		endmethod
		// RETURN E^X 
		method Cfloat_152 read_exp ();
			return total_sum ;
		endmethod
		// RETURN E^X - 1
		method Cfloat_152 read_exp_1 ();
			return temp_sum[31] ;
		endmethod

		method Cfloat_152 debug_read();
			return stage_term[0];
		endmethod
	endmodule

	

endpackage : exponential

