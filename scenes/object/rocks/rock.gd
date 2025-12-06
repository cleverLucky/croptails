
extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var rock_scene = preload("res://scenes/object/rocks/stone.tscn")
var has_processed_max_damage = false  # 防止重复处理

func _ready() -> void:
	print("岩石初始化: ", name, " ID: ", get_instance_id())
	
	# 调试检查组件
	if !hurt_component:
		printerr("❌ 找不到 HurtComponent")
		return
		
	if !damage_component:
		printerr("❌ 找不到 DamageComponent")
		return
	
	# 连接信号
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reach.connect(on_max_damaged_reached)
	
	print("✅ 信号连接完成")

func on_hurt(hit_damage: int) -> void:
	print("岩石受到伤害: ", name, " 伤害值: ", hit_damage)
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damaged_reached() -> void:
	# 防止多次触发
	if has_processed_max_damage:
		print("⚠️ 已经处理过最大伤害，跳过")
		return
		
	has_processed_max_damage = true
	print("💥 达到最大伤害: ", name, " 位置: ", global_position)
	
	# 立即创建原木
	create_rock()
	
	# 延迟一帧后删除自己，确保原木先创建
	await get_tree().process_frame
	print("🗑️ 删除树节点: ", name)
	queue_free()

func create_rock() -> void:
	print("创建岩石，岩石位置: ", global_position)
	
	# 获取父节点（确保在树删除前获取）
	var parent = get_parent()
	if not parent:
		print("❌ 没有父节点，尝试添加到场景根节点")
		parent = get_tree().current_scene
	
	if parent:
		var rock_instance = rock_scene.instantiate() as Node2D
		rock_instance.global_position = global_position
		parent.add_child(rock_instance)
		print("岩石创建成功: ", rock_instance.name)
	else:
		printerr("❌ 无法找到父节点添加岩石")
