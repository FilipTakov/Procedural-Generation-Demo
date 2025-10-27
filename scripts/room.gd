class_name Room
extends Resource


var entrance_count : int #= GlobalConstants.RoomShape.ONE_WAY
var angle : int # Must be 90, 180, or 270
var is_hallway : bool
var array_position : Vector2i

enum RoomShapes {EMPTY, ONE_WAY, TWO_WAY_HALL, TWO_WAY_CORNER, THREE_WAY, FOUR_WAY}

const room_shape_atlas_positions = {
	RoomShapes.EMPTY: Vector2i(0,4),
	RoomShapes.ONE_WAY: Vector2i(0,0),
	RoomShapes.TWO_WAY_CORNER: Vector2i(0,1),
	RoomShapes.TWO_WAY_HALL: Vector2i(1,1),
	RoomShapes.THREE_WAY: Vector2i(0,2),
	RoomShapes.FOUR_WAY: Vector2i(0,3),
}
const possible_entrance_counts = [0, 1, 2, 3, 4]

func _init(p_entrance_count : int = 0, p_angle : int = 0, p_is_hallway : bool = false, array_pos : Vector2i = Vector2i(0,0)):
	entrance_count = p_entrance_count
	angle = p_angle
	is_hallway = p_is_hallway
	array_position = array_pos

## Getters & Setters
func get_entrance_count() -> int:
	return entrance_count

func set_entrance_count(count : int) -> void:
	entrance_count = count

func get_angle() -> int:
	return angle

func set_angle(degrees : int) -> void:
	angle = degrees

func get_is_hallway() -> bool:
	return is_hallway

func set_is_hallway(status : bool) -> void:
	is_hallway = status

func get_array_position() -> Vector2i:
	return array_position

func set_array_position(given_position : Vector2i) -> void:
	array_position = given_position

#Gets Atlas Position
func get_atlas_position() -> Vector2i:
	var atlas_id : Vector2i = Vector2i(0,0)
	
	match entrance_count:
		0:
			atlas_id = room_shape_atlas_positions[RoomShapes.EMPTY]
		1:
			atlas_id = room_shape_atlas_positions[RoomShapes.ONE_WAY]
		2:
			if (is_hallway):
				atlas_id = room_shape_atlas_positions[RoomShapes.TWO_WAY_HALL]
			else:
				atlas_id = room_shape_atlas_positions[RoomShapes.TWO_WAY_CORNER]
		3:
			atlas_id = room_shape_atlas_positions[RoomShapes.THREE_WAY]
		4:
			atlas_id = room_shape_atlas_positions[RoomShapes.FOUR_WAY]
	return atlas_id

func get_alt_tile_id() -> int:
	#Edge Cases
	if (entrance_count == 4) or (entrance_count == 0) or (angle == 0):
		return 0
	if (entrance_count == 2) and (is_hallway):
		return 1
	#90=1,180=2,270=3
	return angle/90

func get_room_as_dictionary() -> Dictionary:
	var saved_room : Dictionary = {
		"entrance_count": entrance_count,
		"angle" : angle,
		"is_hallway" : is_hallway,
		"array_position" : array_position,
	}
	return saved_room

#Takes initializes room with dictionary.
func set_with_dictionary(data : Dictionary) -> void:
	entrance_count = int(data["entrance_count"])
	angle = int(data["angle"])
	is_hallway = int(data["is_hallway"])
	array_position = Vector2i((data["array_position"]))


func save_to_json() -> String:
	return SaveLoader.save_to_json(get_room_as_dictionary())
	
