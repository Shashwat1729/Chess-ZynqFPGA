# Create a new project
create_project chess_project_new ./chess_project_new -part xc7a100tcsg324-1

# Add design files
add_files -norecurse chess_project.srcs/sources_1/new/game_logic.v
add_files -norecurse chess_project.srcs/sources_1/new/monte_carlo_chess.v
add_files -norecurse chess_project.srcs/sources_1/new/improved_pieces.v
add_files -norecurse chess_project.srcs/sources_1/new/chess_top.v

# Set the top module
set_property top chess_top [current_fileset]

# Update compile order
update_compile_order -fileset sources_1

# Save the project
save_project_as chess_project_new.xpr

# Exit Vivado
exit 