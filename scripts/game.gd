extends Node2D

var noise: FastNoiseLite = FastNoiseLite.new();
@onready var map: TileMap = $TileMap;
@onready var player: Player = $Player;
@onready var hud: CanvasLayer = $HUD;

@export var MAP_WIDTH: int = 700;
@export var MAP_HEIGHT: int = 120;

const GRASS: Vector2i = Vector2i(2, 0);
const DIRT: Vector2i = Vector2i(2, 1);
var heights: Array[int] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize();
	noise.seed = randi();
	
	noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	noise.frequency = 0.01; 
	print("Using seed : ", noise.seed)
	draw_map();
	# Place the player at the center of the map.
	print("Placing player at ", MAP_WIDTH/2, " ", heights[MAP_WIDTH/2], " ", heights.size());
	player.position = Vector2(0, heights[MAP_WIDTH/2]);

func getHeight(x: int) -> int:
	return int(noise.get_noise_1d(x) * 25 + 50);

func draw_map() -> void:
	# First, we use a 1D noise to generate the height of the terrain
	for x in range(-MAP_WIDTH/2, MAP_WIDTH/2):
		var surface_y: int = getHeight(x);
		heights.append(surface_y);
		for y in range(MAP_HEIGHT):
			if y == surface_y:
				map.set_cell(0, Vector2i(x, y), 1, GRASS, 0);
			elif y > surface_y:
				map.set_cell(0, Vector2i(x, y), 1, DIRT, 0);

func _process(delta: float) -> void:
	hud.get_node("Control").get_node('Label').text = "FPS: " + str(Engine.get_frames_per_second()) + "\n" + "Coords: " + str(player.position.x / 16) + ' | ' + str(player.position.y / 16);
