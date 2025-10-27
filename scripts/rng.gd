class_name RNG
extends Node


@export var entrance_weights = [25, 1, 4, 1, 1] #Weights for 0, ..., 4 entrances
@export var hallway_status_weights = [1,10] # for 0 corner, 1 hallway
var rng = RandomNumberGenerator.new()
const possible_hallway_state = [0,1]


func _ready() -> void:
	pass


func spawn_random_room() -> Room:
	#Choose entrance count from
	var entrance_count : int = Room.possible_entrance_counts[rng.rand_weighted(entrance_weights)]
	
	#Choose orientation Status
	var random_angle : int = randi_range(0, 3)*90
	
	#Choose hallway or corner when 2 entrances
	var is_hallway : bool = false
	
	if (entrance_count == 2) and (possible_hallway_state[rng.rand_weighted(hallway_status_weights)]):
		is_hallway = true
	
	return Room.new(entrance_count, random_angle, is_hallway)
