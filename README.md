## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using [cfloat8_1_5_2 datatypeCfloat8](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)


### Functionality:
The module supports the following unary operators: SeLu(x), Leaky_ReLU(x) , Sigmoid(x),  Tanh(x).

### Implementation:
1. SeLu(x) is defined as(approx):
         f(x) = 1.0507\*x , if x>0
         \[f(x) = 1.0507\*1.6733\*(e^{x}-1)\] , if x<0

   Since Cfloat_8_152 has only two mantissa bits, we approximate the constants to 1 and 1.75.

2. Leaky_ReLU(x) is defined as:
         f(x) = x , if x>0
         f(x) = 0.01\*x , if x<0
   
   An approximate representation of 0.01 in Cfloat_8_152 is 2^-7 + 2^-9 (~0.0097). This is 2^-7 (1.25)

3. Sigmoid(x) is defined as:
         f(x) = \frac{1}{1 + e^{-x}}
   
4. Tanh(x) is defined as:
         \[f(x) =  \frac{e^{x}-e^{-x}}{e^{x} + e^{-x}} \]


