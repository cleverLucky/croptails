class_name CollectableComponent
extends Area2D

@export var collectable_name: String
@export var collect_delay: float = 1.0  # 可收集延迟时间，可在检查器中调整
var original_layer: int 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(1.0).timeout
		get_parent().queue_free()
		print("collected")
