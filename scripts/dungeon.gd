class_name Dungeon
extends Resource


@export var _dimensions : Vector2i 			#bounds
@export var _start : Vector2i 				#start point
@export var _critical_path_length : int 	#the main route
@export var _branches : int 				#number of side paths
@export var _branches_length : Vector2i 	#min, max

var rooms : Array							#2x2 array

func _init(
	p_dimensions : Vector2i = Vector2i(30, 30), 
	p_start : Vector2i = Vector2i(10, 10), 
	p_critical_path_length : int = 8, 
	p_branches : int = 3,
	p_branches_length : Vector2i = Vector2i(1, 4)
	):
	
	_dimensions = p_dimensions
	_start = p_start
	_critical_path_length = p_critical_path_length
	_branches = p_branches
	_branches_length = p_branches_length
	#Sets up array
	_initialize_dungeon()


#set all values to 0
func _initialize_dungeon() -> void:
	rooms = []
	for x in _dimensions.x:
		rooms.append([])
		for y in _dimensions.y:
			rooms[x].append(Room.new())

# Un-initializes room instances
func clear_rooms() -> void:
	rooms = []
	

func get_dungeon_as_dictionary() -> Dictionary:
	var saved_dungeon : Dictionary = {
		"_dimensions": _dimensions,
		"_start" : _start,
		"_critical_path_length" : _critical_path_length,
		"_branches" : _branches,
		"_branches_length" : _branches_length,
		"rooms" : rooms,
	}
	return saved_dungeon

#Takes initializes room with dictionary.
func set_with_dictionary(data : Dictionary) -> void:
	_dimensions = Vector2i(data["_dimensions"])
	_start = Vector2i(data["_start"])
	_critical_path_length = int(data["_critical_path_length"])
	_branches = int(data["_branches"])
	_branches_length = Vector2i((data["_branches_length"]))
	rooms = Array(data["rooms"])

func save_to_json() -> String:
	var cleaned_dungeon_dictionary : Dictionary = get_dungeon_as_dictionary()
	var json_rooms : Array = cleaned_dungeon_dictionary["rooms"]
	
	for x in range(_dimensions.x):
		for y in range(_dimensions.y):
			var room : Room = json_rooms[x][y]
			json_rooms[x][y] = room.save_to_json()
			
	#print(SaveLoader.save_to_json(get_dungeon_as_dictionary()))
	return SaveLoader.save_to_json(cleaned_dungeon_dictionary)
