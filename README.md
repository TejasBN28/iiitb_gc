# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). <br><br>
*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

# Table of contents
 - [1. Introduction](#1-Introduction)<br>
 - [2. Application of Gray Counter](#2-Application-of-Gray-Counter)<br>
 - [3. Verilog Implementation of Gray Code Counter](#3-Verilog-Implementation-of-Gray-Code-Counter)<br>
 - [4. Functional Simulation](#4-Functional-Simulation)<br>
   - [4.1. Softwares Used](#41-Softwares-Used)<br>
   - [4.2. Simulation Results](#42-Simulation-Results)<br>
 - [5. Synthesis](#5-Synthesis)<br>
   - [5.1. Softwares Used](#51-Softwares-Used)<br>
   - [5.2. Run Synthesis](#52-Run-Synthesis)<br>
 - [6. Gate Level Simulation GLS](#6-Gate-Level-Simulation-GLS)<br>
 - [7. Physical Design](#6-Physical-Design)<br>
   - [7.1. Software Used](#71-Softwares-Used)
   - [7.2. Preperation for Running OpenLane](#72-Preperation-for-Running-OpenLane)
   - [7.3. Synthesis](#73-Synthesis)
   - [7.4. Floorplan](#74-Floorplan)
   - [7.5. Placement](#75-Placement)
   - [7.6. Clock Tree Synthesis](#76-Clock-Tree-Synthesis)
   - [7.7 Routing](#77-Routing)
 - [Author](Author)
 - [Acknowledgement](Acknowledgement)
 - [Contact Information](Contact-Information)
 - [References](References)

# 1. Introduction
Gray code counter is a digital counter that counts such that each successive bit patterns differs by only one bit. Unlike normal counters, there are no glitches in the count pattern (0 -> 1 -> 3 -> 2 -> 6 -> 7 ......... ). Since switching is less in gray code counters (i.e., exactly one-bit switches in one clock cycle), the power consumption of the gray code counter is significantly less compared to the normal counter.[^1] 


# 2. Application of Gray Counter
Gray code finds application in multiple electromechanical applications due to its error resilient property. This is achieved due to the single bit change from one code word to the adjacent next code word. This article lists down few more applications of Gray code. 
 - Since the Gray code reduces the likelihood of mistakes, it is employed in the transmission of digital signals.
 - In angle-measuring equipment, the Gray code is chosen over the simple binary code. The likelihood of an angle being misread is virtually eliminated when using the Gray code, compared to when using straight binary to express the angle. The Gray code's cyclic characteristic comes in handy for this application.
 - The axes of Karnaugh maps, a graphical method for minimising Boolean equations, are labelled using the Gray code.
 - Gray codes are used to access programme memory in computers in a way that uses the least amount of electricity. Less address lines are changing state as the programme counter advances as a result.
 - Given that mutations in the code often only allow for gradual modifications, grey codes are also particularly helpful in genetic algorithms. On occasion, though, a little adjustment might cause a significant jump, giving rise to novel traits.
 - The gray code counter has applications in analog to digital converters. 

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
## 4.1. Softwares used
### - **iverilog**
Icarus Verilog is a Verilog simulation and synthesis tool. It operates as a compiler, compiling source code written in Verilog (IEEE-1364) into some target format. [^3]

### - **gtkwave**
GTKWave is a fully featured GTK+ based wave viewer for Unix, Win32, and Mac OSX which reads LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog VCD/EVCD files and allows their viewing. [^4]

### Installing necessary softwares:
  ```
  sudo apt-get install git 
  sudo apt-get install iverilog 
  sudo apt-get install gtkwave 
  ```
 ## 4.2. Simulation Results
 ### Executing the Project:
  ```
  git clone https://github.com/TejasBN28/iiitb_gc.git
  cd iiitb_gc
  iverilog iiitb_gc.v iiitb_gc_tb.v -o iiitb_gc
  ./iiitb_gc
  gtkwave iiitb_gc.vcd
```

<br>Few count sequence of the gray code counter is displayed in below. At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence.
<p align="center">
  <img src="/images/p1.png">
</p><br>
<p align="center">
  <img src="/images/waveform.png">
</p><br>

# 5. Synthesis
## 5.1. Softwares used
### - **Yosys**
The software used to run gate level synthesis is Yosys. Yosys is a framework for Verilog RTL synthesis. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains. Yosys can be adapted to perform any synthesis job by combining the existing passes (algorithms) using synthesis scripts and adding additional passes as needed by extending the Yosys C++ code base. [^5]
#### **Installing Prerequsites for Yosys**
 ```
 sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev
```
#### **Installing Latest Version of Yosys**
```
git clone https://github.com/YosysHQ/yosys.git
make
sudo make install 
make test
```
## 5.2. Run Synthesis
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
  <img src="/images/p2.png">
</p><br>
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
<p align="center">
  <img src="/images/p3.png">
</p><br>

Few count sequence of the gray code counter is displayed in below. At the first positive edge of the clock, the counter resets to 0x00. From the second clock onwards, the counter starts to count in gray code sequence.
<p align="center">
  <img src="/images/waveform_post_GLS.png">
</p><br>

# 7. Physical Design
## 7.1 Software Installation
### Openlane
[OpenLane](https://github.com/The-OpenROAD-Project/OpenLane) is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, CVC, SPEF-Extractor, CU-GR, Klayout and a number of custom scripts for design exploration and optimization. The flow performs full ASIC implementation steps from RTL all the way down to GDSII.

### Installation instructions 
```
sudo apt install -y build-essential python3 python3-venv python3-pip
```
### Docker
Docker installation process for ubuntu is explained in this link: https://docs.docker.com/engine/install/ubuntu/. Alternatively, the following commands install the docker.
```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
sudo make
```
To test the open lane
```
sudo make test
```
It takes approximate time of 5 minutes to complete. After 43 steps, if it ended with saying **Basic test passed** then open lane installed succesfully.

### Magic
[Magic](http://opencircuitdesign.com/magic/index.html) is a venerable VLSI layout tool, written in the 1980's at Berkeley by John Ousterhout, now famous primarily for writing the scripting interpreter language Tcl. Due largely in part to its liberal Berkeley open-source license, magic has remained popular with universities and small companies. The open-source license has allowed VLSI engineers with a bent toward programming to implement clever ideas and help magic stay abreast of fabrication technology. However, it is the well thought-out core algorithms which lend to magic the greatest part of its popularity. Magic is widely cited as being the easiest tool to use for circuit layout, even for people who ultimately rely on commercial tools for their product design flow

Run following commands one by one to fulfill the system requirement.
#### Prerequisites for magic
```
sudo apt-get install m4
sudo apt-get install tcsh
sudo apt-get install csh
sudo apt-get install libx11-dev
sudo apt-get install tcl-dev tk-dev
sudo apt-get install libcairo2-dev
sudo apt-get install mesa-common-dev libglu1-mesa-dev
sudo apt-get install libncurses-dev
```
#### Install magic
```
git clone https://github.com/RTimothyEdwards/magic
cd magic/
./configure
sudo make
sudo make install
```
type `magic` terminal to check whether it installed succesfully or not. Type `exit` to exit magic.

## 7.2. Preperation for Running OpenLane 
 
Download the config.json file and place it in the `OpenLane/designs/iiitb_gc` folder. The `config.json` file is given below as well.
```
{
    "DESIGN_NAME": "iiitb_gc",
    "VERILOG_FILES": "dir::src/iiitb_gc.v",
    "CLOCK_PORT": "clkin",
    "CLOCK_NET": "clkin",
    "GLB_RESIZER_TIMING_OPTIMIZATIONS": true,
    "CLOCK_PERIOD": 65,
    "PL_TARGET_DENSITY": 0.7,
    "FP_SIZING" : "relative",
    "pdk::sky130*": {
        "FP_CORE_UTIL": 30,
        "scl::sky130_fd_sc_hd": {
            "FP_CORE_UTIL": 20
        }
    },
    
    "LIB_SYNTH": "dir::src/sky130_fd_sc_hd__typical.lib",
    "LIB_FASTEST": "dir::src/sky130_fd_sc_hd__fast.lib",
    "LIB_SLOWEST": "dir::src/sky130_fd_sc_hd__slow.lib",
    "LIB_TYPICAL": "dir::src/sky130_fd_sc_hd__typical.lib",  
    "TEST_EXTERNAL_GLOB": "dir::/src/*"

}
```
Now, paste the verilog code `iiitb_gc.v`, `sky130_vsdinv.lef`, `sky130_fd_sc_hd__fast.lib`,  `sky130_fd_sc_hd__slow.lib` and `sky130_fd_sc_hd__typical.lib`inside the folder `OpenLane/designs/iiitb_gc/src`

<p align="center">
  <img src="/images/p4.png">
</p><br>
<p align="center">
  <img src="/images/p5.png">
</p><br>

To invoke OpenLane, type the following commands. On typing the following commands, `runs` folder is created inside the `iiitb_gc` folder. 
```
cd OpenLane
make mount
./flow.tcl -interactive
prep -design iiitb_gc
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs
```
<p align="center">
  <img src="/images/invoking_openlane.png">
</p><br>

Now, we can observe that the `sky130_vsdinv` is included in `merged.nom.lef` file.
<p align="center">
  <img src="/images/merged.png">
</p><br>

## 7.3. Synthesis:

Now, to run synthesis, type the following command
```
run_synthesis
```
<p align="center">
  <img src="/images/synth.png">
</p><br>

The synthesized netlist is present in the results folder and the stats are present in the reports folder. 

<p align="center">
  <img src="/images/stats_.png">
</p><br>


Here, we notice that our custom cell `sky130_vsdinv` is displayed in the netlist generated.
<p align="center">
  <img src="/images/prs.png">
</p><br>

Also, sta report post synthesis can be viewed by going to the location `logs\synthesis\2-sta.log`

<p align="center">
  <img src="/images/slack_synth.png">
</p><br>

## 7.4. Floorplan

The next step is to run `floorplan` and `placement`. Type the following commands.
```
run_floorplan
```
<p align="center">
  <img src="/images/flpl.png">
</p><br>

The floorplan can be viewed by typing the following command.
```
magic -T /home/tejasbn/Desktop/OpenLane/pdks/volare/sky130/versions/44a43c23c81b45b8e774ae7a84899a5a778b6b0b/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read iiitb_gc.def &
```
<p align="center">
  <img src="/images/e1.png">
</p><br>
<p align="center">
  <img src="/images/fp.png">
</p><br>

Also, Die Area and Core Area can be viewed in the `reports/floorplan` directory.
<p align="center">
  <img src="/images/die_area.png">
</p><br>
<p align="center">
  <img src="/images/core_area.png">
</p><br>

## 7.5. Placement

The placement can be viewed by typing the following command.
```
run_placement
```
The placement can be viewed by typing the following command.
```
magic -T /home/tejasbn/Desktop/OpenLane/pdks/volare/sky130/versions/44a43c23c81b45b8e774ae7a84899a5a778b6b0b/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read iiitb_gc.def &
```
<p align="center">
  <img src="/images/e2.png">
</p><br>

<p align="center">
  <img src="/images/pl1.png">
</p><br>

<p align="center">
  <img src="/images/pl2.png">
</p><br>

<p align="center">
  <img src="/images/pl5.png">
</p><br>

## 7.6. Clock Tree Synthesis
 
The next step is to run run clock tree synthesis. The CTS run adds clock buffers in therefore buffer delays come into picture and our analysis from here on deals with real clocks. To run clock tree synthesis, type the following commands
```
run_cts
```

<p align="center">
  <img src="/images/cts.png">
</p><br>

The netlist with clock buffers can be viewed by going to the location `results\cts\iiitb_gc.v`

Also, sta report post synthesis can be viewed by going to the location `logs\synthesis\12-cts.log`
<p align="center">
  <img src="/images/cts_sta.png">
</p><br>


## 7.7. Routing
The command to run routing is 
```
run_routing
```
<p align="center">
  <img src="/images/rc.png">
</p><br>


<p align="center">
  <img src="/images/rout.png">
</p><br>

<p align="center">
  <img src="/images/rout2.png">
</p><br>

ALso, `sky130_vsdinv` can be viewed in the routing layout.
<p align="center">
  <img src="/images/vsdinv_postrouting.png">
</p><br>

Area of the chip is 4384.215 sq micrometers.
<p align="center">
  <img src="/images/area.png">
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

[^2]: [8-bit Gray Counter](https://www.asic-world.com/examples/verilog/gray.html) from ASIC World for the verilog design of gray counter.

[^3]: Icarus Verilog - [iverilog](http://iverilog.icarus.com/)

[^4]: GTK Wave [documentation](http://gtkwave.sourceforge.net/gtkwave.pdf)

[^5]: [Yosys](https://yosyshq.net/yosys/) synthesis tool
