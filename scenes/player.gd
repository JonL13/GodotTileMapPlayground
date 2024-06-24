extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var tile_map: TileMap
var current_path: Array[Vector2i]
var run_speed: int = 2

func _process(_delta):
	move_sprite()

func _unhandled_input(event):
	handle_move_to_event(event)

func handle_move_to_event(event): 
	if not event.is_action_pressed("move_to"):
		return
	
	var click_position: Vector2 = get_global_mouse_position()
	if not tile_map.is_point_walkable(click_position):
		return
	
	if tile_map.is_point_walkable(click_position):
		current_path = tile_map.astar.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(click_position)
		).slice(1)

func move_sprite():
	if current_path.is_empty():
		return
	
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, run_speed)
	if global_position == target_position:
		current_path.pop_front()
	
	if global_position.x > target_position.x:
		animated_sprite_2d.flip_h = true
	elif global_position.x < target_position.x:
		animated_sprite_2d.flip_h = false
