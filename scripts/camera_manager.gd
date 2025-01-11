class_name CameraManager
extends Camera2D

@export var tile_map_Handler: TileMapHandler
@export var zoom_coeff: float = 1

var width_px
var height_px
var height_px_offset

func _ready() -> void:
	width_px = tile_map_Handler.width * tile_map_Handler.TILE_SIZE
	height_px = tile_map_Handler.height * tile_map_Handler.TILE_SIZE
	height_px_offset = tile_map_Handler.height_offset * tile_map_Handler.TILE_SIZE
	position = Vector2(width_px, height_px + height_px_offset) / 2



func _process(_delta: float) -> void:
	zoom = Vector2(zoom_coeff, zoom_coeff)
