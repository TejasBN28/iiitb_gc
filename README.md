# iiitb_gc - gray counter

## Steps to Execute:

### 1) Install necessary softwares:
<copy-button> hi </copy-button>
  $ sudo apt-get install git \n
  $ sudo apt-get install iverilog \n
  $ sudo apt-get install gtkwave \n

### 2) Functional Simulation:
  $ git clone https://github.com/TejasBN28/iiitb_gc.git
  $ cd iiitb_gc
  $ iverilog iiitb_gc.v iiitb_gc_tb.v -o iiitb_gc
  $ ./iiitb_gc
  $ gtkwave iiitb_gc.vcd
  
     
