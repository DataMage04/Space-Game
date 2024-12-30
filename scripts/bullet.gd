extends Area2D

@export var speed = 1500

func _physics_process(delta):
	position += transform.x * speed * delta
	await get_tree().create_timer(2).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
