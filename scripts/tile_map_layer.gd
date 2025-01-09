extends TileMapLayer

const TILE_SIZE = 16

@export var width: int
@export var height: int

var playing = false
var temp_field


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var width_px = width * TILE_SIZE
	var height_px = height * TILE_SIZE
	var cam = $Camera2D

	cam.position = Vector2(width_px, height_px) / 2
	cam.zoom = Vector2(width_px, height_px) / Vector2(1280, 720)

	temp_field = []
	for x in range(width):
		var temp = []
		for y in range(height):
			# set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
			set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			temp.append(0)
		temp_field.append(temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_field()

func _input(event):
	if event.is_action_pressed("toggle_play"):
		playing = !playing
	if event.is_action_pressed("click"):
		var pos: Vector2i = (get_local_mouse_position() / TILE_SIZE).floor()
		var coords = get_cell_atlas_coords(pos)
		var new_coords = Vector2i(1 - coords.x, coords.y)
		set_cell(pos, 0, new_coords)
	
func update_field():
	if !playing:
		return

	
	for x in range(width):
		for y in range(height):
			var live_neighbours = 0
			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell_atlas_coords(Vector2i(x + x_off, y + y_off)).x == 1:
							live_neighbours += 1

			if get_cell_atlas_coords(Vector2i(x, y)).x == 1:
				if live_neighbours in [2, 3]:
					temp_field[x][y] = 1
				else:
					temp_field[x][y] = 0
			else:
				if live_neighbours == 3:
					temp_field[x][y] = 1
				else:
					temp_field[x][y] = 0

					
	
	for x in range(width):
		for y in range(height):
			set_cell(Vector2i(x, y), 0, Vector2i(temp_field[x][y], 0))
					


