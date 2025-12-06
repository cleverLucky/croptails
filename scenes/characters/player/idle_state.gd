extends NodeState

@export var player : Player
@export var animated_sprite_2d : AnimatedSprite2D

var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_physics_process(delta:float) -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")	
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	else:
		animated_sprite_2d.play("idle_front")
	
func _on_next_transitions() -> void:
	GameInputEvent.movement_input()
	if GameInputEvent.is_movement_input():
		transition.emit("Walk")
		
	if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvent.use_tool():
		transition.emit("Chopping")
		
	if player.current_tool == DataTypes.Tools.TileGround && GameInputEvent.use_tool():
		transition.emit("Tilling")
		
	if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvent.use_tool():
		transition.emit("Watering")
	
	
func _on_enter() -> void:
	pass
	
func _on_exit() -> void:
	animated_sprite_2d.stop()
	
func _on_process(delta:float) -> void:
	pass
