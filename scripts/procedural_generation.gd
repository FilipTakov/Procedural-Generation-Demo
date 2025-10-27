extends Node2D




@export var dungeon : Dungeon

@onready var room_tiles: TileMapLayer = $RoomTiles
@onready var rng: RNG = $RNG

var top_left_boundary: Vector2i = Vector2i(12,13)
var bottom_right_boundary: Vector2i = Vector2i(28,22)

var dungeon_cleared : bool = true

var room_save : String
var dungeon_save : String

func _ready() -> void:
	#Connect UI requests
	SignalManager.generate_called.connect(generate_dungeon)
	SignalManager.reset_generation_called.connect(reset_dungeon)
	SignalManager.save_called.connect(save_dungeon)
	SignalManager.load_called.connect(load_dungeon)

func generate_dungeon() -> void:
	# Generate rooms for dungeon resource
	_populate_dungeon_with_random_rooms()
	# Draws tiles
	iterate_over_rectangle(Callable(place_room_tile))
	dungeon_cleared = false

func reset_dungeon() -> void:
	room_tiles.clear()
	dungeon = Dungeon.new(bottom_right_boundary - top_left_boundary)
	dungeon_cleared = true

func save_dungeon() -> void:
	if (dungeon_cleared):
		print("SAVE ERROR: Empty Dungeon")
		return

	var room : Room = dungeon.rooms[0][0]
	room_save = room.save_to_json()
	dungeon_save = dungeon.save_to_json()
	print("SAVED DUNGEON: " +str(dungeon_save))
	

func load_dungeon() -> void:

	if (dungeon_save.is_empty()):
		print("LOAD ERROR: No Saved Dungeons")
		return 
	
	var dungeon_instance : Dungeon = dungeon
	#var room : Room = dungeon.rooms[0][0]
	
	
	for x in range(dungeon._dimensions.x):
		for y in range(dungeon._dimensions.y):
			pass
	print(SaveLoader.load_from_json(dungeon_save))
	dungeon.set_with_dictionary(SaveLoader.load_from_json(dungeon_save))
	
	
	iterate_over_rectangle(Callable(place_room_tile))
	dungeon_cleared = false


func _populate_dungeon_with_random_rooms() -> void:
	dungeon = Dungeon.new(bottom_right_boundary - top_left_boundary, Vector2i(8,5))
	for x in range(dungeon._dimensions.x):
		for y in range(dungeon._dimensions.y):
			dungeon.rooms[x][y] = rng.spawn_random_room()


#Proc-Gens a new dungeon grid, overwriting any existing.
func place_room_tile(cell_position : Vector2i) -> void:
	var room : Room = dungeon.rooms[cell_position.x][cell_position.y]
	room.set_array_position(cell_position)
	room_tiles.set_cell(room.get_array_position() + top_left_boundary, 0, room.get_atlas_position(), room.get_alt_tile_id())


#Contract: Callable needs Vector2i as a parameter
func iterate_over_rectangle(cell_function : Callable) -> void:
	for x in range(dungeon._dimensions.x):
		for y in range(dungeon._dimensions.y):

			cell_function.call(Vector2i(x,y))
