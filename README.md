## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using cfloat8_1_5_2 datatype <a href="[https://example.com](https://www.example.com](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)" style="color: blue;">(Cfloat8)</a>


### Functionality:
The module supports the following unary operators: tanh(x), sigmoid(x), leaky_ReLu(x), SeLu(x).

### Implementation:

1. Utilizes the smallest building blocks for each function and allowing reusability.
2. Pipelining is implemented to ensure full bandwidth utilization without stalls.
3. The design accommodates the use of a single unary function for a complete data stream.

### Notes:

1. The module is designed to seamlessly transform data streams using the specified activation functions without compromising bandwidth.
2. Efficiently handles the complex computations involving exp(-x) for the supported unary operators.
3. Implementation is optimized for the targeted datatype, ensuring accurate and rapid transformation of data streams.
