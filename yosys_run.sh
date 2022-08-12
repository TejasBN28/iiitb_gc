read_liberty -lib /home/tejasbn/Desktop/Physical_Design_ASICs/iiitb_gc/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog iiitb_gc.v

synth -top iiitb_gc	

dfflibmap -liberty /home/tejasbn/Desktop/Physical_Design_ASICs/iiitb_gc/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /home/tejasbn/Desktop/Physical_Design_ASICs/iiitb_gc/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

clean
flatten

write_verilog -noattr iiitb_gc_synth.v

stat

show

