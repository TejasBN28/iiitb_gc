# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). <br><br>
*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

# Table of contents
 - [Introduction](#1-Introduction)
 - [Application of Gray Counter](#2-Application-of-Gray-Counter)
 - [Verilog Implementation of Gray Code Counter](#3-Verilog-Implementation-of-Gray-Code-Counter)
 - [Functional Simulation](#4-Functional-Simulation)
 - [Synthesis](#5-Synthesis)
 - [Gate Level Simulation GLS](#6-Gate-Level-Simulation-GLS)
 - [Physical Design](#6-Physical-Design)

# 1. Introduction
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern (0 -> 1 -> 3 -> 2 -> 6 -> 7 ......... ). Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter.[^1] 


# 2. Application of Gray Counter

The gray code counter has various applications including analog to digital converters, error detection and correction in memory and digital communication, genetic algorithms, DNA computing, bio-informatics, optical information processing, quantum computations and nanotechnology.


# 3. Verilog Implementation of Gray Code Counter
The Gray Code counter block diagram is shown below. [^2]<br>
 <p align="center">
  <img width="350" height="200" src="/images/block_diagram.PNG">
</p><br>
The digital circuit takes clock, enable and reset as input. It generates an 8-bit gray code sequence at every positive clock edge. The port description of the gray code counter is shown in Table below. <br>


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

# 5. Synthesis
The software used to run gate level synthesis is Yosys. Yosys is a framework for Verilog RTL synthesis. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains. Yosys can be adapted to perform any synthesis job by combining the existing passes (algorithms) using synthesis scripts and adding additional passes as needed by extending the Yosys C++ code base. [^5]

```
git clone https://github.com/YosysHQ/yosys.git
make
sudo make install make test
```

The commands to run synthesis in yosys are given below. First create an yosys script `yosys_run.sh` and paste the below commands.
```
read_liberty -lib lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog iiitb_gc.v
synth -top iiitb_gc	
dfflibmap -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
flatten
write_verilog -noattr iiitb_gc_synth.v
stat
show
```
Then, open terminal in the folder iiitb_gc and type the below command.
```
yosys -s yosys_run.sh
```
On running the yosys script, we get the following output:
<p align="center">
  <img src="/images/Synth_ckt.png">
</p><br><br>
<p align="center">
  <img src="/images/Stat.png">
</p><br>

# 6. Gate Level Simulation GLS
GLS stands for gate level simulation. When we write the RTL code, we test it by giving it some stimulus through the testbench and check it for the desired specifications. Similarly, we run the netlist as the design under test (dut) with the same testbench. Gate level simulation is done to verify the logical correctness of the design after synthesis. Also, it ensures the timing of the design. <br>
Commands to run the GLS are given below.
```
iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 iiitb_gc_synth.v iiitb_gc_tb.v verilog_model/primitives.v verilog_model/sky130_fd_sc_hd.v -o iiitb_gc
./iiitb_gc
gtkwave iiitb_gc.vcd
```
Few count sequence of the gray code counter is displayed in below. At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence.
<p align="center">
  <img src="/images/waveform_post_GLS.png">
</p><br>

# 6. Physical Design

## Openlane
OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, CVC, SPEF-Extractor, CU-GR, Klayout and a number of custom scripts for design exploration and optimization. The flow performs full ASIC implementation steps from RTL all the way down to GDSII.

more at https://github.com/The-OpenROAD-Project/OpenLane
## Installation instructions 
```
$   apt install -y build-essential python3 python3-venv python3-pip
```
Docker installation process: https://docs.docker.com/engine/install/ubuntu/

goto home directory->
```
$   git clone https://github.com/The-OpenROAD-Project/OpenLane.git
$   cd OpenLane/
$   sudo make
```
To test the open lane
```
$ sudo make test
```
It takes approximate time of 5min to complete. After 43 steps, if it ended with saying **Basic test passed** then open lane installed succesfully.

## Magic
Magic is a venerable VLSI layout tool, written in the 1980's at Berkeley by John Ousterhout, now famous primarily for writing the scripting interpreter language Tcl. Due largely in part to its liberal Berkeley open-source license, magic has remained popular with universities and small companies. The open-source license has allowed VLSI engineers with a bent toward programming to implement clever ideas and help magic stay abreast of fabrication technology. However, it is the well thought-out core algorithms which lend to magic the greatest part of its popularity. Magic is widely cited as being the easiest tool to use for circuit layout, even for people who ultimately rely on commercial tools for their product design flow.

More about magic at http://opencircuitdesign.com/magic/index.html

Run following commands one by one to fulfill the system requirement.

```
$   sudo apt-get install m4
$   sudo apt-get install tcsh
$   sudo apt-get install csh
$   sudo apt-get install libx11-dev
$   sudo apt-get install tcl-dev tk-dev
$   sudo apt-get install libcairo2-dev
$   sudo apt-get install mesa-common-dev libglu1-mesa-dev
$   sudo apt-get install libncurses-dev
```
**To install magic**
goto home directory

```
$   git clone https://github.com/RTimothyEdwards/magic
$   cd magic/
$   ./configure
$   sudo make
$   sudo make install
```
type **magic** terminal to check whether it installed succesfully or not. type **exit** to exit magic.

## Running OpenLane 
 
Download the config.json file and place it in the `OpenLane/designs/iiitb_gc` folder. The `config.json` file is given below as well.
```
{
    "DESIGN_NAME": "iiitb_gc",
    "VERILOG_FILES": "dir::src/iiitb_gc.v",
    "CLOCK_PORT": "clk",
    "CLOCK_NET": "clk",
    "GLB_RESIZER_TIMING_OPTIMIZATIONS": true,
    "CLOCK_PERIOD": 24,
    "pdk::sky130*": {
        "SYNTH_MAX_FANOUT": 6,
        "FP_CORE_UTIL": 35,
        "scl::sky130_fd_sc_hd": {
            "FP_CORE_UTIL": 30
           
        }
    },
   "LIB_SYNTH": "dir::src/sky130_fd_sc_hd__typical.lib",
   "LIB_FASTEST": "dir::src/sky130_fd_sc_hd__fast.lib",
   "LIB_SLOWEST": "dir::src/sky130_fd_sc_hd__slow.lib",
   "LIB_TYPICAL": "dir::src/sky130_fd_sc_hd__typical.lib",
   "TEST_EXTERNAL_GLOB": "dir::../iiitb_gc/src/*"
}
```
Now, paste the verilog code `iiitb_gc.v`, `sky130_vsdinv.lef`, `sky130_fd_sc_hd__fast.lib`,  `sky130_fd_sc_hd__slow.lib` and `sky130_fd_sc_hd__typical.lib`inside the folder `OpenLane/designs/iiitb_gc/src`


To invoke OpenLane, type the following commands. On typing the following commands, `runs` folder is created inside the `iiitb_gc` folder. 
```
cd OpenLane
make mount
./flow.tcl -interactive
prep -design iiitb_gc
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
```
<p align="center">
  <img src="/images/invoking_open.png">
</p><br>

Now, to run synthesis, type the following command
```
run_synthesis
```
<p align="center">
  <img src="/images/stats_.png">
</p><br>

<p align="center">
  <img src="/images/synth.png">
</p><br>

The synthesized netlist is present in the results folder and the stats are present in the reports folder. 



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

[^2]: [8-bit Gray Counter](https://www.asic-world.com/examples/verilog/gray.html) from ASIC World for the verilog design of gray counter.

[^3]: Icarus Verilog - [iverilog](http://iverilog.icarus.com/)

[^4]: GTK Wave [documentation](http://gtkwave.sourceforge.net/gtkwave.pdf)

[^5]: [Yosys](https://yosyshq.net/yosys/) synthesis tool
