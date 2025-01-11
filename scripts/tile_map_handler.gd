class_name TileMapHandler
extends TileMapLayer

const TILE_SIZE = 16

@export var play_speed: float = 1
@export var width: int
@export var height: int
@export var height_offset: int

var playing = false
var temp_field
var time_counter = 0

func _ready() -> void:

	temp_field = []
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			temp.append(0)
		temp_field.append(temp)


func _process(delta: float) -> void:
	if time_counter > 1 / play_speed:
		time_counter = 0
		update_fields()
	else:
		time_counter += delta

func _input(event):
	if event.is_action_pressed("toggle_play"):
		playing = !playing
	if event.is_action_pressed("click"):
		var pos: Vector2i = (get_local_mouse_position() / TILE_SIZE).floor()
		var coords = get_cell_atlas_coords(pos)
		var new_coords = Vector2i(1 - coords.x, coords.y)
		set_cell(pos, 0, new_coords)
	
func update_fields():
	if !playing:
		return
	
	# Calc all fields at once
	for x in range(width):
		for y in range(height):
			calc_neighbours(x, y)
	
	#Update fields after all are calculated
	for x in range(width):
		for y in range(height):
			set_cell(Vector2i(x, y), 0, Vector2i(temp_field[x][y], 0))

func calc_neighbours(x: int, y: int):
	var live_neighbours = 0
	for x_off in [-1, 0, 1]:
		for y_off in [-1, 0, 1]:
			if (x_off != y_off or x_off != 0) and get_cell(x + x_off, y + y_off) == 1:
				live_neighbours += 1

	if get_cell(x, y) == 1:
		if live_neighbours in [2, 3]:
			temp_field[x][y] = 1
		else:
			temp_field[x][y] = 0
	else:
		if live_neighbours == 3:
			temp_field[x][y] = 1
		else:
			temp_field[x][y] = 0

func get_cell(x: int, y: int) -> int:
	return get_cell_atlas_coords(Vector2i(x, y)).x
