## CAD-for-VLSI-Systems-CS6230

### Objective:
Design and implement an area-efficient pipelined module supporting unary operators (activation functions) for transforming data streams using cfloat8_1_5_2 datatype [(link)]([https://www.example.com](https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf)).

### Functionality:
The module supports the following unary operators: tanh(x), sigmoid(x), leaky_ReLu(x), SeLu(x).

### Implementation:

1. Utilizes the smallest building blocks for each function, allowing reusability.
2. Pipelining implemented to ensure full bandwidth utilization without stalls.
3. The design accommodates the use of a single unary function for a complete data stream.
4. Handles datatype cfloat8_1_5_2 efficiently for the specified operations.

### Notes:

1. The module is designed to seamlessly transform data streams using the specified activation functions without compromising bandwidth.
2. Efficiently handles the complex computations involving exp(-x) for the supported unary operators.
3. Implementation is optimized for the targeted datatype, ensuring accurate and rapid transformation of data streams.
