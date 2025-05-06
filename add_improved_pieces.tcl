# Add the improved_pieces.v file to the project
open_project chess_project.xpr
add_files -norecurse chess_project.srcs/sources_1/new/improved_pieces.v
set_property file_type {Verilog Header} [get_files chess_project.srcs/sources_1/new/improved_pieces.v]
set_property USED_IN_SYNTHESIS true [get_files chess_project.srcs/sources_1/new/improved_pieces.v]
set_property USED_IN_IMPLEMENTATION true [get_files chess_project.srcs/sources_1/new/improved_pieces.v]
set_property USED_IN_SIMULATION true [get_files chess_project.srcs/sources_1/new/improved_pieces.v]
save_project_as chess_project.xpr 