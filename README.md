## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using [cfloat8_1_5_2](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)


### Functionality:
The module supports the following unary operators: SeLu(x), Leaky_ReLU(x) , Sigmoid(x),  Tanh(x).

### Implementation:
1. **SeLu(x):**
   - The formula for SeLu(x) should be:
     \[
     f(x) = 
     \begin{cases} 
     1.0507x, & \text{if } x > 0 \\
     1.0507 \times 1.75 \times (e^{x} - 1), & \text{if } x \leq 0
     \end{cases}
     \]

2. **Leaky ReLU(x):**
   - The description mentions an approximate representation of \(0.01\) in Cfloat\_8\_152 as \(2^{-7} + 2^{-8}\), but it states that this is approximately \(1.25\). It seems there might be a typo or confusion here. The correct approximate representation for \(0.01\) in Cfloat\_8\_152 would be \(2^{-7} + 2^{-8}\) (not \(1.25\)).

3. **Sigmoid(x):**
   - The formula for Sigmoid(x) is given as:
     \[
     f(x) = \frac{1}{1 + e^{-x}}
     \]

4. **Tanh(x):**
   - The formula for Tanh(x) is given as:
     \[
     f(x) = \frac{e^{x}-e^{-x}}{e^{x} + e^{-x}}
     \]



