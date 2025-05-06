# Chess Game Constraints for ZedBoard

# Clock Configuration (100MHz)
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports ClkPort]
set_property PACKAGE_PIN Y9 [get_ports ClkPort]
set_property IOSTANDARD LVCMOS33 [get_ports ClkPort]

# DIP Switches (SW0-SW7)
set_property PACKAGE_PIN F22 [get_ports Sw0]
set_property IOSTANDARD LVCMOS33 [get_ports Sw0]
# Commented out unused switches
#set_property PACKAGE_PIN G22 [get_ports Sw1]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw1]
#set_property PACKAGE_PIN H22 [get_ports Sw2]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw2]
#set_property PACKAGE_PIN F21 [get_ports Sw3]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw3]
#set_property PACKAGE_PIN H19 [get_ports Sw4]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw4]
#set_property PACKAGE_PIN H18 [get_ports Sw5]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw5]
#set_property PACKAGE_PIN H17 [get_ports Sw6]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw6]
#set_property PACKAGE_PIN M15 [get_ports Sw7]
#set_property IOSTANDARD LVCMOS33 [get_ports Sw7]

# Navigation Buttons (corrected pin assignments for ZedBoard)
set_property PACKAGE_PIN P16 [get_ports BtnC]
set_property IOSTANDARD LVCMOS33 [get_ports BtnC]
set_property PACKAGE_PIN T18 [get_ports BtnU]
set_property IOSTANDARD LVCMOS33 [get_ports BtnU]
set_property PACKAGE_PIN N15 [get_ports BtnL]
set_property IOSTANDARD LVCMOS33 [get_ports BtnL]
set_property PACKAGE_PIN R16 [get_ports BtnD]
set_property IOSTANDARD LVCMOS33 [get_ports BtnD]
set_property PACKAGE_PIN R18 [get_ports BtnR]
set_property IOSTANDARD LVCMOS33 [get_ports BtnR]

# LED outputs for debugging
set_property PACKAGE_PIN T22 [get_ports Ld0]
set_property IOSTANDARD LVCMOS33 [get_ports Ld0]
set_property PACKAGE_PIN T21 [get_ports Ld1]
set_property IOSTANDARD LVCMOS33 [get_ports Ld1]
set_property PACKAGE_PIN U22 [get_ports Ld2]
set_property IOSTANDARD LVCMOS33 [get_ports Ld2]
set_property PACKAGE_PIN U21 [get_ports Ld3]
set_property IOSTANDARD LVCMOS33 [get_ports Ld3]
set_property PACKAGE_PIN V22 [get_ports Ld4]
set_property IOSTANDARD LVCMOS33 [get_ports Ld4]

# VGA Interface (12-bit color)
# Red (3 bits)
set_property PACKAGE_PIN V20 [get_ports vga_r0]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r0]
set_property PACKAGE_PIN U20 [get_ports vga_r1]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r1]
set_property PACKAGE_PIN V19 [get_ports vga_r2]
set_property IOSTANDARD LVCMOS33 [get_ports vga_r2]

# Green (3 bits)
set_property PACKAGE_PIN AB22 [get_ports vga_g0]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g0]
set_property PACKAGE_PIN AA22 [get_ports vga_g1]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g1]
set_property PACKAGE_PIN AB21 [get_ports vga_g2]
set_property IOSTANDARD LVCMOS33 [get_ports vga_g2]

# Blue (2 bits)
set_property PACKAGE_PIN Y21 [get_ports vga_b0]
set_property IOSTANDARD LVCMOS33 [get_ports vga_b0]
set_property PACKAGE_PIN Y20 [get_ports vga_b1]
set_property IOSTANDARD LVCMOS33 [get_ports vga_b1]

# Sync signals
set_property PACKAGE_PIN AA19 [get_ports vga_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
set_property PACKAGE_PIN Y19 [get_ports vga_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

# OLED Interface (PMOD JB) - Updated pin assignments
set_property PACKAGE_PIN AB12 [get_ports disp1_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_spi_clk]
set_property PACKAGE_PIN AA12 [get_ports disp1_spi_data]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_spi_data]
set_property PACKAGE_PIN U12 [get_ports disp1_vdd]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_vdd]
set_property PACKAGE_PIN U11 [get_ports disp1_vbat]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_vbat]
set_property PACKAGE_PIN U9 [get_ports disp1_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_reset_n]
set_property PACKAGE_PIN U10 [get_ports disp1_dc_n]
set_property IOSTANDARD LVCMOS33 [get_ports disp1_dc_n]

# Commented out PMOD 8LE Interface
# Segment signals (a-g)
#set_property PACKAGE_PIN Y11 [get_ports {seg[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#set_property PACKAGE_PIN Y12 [get_ports {seg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property PACKAGE_PIN W11 [get_ports {seg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property PACKAGE_PIN W12 [get_ports {seg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property PACKAGE_PIN V11 [get_ports {seg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property PACKAGE_PIN V12 [get_ports {seg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property PACKAGE_PIN U11 [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# Anode control signals
#set_property PACKAGE_PIN U12 [get_ports {an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
#set_property PACKAGE_PIN T11 [get_ports {an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
#set_property PACKAGE_PIN T12 [get_ports {an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
#set_property PACKAGE_PIN R11 [get_ports {an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
#set_property PACKAGE_PIN R12 [get_ports {an[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]
#set_property PACKAGE_PIN P11 [get_ports {an[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]
#set_property PACKAGE_PIN P12 [get_ports {an[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]
#set_property PACKAGE_PIN N11 [get_ports {an[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]

# Decimal point
#set_property PACKAGE_PIN N12 [get_ports dp]
#set_property IOSTANDARD LVCMOS33 [get_ports dp]

# Memory interface (disabled)
set_property PACKAGE_PIN G20 [get_ports MemOE]
set_property IOSTANDARD LVCMOS33 [get_ports MemOE]
set_property PACKAGE_PIN E20 [get_ports MemWR]
set_property IOSTANDARD LVCMOS33 [get_ports MemWR]
set_property PACKAGE_PIN E19 [get_ports RamCS]
set_property IOSTANDARD LVCMOS33 [get_ports RamCS]
set_property PACKAGE_PIN F19 [get_ports FlashCS]
set_property IOSTANDARD LVCMOS33 [get_ports FlashCS]
set_property PACKAGE_PIN G19 [get_ports QuadSpiFlashCS]
set_property IOSTANDARD LVCMOS33 [get_ports QuadSpiFlashCS]

# Timing constraints
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {Btn* Sw*}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 10.000 [get_ports {Btn* Sw*}]
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {vga_* disp1_* Ld*}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 10.000 [get_ports {vga_* disp1_* Ld*}]

# Allow bitstream generation with unspecified pin locations
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

# PS7 Configuration for Zynq
set_property SEVERITY {Warning} [get_drc_checks ZPS7-1]

# Additional timing constraints to help meet timing requirements
set_false_path -from [get_ports {Btn* Sw*}]
set_false_path -to [get_ports {vga_* disp1_* Ld*}]
set_max_delay -datapath_only 10.000 -from [get_ports {Btn* Sw*}] -to [get_ports {vga_* disp1_* Ld*}] 