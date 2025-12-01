extends CanvasLayer

@onready var save_namer: TextEdit = $MarginContainer/PCGCommands/Save/TextEdit
@onready var dungeon_1: Button = $MarginContainer2/SavesList/Dungeon1





func _ready() -> void:
	pass


# Signal Manager calls
func generate(strategy : String) -> void:
	
	SignalManager.generate_called.emit(strategy)
	
func reset_generation() -> void:
	SignalManager.reset_generation_called.emit()
	
func save_layout() -> void:
	SignalManager.save_called.emit()
	
func load_layout() -> void:
	SignalManager.load_called.emit()

# Button Signals
func _on_random_numbers_button_up() -> void:
	generate("Num")

func _on_noise_button_up() -> void:
	generate("Noise")

func _on_reset_button_up() -> void:
	reset_generation()

func _on_save_button_up() -> void:
	dungeon_1.set_text("Load: " + str(save_namer.get_text()))
	save_layout()

func _on_load_button_up() -> void:
	load_layout()
