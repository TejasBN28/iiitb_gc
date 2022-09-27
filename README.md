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
 - [7. Creating Custom Cell](#7-Creating-Custom-Cell)
 - [8. Physical Design](#8-Physical-Design)<br>
   - [8.1. Software Used](#81-Softwares-Used)
   - [8.2. Preperation for Running OpenLane](#82-Preperation-for-Running-OpenLane)
   - [8.3. Synthesis](#83-Synthesis)
   - [8.4. Floorplan](#84-Floorplan)
   - [8.5. Placement](#85-Placement)
   - [8.6. Clock Tree Synthesis](#86-Clock-Tree-Synthesis)
   - [8.7 Routing](#87-Routing)
 - [9. Results for Mid-Term Examination](#9-Results-for-Mid-Term-Examination)
   - [9.1. Post-Synthesis-Gate-Count-from-stat-command](#91-Post-Synthesis-Gate-Count-from-stat-command)
   - [9.2. Area-from-box-command](#92-Area-from-box-command)
   - [9.3. Performance using OpenSTA](#93-Performance-using-OpenSTA)
   - [9.4. Flip-Flop to Standard Cell ratio](#94-Flip-Flop-to-Standard-Cell-ratio)
   - [9.5. Power](#95-Power)
 - [Author](#10-Author)
 - [Acknowledgement](#11-Acknowledgement)
 - [Contact Information](#12-Contact-Information)
 - [References](#13-References)

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

# 7. Creating Custom Cell
First, clone the github repo containing the inverter and prepare for the next steps.
```
git clone https://github.com/nickson-jose/vsdstdcelldesign.git
cd vsdstdcelldesign
cp ./libs/sky130A.tech sky130A.tech
magic -T sky130A.tech sky130_inv.mag &
```
On typing the following commands, the following netlist will open.

<p align="center">
  <img src="/images/inv.png">
</p><br>

Now, to extract the spice netlist, type the following commands in the tcl console. Here, parasitic capacitances and resistances of the inverter is extracted by  `cthresh 0 rthresh 0`.
```
extract all
ext2spice cthresh 0 rthresh 0
ext2spice
```
<p align="center">
  <img src="/images/inv2.png">
</p><br>

The extracted spice model is shown below (which is edited to simulate the inverter).
```
* SPICE3 file created from sky130_inv.ext - technology: sky130A

.option scale=0.01u
.include ./libs/pshort.lib
.include ./libs/nshort.lib


M1001 Y A VGND VGND nshort_model.0 ad=1435 pd=152 as=1365 ps=148 w=35 l=23
M1000 Y A VPWR VPWR pshort_model.0 ad=1443 pd=152 as=1517 ps=156 w=37 l=23
VDD VPWR 0 3.3V
VSS VGND 0 0V
Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)
C0 Y VPWR 0.08fF
C1 A Y 0.02fF
C2 A VPWR 0.08fF
C3 Y VGND 0.18fF
C4 VPWR VGND 0.74fF


.tran 1n 20n
.control
run
.endc
.end
```
<p align="center">
  <img src="/images/inv3.png">
</p><br>

<p align="center">
  <img src="/images/inv4.png">
</p><br>

To get a grid and to ensure the ports are placed correctly we type the following command in the tcl console
```
grid 0.46um 0.34um 0.23um 0.17um
```
In Magic Layout window, first source the .mag file for the design (here inverter). Then Edit >> Text which opens up a dialogue box. Then do the steps shown in the below figure.

<p align="center">
  <img src="/images/inv6.png">
</p><br>

<p align="center">
  <img src="/images/inv7.png">
</p><br>

<p align="center">
  <img src="/images/inv8.png">
</p><br>

<p align="center">
  <img src="/images/inv9.png">
</p><br>

Now, to extract the lef file and save it, type the following command.
```
lef write
```
<p align="center">
  <img src="/images/inv5.png">
</p><br>

The extracted lef file is shown below.
```
VERSION 5.7 ;
  NOWIREEXTENSIONATPIN ON ;
  DIVIDERCHAR "/" ;
  BUSBITCHARS "[]" ;
MACRO sky130_vsdinv
  CLASS CORE ;
  FOREIGN sky130_vsdinv ;
  ORIGIN 0.000 0.000 ;
  SIZE 1.380 BY 2.720 ;
  SITE unithd ;
  PIN A
    DIRECTION INPUT ;
    USE SIGNAL ;
    ANTENNAGATEAREA 0.165600 ;
    PORT
      LAYER li1 ;
        RECT 0.060 1.180 0.510 1.690 ;
    END
  END A
  PIN Y
    DIRECTION OUTPUT ;
    USE SIGNAL ;
    ANTENNADIFFAREA 0.287800 ;
    PORT
      LAYER li1 ;
        RECT 0.760 1.960 1.100 2.330 ;
        RECT 0.880 1.690 1.050 1.960 ;
        RECT 0.880 1.180 1.330 1.690 ;
        RECT 0.880 0.760 1.050 1.180 ;
        RECT 0.780 0.410 1.130 0.760 ;
    END
  END Y
  PIN VPWR
    DIRECTION INOUT ;
    USE POWER ;
    PORT
      LAYER nwell ;
        RECT -0.200 1.140 1.570 3.040 ;
      LAYER li1 ;
        RECT -0.200 2.580 1.430 2.900 ;
        RECT 0.180 2.330 0.350 2.580 ;
        RECT 0.100 1.970 0.440 2.330 ;
      LAYER mcon ;
        RECT 0.230 2.640 0.400 2.810 ;
        RECT 1.000 2.650 1.170 2.820 ;
      LAYER met1 ;
        RECT -0.200 2.480 1.570 2.960 ;
    END
  END VPWR
  PIN VGND
    DIRECTION INOUT ;
    USE GROUND ;
    PORT
      LAYER li1 ;
        RECT 0.100 0.410 0.450 0.760 ;
        RECT 0.150 0.210 0.380 0.410 ;
        RECT 0.000 -0.150 1.460 0.210 ;
      LAYER mcon ;
        RECT 0.210 -0.090 0.380 0.080 ;
        RECT 1.050 -0.090 1.220 0.080 ;
      LAYER met1 ;
        RECT -0.110 -0.240 1.570 0.240 ;
    END
  END VGND
END sky130_vsdinv
END LIBRARY

```

# 8. Physical Design
## 8.1. Software Installation
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

## 8.2. Preperation for Running OpenLane 
 
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

## 8.3. Synthesis:

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

## 8.4. Floorplan

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

## 8.5. Placement

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

## 8.6. Clock Tree Synthesis
 
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


## 8.7. Routing
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

# 9. Results for Mid-Term Examination
## 9.1. Post Synthesis Gate Count from stat command
The post synthesis gate count for my design is 47 cells. 
<p align="center">
  <img src="/images/stat_tejasbn.png">
</p><br>

## 9.2. Area from box command
Area of the chip is 4384.215 sq micrometers.
<p align="center">
  <img src="/images/area_tejasbn.png">
</p><br>

## 9.3. Performance using OpenSTA
To find the performance of the chip, the netlist generated after the clock tree synthesis is considered. The generated netlist is analysed and is found  to contain 8 flipflops. Now, reg to reg path for all the flipflops are calculated using OpenSTA tool. Then, the reg to reg path with the worst slack is considered for calculating the performance. 

The steps followed are 
 - Invoke OpenSTA with the following commands.
   ```
   sudo make mount
   sta
   ```
 - Type the following commands to run the OpenSTA tool  for my design.
   ```
   read_liberty -max /home/tejasbn/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
   read_liberty -min /home/tejasbn/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
   read_verilog /home/tejasbn/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/iiitb_gc.v
   link_design iiitb_gc
   read_sdc /home/tejasbn/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/iiitb_gc.sdc
   read_spef /home/tejasbn/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/iiitb_gc.spef
   set_propagated_clock clk
   create_clock -name clk -period 10 {clk}
   report_checks -from _71_/CLK -to _76_/D
   ```
<p align="center">
  <img src="/images/performance_tejasbn.png">
</p><br>

From here, tsetup is 0.09 ns and path delay is 1.52ns

Now Tclk maximum = (0.09 + 1.52) ns = 1.61ns.
So, the chip performance is 621.118MHz.

## 9.4. Flip-Flop to Standard Cell ratio 
The total power consumed by the chip is 2.16 micro Watt
<p align="center">
  <img src="/images/stat_dff_tejasbn.png">
</p><br>

```
Flop ratio = Number of D Flip flops 
             ______________________
             Total Number of cells
```

```
dfxtp_2 = 8,
Number of cells = 47,
Flop ratio = 8/47 = 0.1702 = 17.02%
```

## 9.5. Power 
The total power consumed by the chip is 2.17 micro Watt. 
 - Internal Power = 1.29 micro Watt
 - Switching Power = 0.879 micro Watt
 - Leakage Power = 0.199 nano Watt
 - 
<p align="center">
  <img src="/images/power_tejasbn.png">
</p><br>

# 10. Author

- **Tejas B N**

# 11. Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.
- Madhav Rao, Associate Professor, IIIT Bangalore
- V N Muralidhara, Associate Professor, IIIT Bangalore


# 12. Contact Information

- Tejas B N, Postgraduate Student, International Institute of Information Technology, Bangalore  bntejas@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com


# 13. *References*
[^1]: Varun Akula, Dr. Vishwani D. Agrawal, James J. Danaher. [Comparison of power consumption of 4-bit binary counters with various state encodings including gray and one-hot codes](https://www.eng.auburn.edu/~vagrawal/COURSE/E6270_Spr15/PROJECT/REPORTS/Varun%20Akula%20Project%20Report.pdf). Auburn University

[^2]: [8-bit Gray Counter](https://www.asic-world.com/examples/verilog/gray.html) from ASIC World for the verilog design of gray counter.

[^3]: Icarus Verilog - [iverilog](http://iverilog.icarus.com/)

[^4]: GTK Wave [documentation](http://gtkwave.sourceforge.net/gtkwave.pdf)

[^5]: [Yosys](https://yosyshq.net/yosys/) synthesis tool
