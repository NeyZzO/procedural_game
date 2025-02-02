extends Node2D

var surface_noise: FastNoiseLite = FastNoiseLite.new();
var cave_noise: FastNoiseLite = FastNoiseLite.new();

@onready var map: TileMap = $TileMap;
@onready var player: Player = $Player;
@onready var hud: CanvasLayer = $HUD;

@export var MAP_WIDTH: int = 700;
@export var MAP_HEIGHT: int = 300;

const GRASS: Vector2i = Vector2i(0, 0);
const DIRT: Vector2i = Vector2i(1, 0);
const STONE: Vector2i = Vector2i(2, 0);
var heights: Array[int] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	var SEED: int = randi();
	surface_noise.seed = SEED;
	surface_noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	surface_noise.frequency = 0.01; 
	draw_map();

	# Place the player at the center of the map.
	print(heights[MAP_WIDTH/2])
	player.position = Vector2(0 + 8, (heights[MAP_WIDTH/2] * 16) - 8);

	# Now generate the caves;
	cave_noise.seed = SEED;
	cave_noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	cave_noise.frequency = 0.05;
	generateCaves();



func generateCaves() -> void:
	for x in range(-MAP_WIDTH/2, MAP_WIDTH/2):
		for y in range(MAP_HEIGHT):
			var value: float = cave_noise.get_noise_2d(x, y);
			if value > 0.2:
				print('Cave')
				map.set_cell(0, Vector2i(x, y), 0, Vector2i(-1, -1), 0);

	

func getHeight(x: int) -> int:
	return int(surface_noise.get_noise_1d(x) * 25 + 50);

func draw_map() -> void:
	# First, we use a 1D noise to generate the height of the terrain
	for x in range(-MAP_WIDTH/2, MAP_WIDTH/2):
		var surface_y: int = getHeight(x);
		heights.append(surface_y);
		for y in range(MAP_HEIGHT):
			if y == surface_y:
				map.set_cell(0, Vector2i(x, y), 0, GRASS, 0);
			elif y > surface_y and (y - surface_y) < 5:
				map.set_cell(0, Vector2i(x, y), 0, DIRT, 0);
			elif y > surface_y:
				map.set_cell(0, Vector2i(x, y), 0, STONE, 0);

func _process(delta: float) -> void:
	hud.get_node("Control").get_node('Label').text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Coords: " + str(round((player.position.x - 8) / 16)) + ' | ' + str(round((MAP_HEIGHT - (player.position.y / 16)) - .5));
