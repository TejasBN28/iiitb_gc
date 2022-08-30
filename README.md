# iiitb_gc - gray counter
The focus of this project is to implement an 8-bit gray code counter in skywater 130nm and determine its functional, pre-layout and post layout characteristics (namely power, performance and area). <br><br>
*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

# Table of contents
 - [1. Introduction](#1-Introduction)<br><br>
 - [2. Application of Gray Counter](#2-Application-of-Gray-Counter)<br><br>
 - [3. Verilog Implementation of Gray Code Counter](#3-Verilog-Implementation-of-Gray-Code-Counter)<br><br>
 - [4. Functional Simulation](#4-Functional-Simulation)<br>
   - [4.1. Softwares Used](#41-Softwares-Used)<br>
   - [4.2. Simulation Results](#42-Simulation-Results)<br><br>
 - [5. Synthesis](#5-Synthesis)<br>
   - [5.1. Softwares Used](#51-Softwares-Used)<br>
   - [5.2. Run Synthesis](#52-Run-Synthesis)<br><br>
 - [6. Gate Level Simulation GLS](#6-Gate-Level-Simulation-GLS)<br><br>
 - [7. Physical Design](#6-Physical-Design)<br><br>

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
add_lefs -src $lefs
```
<p align="center">
  <img src="/images/invoking_openlane.png">
</p><br>

## Synthesis:

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

```
/* Generated by Yosys 0.12+45 (git sha1 UNKNOWN, gcc 8.3.1 -fPIC -Os) */

module iiitb_gc(clk, enable, reset, gray_count);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  wire _23_;
  wire _24_;
  wire _25_;
  wire _26_;
  wire _27_;
  wire _28_;
  wire _29_;
  wire _30_;
  wire _31_;
  input clk;
  wire \count[0] ;
  wire \count[1] ;
  wire \count[2] ;
  wire \count[3] ;
  wire \count[4] ;
  wire \count[5] ;
  wire \count[6] ;
  input enable;
  output [7:0] gray_count;
  input reset;
  sky130_fd_sc_hd__xor2_2 _32_ (
    .A(\count[1] ),
    .B(\count[0] ),
    .X(gray_count[0])
  );
  sky130_fd_sc_hd__xor2_2 _33_ (
    .A(\count[2] ),
    .B(\count[1] ),
    .X(gray_count[1])
  );
  sky130_fd_sc_hd__nor2_2 _34_ (
    .A(\count[3] ),
    .B(\count[2] ),
    .Y(_08_)
  );
  sky130_fd_sc_hd__and2_2 _35_ (
    .A(\count[3] ),
    .B(\count[2] ),
    .X(_09_)
  );
  sky130_fd_sc_hd__buf_1 _36_ (
    .A(_09_),
    .X(_10_)
  );
  sky130_fd_sc_hd__nor2_2 _37_ (
    .A(_08_),
    .B(_10_),
    .Y(gray_count[2])
  );
  sky130_fd_sc_hd__xor2_2 _38_ (
    .A(\count[4] ),
    .B(\count[3] ),
    .X(gray_count[3])
  );
  sky130_fd_sc_hd__nor2_2 _39_ (
    .A(\count[5] ),
    .B(\count[4] ),
    .Y(_11_)
  );
  sky130_fd_sc_hd__and2_2 _40_ (
    .A(\count[5] ),
    .B(\count[4] ),
    .X(_12_)
  );
  sky130_fd_sc_hd__nor2_2 _41_ (
    .A(_11_),
    .B(_12_),
    .Y(gray_count[4])
  );
  sky130_fd_sc_hd__xor2_2 _42_ (
    .A(\count[6] ),
    .B(\count[5] ),
    .X(gray_count[5])
  );
  sky130_fd_sc_hd__or2_2 _43_ (
    .A(gray_count[7]),
    .B(\count[6] ),
    .X(_13_)
  );
  sky130_fd_sc_hd__nand2_2 _44_ (
    .A(gray_count[7]),
    .B(\count[6] ),
    .Y(_14_)
  );
  sky130_fd_sc_hd__and2_2 _45_ (
    .A(_13_),
    .B(_14_),
    .X(_15_)
  );
  sky130_fd_sc_hd__buf_1 _46_ (
    .A(_15_),
    .X(gray_count[6])
  );
  sky130_fd_sc_hd__a21oi_2 _47_ (
    .A1(enable),
    .A2(\count[0] ),
    .B1(reset),
    .Y(_16_)
  );
  sky130_fd_sc_hd__o21a_2 _48_ (
    .A1(enable),
    .A2(\count[0] ),
    .B1(_16_),
    .X(_00_)
  );
  sky130_fd_sc_hd__a21oi_2 _49_ (
    .A1(enable),
    .A2(\count[0] ),
    .B1(\count[1] ),
    .Y(_17_)
  );
  sky130_fd_sc_hd__and3_2 _50_ (
    .A(enable),
    .B(\count[1] ),
    .C(\count[0] ),
    .X(_18_)
  );
  sky130_fd_sc_hd__buf_1 _51_ (
    .A(_18_),
    .X(_19_)
  );
  sky130_fd_sc_hd__nor3_2 _52_ (
    .A(reset),
    .B(_17_),
    .C(_19_),
    .Y(_01_)
  );
  sky130_fd_sc_hd__xnor2_2 _53_ (
    .A(\count[2] ),
    .B(_19_),
    .Y(_20_)
  );
  sky130_fd_sc_hd__nor2_2 _54_ (
    .A(reset),
    .B(_20_),
    .Y(_02_)
  );
  sky130_fd_sc_hd__a211o_2 _55_ (
    .A1(_10_),
    .A2(_19_),
    .B1(reset),
    .C1(_08_),
    .X(_21_)
  );
  sky130_fd_sc_hd__o21ba_2 _56_ (
    .A1(\count[3] ),
    .A2(_19_),
    .B1_N(_21_),
    .X(_03_)
  );
  sky130_vsdinv _57_ (
    .A(\count[4] ),
    .Y(_22_)
  );
  sky130_fd_sc_hd__and3_2 _58_ (
    .A(_22_),
    .B(_10_),
    .C(_19_),
    .X(_23_)
  );
  sky130_fd_sc_hd__a21oi_2 _59_ (
    .A1(_10_),
    .A2(_19_),
    .B1(_22_),
    .Y(_24_)
  );
  sky130_vsdinv _60_ (
    .A(reset),
    .Y(_25_)
  );
  sky130_fd_sc_hd__o21a_2 _61_ (
    .A1(_23_),
    .A2(_24_),
    .B1(_25_),
    .X(_04_)
  );
  sky130_fd_sc_hd__nand3_2 _62_ (
    .A(_09_),
    .B(_12_),
    .C(_18_),
    .Y(_26_)
  );
  sky130_fd_sc_hd__a31o_2 _63_ (
    .A1(\count[4] ),
    .A2(_09_),
    .A3(_18_),
    .B1(\count[5] ),
    .X(_27_)
  );
  sky130_fd_sc_hd__and3_2 _64_ (
    .A(_25_),
    .B(_26_),
    .C(_27_),
    .X(_28_)
  );
  sky130_fd_sc_hd__buf_1 _65_ (
    .A(_28_),
    .X(_05_)
  );
  sky130_vsdinv _66_ (
    .A(\count[6] ),
    .Y(_29_)
  );
  sky130_fd_sc_hd__a41o_2 _67_ (
    .A1(\count[6] ),
    .A2(_10_),
    .A3(_12_),
    .A4(_18_),
    .B1(reset),
    .X(_30_)
  );
  sky130_fd_sc_hd__a21oi_2 _68_ (
    .A1(_29_),
    .A2(_26_),
    .B1(_30_),
    .Y(_06_)
  );
  sky130_fd_sc_hd__a41o_2 _69_ (
    .A1(\count[6] ),
    .A2(_10_),
    .A3(_12_),
    .A4(_18_),
    .B1(gray_count[7]),
    .X(_31_)
  );
  sky130_fd_sc_hd__o211a_2 _70_ (
    .A1(_14_),
    .A2(_26_),
    .B1(_31_),
    .C1(_25_),
    .X(_07_)
  );
  sky130_fd_sc_hd__dfxtp_2 _71_ (
    .CLK(clk),
    .D(_00_),
    .Q(\count[0] )
  );
  sky130_fd_sc_hd__dfxtp_2 _72_ (
    .CLK(clk),
    .D(_01_),
    .Q(\count[1] )
  );
  sky130_fd_sc_hd__dfxtp_2 _73_ (
    .CLK(clk),
    .D(_02_),
    .Q(\count[2] )
  );
  sky130_fd_sc_hd__dfxtp_2 _74_ (
    .CLK(clk),
    .D(_03_),
    .Q(\count[3] )
  );
  sky130_fd_sc_hd__dfxtp_2 _75_ (
    .CLK(clk),
    .D(_04_),
    .Q(\count[4] )
  );
  sky130_fd_sc_hd__dfxtp_2 _76_ (
    .CLK(clk),
    .D(_05_),
    .Q(\count[5] )
  );
  sky130_fd_sc_hd__dfxtp_2 _77_ (
    .CLK(clk),
    .D(_06_),
    .Q(\count[6] )
  );
  sky130_fd_sc_hd__dfxtp_2 _78_ (
    .CLK(clk),
    .D(_07_),
    .Q(gray_count[7])
  );
endmodule
```
Here, we notice that our custom cell `sky130_vsdinv` is displayed in the netlist generated.

## Floorplan and Placement

Also, sta report post synthesis can be viewed by going to the location `logs\synthesis\2-sta.log`

The next step is to run `floorplan` and `placement`. Type the following commands.
```
run_floorplan
run_placement
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

## Clock Tree Synthesis
 
The next step is to run run clock tree synthesis. The CTS run adds clock buffers in therefore buffer delays come into picture and our analysis from here on deals with real clocks. To run clock tree synthesis, type the following commands
```
run_cts
```

<p align="center">
  <img src="/images/cts.png">
</p><br>

Also, the netlist with clock buffers can be viewed by going to the location `results\cts\iiitb_gc.v`
```
module iiitb_gc (VGND,
    VPWR,
    clk,
    enable,
    reset,
    gray_count);
 input VGND;
 input VPWR;
 input clk;
 input enable;
 input reset;
 output [7:0] gray_count;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire _11_;
 wire _12_;
 wire _13_;
 wire _14_;
 wire _15_;
 wire _16_;
 wire _17_;
 wire _18_;
 wire _19_;
 wire _20_;
 wire _21_;
 wire _22_;
 wire _23_;
 wire _24_;
 wire _25_;
 wire _26_;
 wire _27_;
 wire _28_;
 wire _29_;
 wire _30_;
 wire _31_;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;
 wire \count[0] ;
 wire \count[1] ;
 wire \count[2] ;
 wire \count[3] ;
 wire \count[4] ;
 wire \count[5] ;
 wire \count[6] ;
 wire net1;
 wire net10;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;

 sky130_fd_sc_hd__decap_3 PHY_0 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_1 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_10 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_11 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_12 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_13 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_14 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_15 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_16 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_17 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_18 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_19 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_2 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_20 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_21 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_22 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_23 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_24 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_25 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_26 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_27 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_28 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_29 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_3 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_4 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_5 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_6 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_7 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_8 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__decap_3 PHY_9 (.VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_30 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_31 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_32 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_33 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_34 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_35 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_36 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_37 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_38 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_39 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_40 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_41 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_42 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_43 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_44 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_45 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_46 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_47 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_48 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_49 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_50 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_51 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_52 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_53 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_54 (.VGND(VGND),
    .VPWR(VPWR));
 sky130_fd_sc_hd__xor2_1 _32_ (.A(\count[1] ),
    .B(\count[0] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net3));
 sky130_fd_sc_hd__xor2_1 _33_ (.A(\count[2] ),
    .B(\count[1] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net4));
 sky130_fd_sc_hd__nor2_1 _34_ (.A(\count[3] ),
    .B(\count[2] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_08_));
 sky130_fd_sc_hd__and2_1 _35_ (.A(\count[3] ),
    .B(\count[2] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_09_));
 sky130_fd_sc_hd__dlymetal6s2s_1 _36_ (.A(_09_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_10_));
 sky130_fd_sc_hd__nor2_1 _37_ (.A(_08_),
    .B(_10_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(net5));
 sky130_fd_sc_hd__xor2_1 _38_ (.A(\count[4] ),
    .B(\count[3] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net6));
 sky130_fd_sc_hd__nor2_1 _39_ (.A(\count[5] ),
    .B(\count[4] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_11_));
 sky130_fd_sc_hd__and2_1 _40_ (.A(\count[5] ),
    .B(\count[4] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_12_));
 sky130_fd_sc_hd__nor2_1 _41_ (.A(_11_),
    .B(_12_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(net7));
 sky130_fd_sc_hd__xor2_1 _42_ (.A(\count[6] ),
    .B(\count[5] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net8));
 sky130_fd_sc_hd__or2_1 _43_ (.A(net10),
    .B(\count[6] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_13_));
 sky130_fd_sc_hd__nand2_1 _44_ (.A(net10),
    .B(\count[6] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_14_));
 sky130_fd_sc_hd__and2_1 _45_ (.A(_13_),
    .B(_14_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_15_));
 sky130_fd_sc_hd__clkbuf_1 _46_ (.A(_15_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net9));
 sky130_fd_sc_hd__a21oi_1 _47_ (.A1(net1),
    .A2(\count[0] ),
    .B1(net2),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_16_));
 sky130_fd_sc_hd__o21a_1 _48_ (.A1(net1),
    .A2(\count[0] ),
    .B1(_16_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_00_));
 sky130_fd_sc_hd__a21oi_1 _49_ (.A1(net1),
    .A2(\count[0] ),
    .B1(\count[1] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_17_));
 sky130_fd_sc_hd__and3_1 _50_ (.A(net1),
    .B(\count[1] ),
    .C(\count[0] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_18_));
 sky130_fd_sc_hd__clkbuf_2 _51_ (.A(_18_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_19_));
 sky130_fd_sc_hd__nor3_1 _52_ (.A(net2),
    .B(_17_),
    .C(_19_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_01_));
 sky130_fd_sc_hd__xnor2_1 _53_ (.A(\count[2] ),
    .B(_19_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_20_));
 sky130_fd_sc_hd__nor2_1 _54_ (.A(net2),
    .B(_20_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_02_));
 sky130_fd_sc_hd__a211o_1 _55_ (.A1(_10_),
    .A2(_19_),
    .B1(net2),
    .C1(_08_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_21_));
 sky130_fd_sc_hd__o21ba_1 _56_ (.A1(\count[3] ),
    .A2(_19_),
    .B1_N(_21_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_03_));
 sky130_vsdinv _57_ (.A(\count[4] ),
    .Y(_22_),
    .VPWR(VPWR),
    .VGND(VGND));
 sky130_fd_sc_hd__and3_1 _58_ (.A(_22_),
    .B(_10_),
    .C(_19_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_23_));
 sky130_fd_sc_hd__a21oi_1 _59_ (.A1(_10_),
    .A2(_19_),
    .B1(_22_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_24_));
 sky130_vsdinv _60_ (.A(net2),
    .Y(_25_),
    .VPWR(VPWR),
    .VGND(VGND));
 sky130_fd_sc_hd__o21a_1 _61_ (.A1(_23_),
    .A2(_24_),
    .B1(_25_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_04_));
 sky130_fd_sc_hd__nand3_1 _62_ (.A(_09_),
    .B(_12_),
    .C(_18_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_26_));
 sky130_fd_sc_hd__a31o_1 _63_ (.A1(\count[4] ),
    .A2(_09_),
    .A3(_18_),
    .B1(\count[5] ),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_27_));
 sky130_fd_sc_hd__and3_1 _64_ (.A(_25_),
    .B(_26_),
    .C(_27_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_28_));
 sky130_fd_sc_hd__clkbuf_1 _65_ (.A(_28_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_05_));
 sky130_vsdinv _66_ (.A(\count[6] ),
    .Y(_29_),
    .VPWR(VPWR),
    .VGND(VGND));
 sky130_fd_sc_hd__a41o_1 _67_ (.A1(\count[6] ),
    .A2(_10_),
    .A3(_12_),
    .A4(_18_),
    .B1(net2),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_30_));
 sky130_fd_sc_hd__a21oi_1 _68_ (.A1(_29_),
    .A2(_26_),
    .B1(_30_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Y(_06_));
 sky130_fd_sc_hd__a41o_1 _69_ (.A1(\count[6] ),
    .A2(_10_),
    .A3(_12_),
    .A4(_18_),
    .B1(net10),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_31_));
 sky130_fd_sc_hd__o211a_1 _70_ (.A1(_14_),
    .A2(_26_),
    .B1(_31_),
    .C1(_25_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(_07_));
 sky130_fd_sc_hd__dfxtp_1 _71_ (.CLK(clknet_1_0__leaf_clk),
    .D(_00_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[0] ));
 sky130_fd_sc_hd__dfxtp_1 _72_ (.CLK(clknet_1_0__leaf_clk),
    .D(_01_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[1] ));
 sky130_fd_sc_hd__dfxtp_1 _73_ (.CLK(clknet_1_0__leaf_clk),
    .D(_02_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[2] ));
 sky130_fd_sc_hd__dfxtp_1 _74_ (.CLK(clknet_1_0__leaf_clk),
    .D(_03_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[3] ));
 sky130_fd_sc_hd__dfxtp_1 _75_ (.CLK(clknet_1_1__leaf_clk),
    .D(_04_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[4] ));
 sky130_fd_sc_hd__dfxtp_1 _76_ (.CLK(clknet_1_1__leaf_clk),
    .D(_05_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[5] ));
 sky130_fd_sc_hd__dfxtp_1 _77_ (.CLK(clknet_1_1__leaf_clk),
    .D(_06_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(\count[6] ));
 sky130_fd_sc_hd__dfxtp_1 _78_ (.CLK(clknet_1_1__leaf_clk),
    .D(_07_),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .Q(net10));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_1 input1 (.A(enable),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net1));
 sky130_fd_sc_hd__clkbuf_2 input2 (.A(reset),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(net2));
 sky130_fd_sc_hd__buf_2 output10 (.A(net10),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[7]));
 sky130_fd_sc_hd__buf_2 output3 (.A(net3),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[0]));
 sky130_fd_sc_hd__buf_2 output4 (.A(net4),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[1]));
 sky130_fd_sc_hd__buf_2 output5 (.A(net5),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[2]));
 sky130_fd_sc_hd__buf_2 output6 (.A(net6),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[3]));
 sky130_fd_sc_hd__buf_2 output7 (.A(net7),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[4]));
 sky130_fd_sc_hd__buf_2 output8 (.A(net8),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[5]));
 sky130_fd_sc_hd__buf_2 output9 (.A(net9),
    .VGND(VGND),
    .VNB(VGND),
    .VPB(VPWR),
    .VPWR(VPWR),
    .X(gray_count[6]));
endmodule
```

Also, sta report post synthesis can be viewed by going to the location `logs\synthesis\12-cts.log`


## Routing
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

Area of the chip is 3288.43 micro meter sq.

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
