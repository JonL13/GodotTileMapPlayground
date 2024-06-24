extends TileMap


# Implementation inspired by Cashew OldDew:
#	https://www.youtube.com/watch?v=OMrDS0zlr-k

var astar: AStarGrid2D = AStarGrid2D.new()
var map_rect: Rect2i

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_map_size: Vector2i = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i.ZERO, tile_map_size)
	
	astar.region = map_rect
	astar.cell_size = tile_map_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in tile_map_size.x:
		for j in tile_map_size.y:
			var coords: Vector2i = Vector2i(i, j)
			for k in range(get_layers_count()):
				var tile_data = get_cell_tile_data(k, coords)
				if tile_data and tile_data.get_custom_data('type') == 'wall':
					astar.set_point_solid(coords)
	pass # Replace with function body.

func is_point_walkable(position: Vector2) -> bool:
	var map_position = local_to_map(position)
	if map_rect.has_point(map_position) and not astar.is_point_solid(map_position):
		return true
	return false
