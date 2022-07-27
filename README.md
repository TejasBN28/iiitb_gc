# iiitb_gc - gray counter

## Steps to Execute:

### 1) Install necessary softwares:
 import copy from 'copy-text-to-clipboard';

button.addEventListener('click', () => {
	copy('🦄🌈');
});
  $ sudo apt-get install git
  $ sudo apt-get install iverilog
  $ sudo apt-get install gtkwave

### 2) Functional Simulation:
  $ git clone https://github.com/TejasBN28/iiitb_gc.git
  $ cd iiitb_gc
  $ iverilog iiitb_gc.v iiitb_gc_tb.v -o iiitb_gc
  $ ./iiitb_gc
  $ gtkwave iiitb_gc.vcd
  
     
