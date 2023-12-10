## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using [cfloat8_1_5_2](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)


### Functionality:
The module supports the following unary operators: SeLu(x), Leaky_ReLU(x) , Sigmoid(x),  Tanh(x).

1. **SeLu(x):**

   ![Selu](imgs/selu.png)
   - Since the datatype only has 2 mantissa bits, we approximate the constants to 1(1.00) and 1.75(1.11) .

2. **Leaky ReLU(x):**
   
   ![Leaky_relu](imgs/leaky.png)
    -  0.01 can be approximately represented as
   ![leakyval](imgs/leakyval.png)
    -  This allows us to multiply it with inputs.
3. **Sigmoid(x):**
   
   ![Sigmoid Formula](imgs/sigmoid.png)

4. **Tanh(x):**
   
   ![tanh](imgs/tanh.png)


### Implementation:
We can see that ![exp_1](https://latex2image-output.s3.amazonaws.com/img-aWkXPz7WZuRP.png) occurs in both SELU and sigmoid. We exploit this to use the same logic to perform computations for both these functions. In [exp_x_1_p](approx/exp_x_1_p.txt) and [exp_x_1_n](approx/exp_x_1_n.txt) we have the values of ![exp_1](https://latex2image-output.s3.amazonaws.com/img-aWkXPz7WZuRP.png) and how it compares to input x and the "order term" ![2pown](https://latex2image-output.s3.amazonaws.com/img-Um2UwRyJaJ5P.png). For order <-4, for both +ve and -ve x,  ![exp_x_1approx](https://latex2image-output.s3.amazonaws.com/img-fQ9CRyad6Kff.png). For high order(>4) +ve x , it overflows and for high order -ve x, it is approximately -1. In the intervening orders, an approximate value is chosen for each possible combination. Note that for a denormal the output would be the input itself (almost every case)  as it is a small number.
This value is used in the calculation of SELU and sigmoid. For sigmoid, we add this value(note that is ![note](https://latex2image-output.s3.amazonaws.com/img-huNZ3fpnT8rx.png) ) to 2 and take the inverse of the sum as output.

In case of [tanh](approx/tanh.txt), we observe that for order<-1, [tanh_approx](https://latex2image-output.s3.amazonaws.com/img-kWVCr2tKEdr5.png) and for order>0,  [tanh_app2](https://latex2image-output.s3.amazonaws.com/img-ACd89ngT5Gp2.png). This helps in keeping the logic simple as only 2 orders require a look-up table. 

In case of ReLU, for +ve x, the output is x itself and for -ve x, the output can be calculated by the multiplication shown above.




### TestBench Usage:
```bash
$ ./shrtct testbench mkTestCON
```
Replace testbench with the name of your bsv and mkTestCON with your TB's top module.
