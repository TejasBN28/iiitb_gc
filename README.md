# iiitb_gc - gray counter

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
