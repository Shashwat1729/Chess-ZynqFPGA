# Open the project
open_project chess_project.xpr

# Add the improved_pieces.v file to the project
add_files -norecurse chess_project.srcs/sources_1/new/improved_pieces.v

# Update the project
update_compile_order -fileset sources_1

# Save the project
save_project_as chess_project.xpr

# Exit Vivado
exit 