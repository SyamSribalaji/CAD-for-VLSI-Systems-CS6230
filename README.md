## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using [cfloat8_1_5_2](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)


### Functionality:
The module supports the following unary operators: SeLu(x), Leaky_ReLU(x) , Sigmoid(x),  Tanh(x).

### Implementation:
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

### Binary Multiplication:

### TestBench Usage:
```bash
$ ./shrtct testbench mkTestCON
```
Replace testbench with the name of your bsv and mkTestCON with your TB's top module.
