class_name DamageCounter extends Node2D

var damage: int
@export var label: Label
@onready var tween = create_tween()
@onready var text: String = label.text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(damage)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	tween.tween_property(self, "position", position + Vector2(0, - 400), 4)
	await get_tree().create_timer(4).timeout
