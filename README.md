# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). 

## Glance at Gray Counter
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern. Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter.[^1]

## Gray Code Counter Verilog Implementation
The Gray Code counter block diagram is shown in Fig. 1. 


The digital circuit takes clock, enable and reset as input. It generates an 8-bit gray code sequence at every positive clock edge. The port description of the gray code counter is shown in Table I. 

## Steps to execute the Project:

### 1) Installing necessary softwares:
  ```
  $ sudo apt-get install git 
  
  $ sudo apt-get install iverilog 
  
  $ sudo apt-get install gtkwave 
  ```

### 2) Functional Simulation:
  ```
  $ git clone https://github.com/TejasBN28/iiitb_gc.git
  
  $ cd iiitb_gc
  
  $ iverilog iiitb_gc.v iiitb_gc_tb.v -o iiitb_gc
  
  $ ./iiitb_gc
  
  $ gtkwave iiitb_gc.vcd
```


## *References*
[^1]: Varun Akula, Dr. Vishwani D. Agrawal, James J. Danaher. [Comparison of power consumption of 4-bit binary counters with various state encodings including gray and one-hot codes](https://www.eng.auburn.edu/~vagrawal/COURSE/E6270_Spr15/PROJECT/REPORTS/Varun%20Akula%20Project%20Report.pdf). Auburn University

[^2]
