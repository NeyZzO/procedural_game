extends Node2D

var noise: FastNoiseLite = FastNoiseLite.new();
@onready var map: TileMap = $TileMap;

@export var MAP_WIDTH: int = 700;
@export var MAP_HEIGHT: int = 120;

const GRASS: Vector2i = Vector2i(2, 0);
const DIRT: Vector2i = Vector2i(2, 0);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	noise.seed = randi();
	
	noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	noise.frequency = 0.01; 
	print("Using seed : ", noise.seed)
	draw_map();

var test: Array[int] = [];

func getHeight(x: int) -> int:
	return int(noise.get_noise_1d(x) * 20 + 50);

func draw_map() -> void:
	# First, we use a 1D noise to generate the height of the terrain
	for x in range(MAP_WIDTH):
		var surface_y: int = getHeight(x);
		print(surface_y);
		for y in range(MAP_HEIGHT):
			if y == surface_y:
				map.set_cell(1, Vector2i(x, y), 1, GRASS, 0);
			elif y < surface_y:
				map.set_cell(0, Vector2i(x, y), 1, DIRT, 0);