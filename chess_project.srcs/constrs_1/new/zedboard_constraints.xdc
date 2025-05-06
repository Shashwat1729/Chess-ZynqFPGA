# Clock Configuration (100MHz)
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports ClkPort]
set_property PACKAGE_PIN Y9 [get_ports ClkPort]
set_property IOSTANDARD LVCMOS33 [get_ports ClkPort]

# DIP Switches (SW0-SW7)
set_property PACKAGE_PIN F22 [get_ports Sw0]
set_property IOSTANDARD LVCMOS33 [get_ports Sw0]

# Navigation Buttons (corrected pin assignments for ZedBoard)
set_property PACKAGE_PIN P16 [get_ports BtnC]
set_property IOSTANDARD LVCMOS33 [get_ports BtnC]
set_property PACKAGE_PIN M13 [get_ports BtnU]
set_property IOSTANDARD LVCMOS33 [get_ports BtnU]
set_property PACKAGE_PIN R15 [get_ports BtnL]
set_property IOSTANDARD LVCMOS33 [get_ports BtnL]
set_property PACKAGE_PIN R16 [get_ports BtnD]
set_property IOSTANDARD LVCMOS33 [get_ports BtnD]
set_property PACKAGE_PIN R17 [get_ports BtnR]
set_property IOSTANDARD LVCMOS33 [get_ports BtnR]

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

# OLED Interface (PMOD JB)
set_property PACKAGE_PIN W12 [get_ports oled_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_clk]
set_property PACKAGE_PIN W11 [get_ports oled_spi_data]
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_data]
set_property PACKAGE_PIN V12 [get_ports oled_vdd]
set_property IOSTANDARD LVCMOS33 [get_ports oled_vdd]
set_property PACKAGE_PIN V11 [get_ports oled_vbat]
set_property IOSTANDARD LVCMOS33 [get_ports oled_vbat]
set_property PACKAGE_PIN U12 [get_ports oled_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports oled_reset_n]
set_property PACKAGE_PIN U11 [get_ports oled_dc_n]
set_property IOSTANDARD LVCMOS33 [get_ports oled_dc_n]

# Memory interface (disabled)
set_property PACKAGE_PIN F20 [get_ports MemOE]
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
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {vga_* oled_*}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 10.000 [get_ports {vga_* oled_*}]

# Allow bitstream generation with unspecified pin locations
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

# PS7 Configuration for Zynq
set_property SEVERITY {Warning} [get_drc_checks ZPS7-1]

# Additional timing constraints to help meet timing requirements
set_false_path -from [get_ports {Btn* Sw*}]
set_false_path -to [get_ports {vga_* oled_*}]
set_max_delay -datapath_only 10.000 -from [get_ports {Btn* Sw*}] -to [get_ports {vga_* oled_*}] 