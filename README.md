# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). <br><br>
*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

# Table of contents
 - [1. Introduction](#1-Introduction)
 - [2. Application of Gray Counter](#2-Application-of-Gray-Counter)
 - [3. Gray Code Counter - Verilog Implementation](#3-Gray-Code-Counter-Verilog-Implementation)
 - [4. Functional Simulation](#4-Functional-Simulation)
 - [5. Synthesis](#5-Synthesis)
 - [6. Gate Level Simulation - GLS](#6-Gate-Level-Simulation-GLS)

# 1. Introduction
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern (0 -> 1 -> 3 -> 2 -> 6 -> 7 ......... ). Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter.[^1] 


# 2. Application of Gray Counter

The gray code counter has various applications including analog to digital converters, error detection and correction in memory and digital communication, genetic algorithms, DNA computing, bio-informatics, optical information processing, quantum computations and nanotechnology.


# 3. Gray Code Counter - Verilog Implementation  
The Gray Code counter block diagram is shown below. [^2]<br>
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



# 4. Functional Simulation
### Softwares used
### - **iverilog**
Icarus Verilog is a Verilog simulation and synthesis tool. It operates as a compiler, compiling source code written in Verilog (IEEE-1364) into some target format. [^3]

### - **gtkwave**
GTKWave is a fully featured GTK+ based wave viewer for Unix, Win32, and Mac OSX which reads LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog VCD/EVCD files and allows their viewing. [^4]

### 1) Installing necessary softwares:
  ```
  sudo apt-get install git 
  sudo apt-get install iverilog 
  sudo apt-get install gtkwave 
  ```

### 2) Executing the Project:
  ```
  git clone https://github.com/TejasBN28/iiitb_gc.git
  cd iiitb_gc
  iverilog iiitb_gc.v iiitb_gc_tb.v -o iiitb_gc
  ./iiitb_gc
  gtkwave iiitb_gc.vcd
```

<br>Few count sequence of the gray code counter is displayed in below. At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence.
	
  <p align="center">
  <img src="/images/waveform.png">
</p><br>


# Author

- **Tejas B N**

# Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.
- Madhav Rao, Associate Professor, IIIT Bangalore
- V N Muralidhara, Associate Professor, IIIT Bangalore


# Contact Information

- Tejas B N, Postgraduate Student, International Institute of Information Technology, Bangalore  bntejas@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com


# *References*
[^1]: Varun Akula, Dr. Vishwani D. Agrawal, James J. Danaher. [Comparison of power consumption of 4-bit binary counters with various state encodings including gray and one-hot codes](https://www.eng.auburn.edu/~vagrawal/COURSE/E6270_Spr15/PROJECT/REPORTS/Varun%20Akula%20Project%20Report.pdf). Auburn University

[^2]: [8-bit Gray Counter](https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-examples/horizontal/ver-gray-counter.html) from INTEL FPGA Support Resources for the verilog design of gray counter.

[^3]: Icarus Verilog - [iverilog](http://iverilog.icarus.com/)

[^4]: GTK Wave [documentation](http://gtkwave.sourceforge.net/gtkwave.pdf)
