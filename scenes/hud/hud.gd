extends Control

@onready var score_label: Label = $MC/HB/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MC/HB/HBHearts
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_label_complete: VBoxContainer = $ColorRect/VBLabelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver

var _hearts: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hearts = hb_hearts.get_children()
	SignalManager.on_game_started.connect(on_player_hit)
	SignalManager.on_player_hit.connect(on_player_hit)

func on_player_hit(lives: int) -> void:
	for life in range(_hearts.size()):
		_hearts[life].visible = lives > life
