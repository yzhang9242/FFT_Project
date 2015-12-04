###################################################################

# Created by write_sdc on Wed Nov 25 14:55:21 2015

###################################################################
set sdc_version 1.7

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_max_fanout 4 [current_design]
set_max_area 0
set_driving_cell -lib_cell INVX1TS [get_ports clk]
set_driving_cell -lib_cell INVX1TS [get_ports rst_n]
set_load -pin_load 0.005 [get_ports by_pass]
set_load -pin_load 0.005 [get_ports ld0]
set_load -pin_load 0.005 [get_ports ld1]
set_load -pin_load 0.005 [get_ports ld2]
set_max_capacitance 0.005 [get_ports clk]
set_max_capacitance 0.005 [get_ports rst_n]
set_max_fanout 4 [get_ports clk]
set_max_fanout 4 [get_ports rst_n]
set_ideal_network [get_ports clk]
create_clock [get_ports clk]  -period 0.8  -waveform {0 0.4}
set_clock_uncertainty 0  [get_clocks clk]
set_clock_transition -max -rise 0.01 [get_clocks clk]
set_clock_transition -max -fall 0.01 [get_clocks clk]
set_clock_transition -min -rise 0.01 [get_clocks clk]
set_clock_transition -min -fall 0.01 [get_clocks clk]
set_input_delay -clock clk  0.05  [get_ports rst_n]
set_output_delay -clock clk  0.05  [get_ports by_pass]
set_output_delay -clock clk  0.05  [get_ports ld0]
set_output_delay -clock clk  0.05  [get_ports ld1]
set_output_delay -clock clk  0.05  [get_ports ld2]
