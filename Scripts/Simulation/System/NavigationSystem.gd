extends Node

# Tlemap Data to fill the grid
var tile_map


# Tilemap parameters
var collisions_layer = 0
var path_layer = 1
var path_tile = Vector2i(2,0)
var main_source = 1
var is_solid = "is_solid"

# Create AStarGrid
var navigation_grid = AStarGrid2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Connect nav system signals
	Herald.request_navigation_path.connect(_handle_request_navigation_path)
	Herald.request_navigation_clear_path.connect(_handle_request_navigation_clear_path)
	tile_map = get_tree().root.get_node("Simulation/TileMap")
	# Setup nav grid
	_setup_nav_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _generate_new_path(current_point: Vector2i, _target_point: Vector2) -> Array:
	# Requests new path to A*
	var temp_path = navigation_grid.get_id_path(current_point, _target_point)

	# Clears path layer to draw the new path 
	tile_map.clear_layer(path_layer)
	# Draws new path
	for cell in temp_path:
		tile_map.set_cell(path_layer, cell, main_source, path_tile)

	return temp_path

func _check_cell_is_solid(cell_to_check:Vector2i) -> bool:
	return tile_map.get_cell_tile_data(collisions_layer, cell_to_check).get_custom_data(is_solid)

func _update_solid_cells() -> void:
	for cell in tile_map.get_used_cells(collisions_layer):
		if _check_cell_is_solid(cell):
			navigation_grid.set_point_solid(cell, true)

func _setup_nav_grid():
	# Add Path layer
	tile_map.add_layer(path_layer)

	# Update the parameters of the AStar
	navigation_grid.region = tile_map.get_used_rect()
	navigation_grid.cell_size = Vector2i(global.tile_size, global.tile_size)
	navigation_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	navigation_grid.update()
	_update_solid_cells()

# <-----> FUNCTIONS TO HANLDE SINGNALS <----->
func _handle_request_navigation_path(emiter, current_point, target_point): 
	Herald.return_navigation_path.emit(emiter, _generate_new_path(current_point, target_point))

func _handle_request_navigation_clear_path():
	# Clears path layer to draw the new path 
	tile_map.clear_layer(path_layer)