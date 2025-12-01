class_name RNG
extends Node


@export var entrance_weights = [25, 1, 4, 1, 1] #Weights for 0, ..., 4 entrances
@export var hallway_status_weights = [1,10] # for 0 corner, 1 hallway
@export var filled_status_weights = [10,1] # for 0 empty, 1 full
var rng : = RandomNumberGenerator.new()
const possible_hallway_state = [0,1]
var noise : FastNoiseLite = FastNoiseLite.new()



func spawn_random_room() -> Room:
	#Choose entrance count from
	var entrance_count : int = Room.possible_entrance_counts[rng.rand_weighted(entrance_weights)]
	
	#Choose orientation Status
	var random_angle : int = randi_range(0, 3)*90
	
	#Choose hallway or corner when 2 entrances
	var is_hallway : bool = false
	
	if (entrance_count == 2) and (possible_hallway_state[rng.rand_weighted(hallway_status_weights)]):
		is_hallway = true
		
	var is_full : bool = false
	
	if (entrance_count == 0) and (possible_hallway_state[rng.rand_weighted(filled_status_weights)]):
		is_full = true
		#print("full true")
	
	return Room.new(entrance_count, random_angle, is_hallway, is_full)

func initialize_noise() -> void:
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.05

func noise_tile(noise_pos : Vector2i) -> Room:
	# Get noise value between -1.0 and 1.0
	var noise_val = noise.get_noise_2d(noise_pos.x, noise_pos.y)
	var is_full : bool = false
	var atlas_coords = Vector2i.ZERO
	if noise_val < -0.1:
	# Water (Assume water is at 0,0 in your tileset)
		atlas_coords = Room.room_shape_atlas_positions[Room.RoomShapes.FULL]
		is_full = true
		#Vector2i(0, 0)
	else:
		# Land (Assume grass is at 1,0 in your tileset)
		atlas_coords = Room.room_shape_atlas_positions[Room.RoomShapes.EMPTY]
		is_full = false

	return Room.new(0, 0, false, is_full)
