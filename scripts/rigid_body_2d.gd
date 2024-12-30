extends RigidBody2D

@export var bullet : PackedScene

func _physics_process(delta: float) -> void:
	var b = bullet.instantiate()
	owner.add_child(b)
	b.transform = $Marker2D.global_transform
