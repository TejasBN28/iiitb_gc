# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). 

## Description
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern. Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter.[^1] 

## Gray Code Counter Verilog Implementation  
The Gray Code counter block diagram is shown below. <br>
 <p align="center">
  <img width="350" height="200" src="/images/block_diagram.PNG">
</p><br>
The digital circuit takes clock, enable and reset as input. It generates an 8-bit gray code sequence at every positive clock edge. The port description of the gray code counter is shown in Table below.

| PORT NAME | PORT TYPE | DESCRIPTION |
|-----------|-----------|-------------|
| clk       | input     | Clock Input |
| enable | input | Enables the counter to count on positive clk edge |
| reset | input | Resets the counter to 0 |
| gray_count[7:0] | output | 8-bit gray code output |

<br>Few count sequence of the gray code counter is displayed in below. At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence. [^2]
	
  <p align="center">
  <img src="/images/waveform.png">
</p><br>

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

[^2]: [8-bit Gray Counter](https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-examples/horizontal/ver-gray-counter.html) from INTEL FPGA Support Resources for the verilog design of gray counter.
