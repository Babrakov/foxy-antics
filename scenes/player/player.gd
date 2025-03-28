extends CharacterBody2D

class_name Player
enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shooter: Shooter = $Shooter
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var invincible_player: AnimationPlayer = $InvinciblePlayer
 
var _state: PlayerState = PlayerState.IDLE
var _invincible: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	get_input()
	move_and_slide()
	calculate_states()
	update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()       

func update_debug_label() -> void:
	debug_label.text = "floor:%s inv:%s\n%s\nvel(%.0f,%.0f)" % [
		is_on_floor(), _invincible,
		PlayerState.keys()[_state],
		velocity.x, velocity.y
	]

func shoot() -> void:
	if sprite_2d.flip_h:
		shooter.shoot(Vector2.LEFT)
	else:
		shooter.shoot(Vector2.RIGHT)
	

func get_input() -> void:
	velocity.x = 0
	if Input.is_action_pressed("left") == true:
		velocity.x = -RUN_SPEED
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right") == true:
		velocity.x = RUN_SPEED
		sprite_2d.flip_h = false
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

func set_state(new_state: PlayerState) -> void:
	if _state == new_state:
		return
	
	_state = new_state
	
	match _state:
		PlayerState.RUN:
			animation_player.play("run")
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.JUMP:
			animation_player.play("jump")
		PlayerState.FALL:
			animation_player.play("fall")


func calculate_states() -> void:
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)
		else:
			set_state(PlayerState.JUMP )

func go_invincible() -> void:
	_invincible = true
	invincible_player.play("invincible")
	invincible_timer.start()

func apply_hit() -> void:
	if _invincible == true:
		return
	go_invincible()

func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()

func _on_hit_box_area_entered(area: Area2D) -> void:
	apply_hit() 
