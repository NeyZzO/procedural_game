extends Node2D

var noise: FastNoiseLite = FastNoiseLite.new();
@onready var map: TileMap = $TileMap;

@export var MAX_X: int = 1152;
@export var MAX_Y: int = 648;

const atlas_grass: Vector2i = Vector2(5, 0);
const atlas_grass_flowers: Vector2i = Vector2(6, 1);
const atlas_dirt: Vector2i = Vector2(5, 3);
const atlas_woder: Vector2i = Vector2(5, 6);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	noise.seed = randi();
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH;
	noise.frequency = 0.01;  
	draw_map();

func draw_map() -> void:
	for x in range(-MAX_X/2, MAX_X/2):
		for y in range(-MAX_Y/2, MAX_Y/2):
			var n: float = noise.get_noise_2d(x, y);
			if n >= 0.05:
				if n >= 0.5:
					map.set_cell(0, Vector2i(x, y), 0, atlas_grass_flowers, 0);
				elif n <= 0.1:
					map.set_cell(0, Vector2i(x, y), 0, atlas_dirt, 0);
				else:
					map.set_cell(0, Vector2i(x, y), 0, atlas_grass, 0);
			else:
				map.set_cell(0, Vector2i(x, y), 0, atlas_woder, 0);



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
