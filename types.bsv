package types;
	import Real :: * ;

	
	typedef struct{					// Cfloat_1_5_2 type
		Bit  #(1) sign;		
		UInt #(5) exp;
		Bit  #(2) mant;
	} Cfloat_152 deriving(Bits,Eq);

	function Cfloat_152 cfloat_def();		// Constructor for Cfloat_152		
		Cfloat_152 def;
		def.sign	= 1'b0;
		def.exp		= 5'b00000;
		def.mant	= 2'b00;
		return def;
	endfunction


	typedef struct{					// Whenever a calc is performed on cfloat 152, contains flags
		Cfloat_152 val;
		Bool val_is_denorm;
		Bool val_underflow;
		Bool val_overflow;
	} Cfloat_ret deriving(Bits,Eq);

	function Cfloat_ret cfloat_ret_def();		// Constructor for Cfloat_ret		
		Cfloat_ret def;

		def.val.sign	= 1'b0;
		def.val.exp	= 5'b00000;
		def.val.mant	= 2'b00;
		def.val_is_denorm	= True;
		def.val_underflow	= False;
		def.val_overflow	= False;
		return def;
	endfunction

	

endpackage : types