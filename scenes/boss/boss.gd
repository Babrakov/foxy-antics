extends Node2D

const  TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var _invincible: bool = false

func set_invincible(v: bool) -> void:
	_invincible = v
	if v == true:
		state_machine.travel("hit")

func take_damage() -> void:
	if _invincible == true:
		return
		
	set_invincible(true)

func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree[TRIGGER_CONDITION] = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	take_damage()
