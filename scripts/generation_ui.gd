extends CanvasLayer

@onready var save_namer: TextEdit = $MarginContainer/PCGCommands/Save/TextEdit
@onready var dungeon_1: Button = $MarginContainer2/SavesList/Dungeon1



func _ready() -> void:
	pass


# Signal Manager calls
func generate() -> void:
	SignalManager.generate_called.emit()
	
func reset_generation() -> void:
	SignalManager.reset_generation_called.emit()
	
func save_layout() -> void:
	SignalManager.save_called.emit()
	
func load_layout() -> void:
	SignalManager.load_called.emit()

# Button Signals
func _on_generate_button_up() -> void:
	generate()

func _on_reset_button_up() -> void:
	reset_generation()

func _on_save_button_up() -> void:
	dungeon_1.set_text("Load: " + str(save_namer.get_text()))
	save_layout()

func _on_load_button_up() -> void:
	load_layout()
