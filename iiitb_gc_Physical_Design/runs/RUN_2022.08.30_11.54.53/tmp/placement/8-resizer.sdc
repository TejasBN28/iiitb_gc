###############################################################################
# Created by write_sdc
# Tue Aug 30 11:55:48 2022
###############################################################################
current_design iiitb_gc
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clkin -period 65.0000 
set_clock_uncertainty 0.2500 clkin
set_input_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {clk}]
set_input_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {enable}]
set_input_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {reset}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[0]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[1]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[2]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[3]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[4]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[5]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[6]}]
set_output_delay 13.0000 -clock [get_clocks {clkin}] -add_delay [get_ports {gray_count[7]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {gray_count[7]}]
set_load -pin_load 0.0334 [get_ports {gray_count[6]}]
set_load -pin_load 0.0334 [get_ports {gray_count[5]}]
set_load -pin_load 0.0334 [get_ports {gray_count[4]}]
set_load -pin_load 0.0334 [get_ports {gray_count[3]}]
set_load -pin_load 0.0334 [get_ports {gray_count[2]}]
set_load -pin_load 0.0334 [get_ports {gray_count[1]}]
set_load -pin_load 0.0334 [get_ports {gray_count[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {enable}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 10.0000 [current_design]
