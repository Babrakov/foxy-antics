extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_game_over.connect(on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance"):
		GameManager.load_next_level_scene()
	if Input.is_action_just_pressed("quit"):
		GameManager.load_main_scene()
	#if Input.is_action_just_pressed("shoot"):
		#SignalManager.on_create_bullet.emit(
			#Vector2(70,-70),
			#Vector2(50,-50),
			#3.0,
			#1.0,
			#Constants.ObjectType.BULLET_PLAYER
		#)

func on_game_over() -> void:
	for mv in get_tree().get_nodes_in_group(Constants.MOVEABLES_GROUP):
		mv.set_process(false)
		mv.set_physics_process(false)
