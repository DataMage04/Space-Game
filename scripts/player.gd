extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Graphics/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer

@export var speed = 400
@export var boost_speed = 600
@export var rotation_speed = 3
@export var bullet1 : PackedScene
@export var bullet2 : PackedScene

const acceleration = 0.3
const boost_acceleration = 0.6

var rotation_direction = 0
var thrust : float
var boost : bool = false
var health = 100
var dead = false

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	thrust = Input.get_axis("reverse", "forward")
	boost = Input.is_action_pressed("boost")
	velocity = lerp(velocity, transform.x * thrust * speed, acceleration)
	if Input.is_action_just_pressed("shoot_1"):
		shoot("1")
	if Input.is_action_just_pressed("shoot_2"):
		shoot("2")
	if boost:
		velocity = lerp(velocity, transform.x * thrust * boost_speed, boost_acceleration)
	if thrust != 0:
		if boost:
			animated_sprite_2d.play("boost")
		else:
			animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")

func _physics_process(delta):
	if dead:
		return
	get_input()
	destroyed()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
func shoot(title : String):
	match title:
		"2":
			$Graphics/Attack2.show()
			animation_player.play("attack_2")
			await get_tree().create_timer(0.1).timeout
			var b = bullet2.instantiate()
			owner.add_child(b)
			b.transform = $Muzzle.global_transform
			animation_player.stop()
			$Graphics/Attack2.hide()
		"1":
			$Graphics/Attack1.show()
			animation_player.play("attack_1")
			await get_tree().create_timer(0.4).timeout
			var b = bullet1.instantiate()
			owner.add_child(b)
			b.transform = $Muzzle.global_transform
			animation_player.stop()
			$Graphics/Attack1.hide()


func damage(damage_taken):
	$Graphics/Damage.show()
	animation_player.play("damage")
	health -= damage_taken
	print(health)
	await get_tree().create_timer(0.8).timeout
	animation_player.stop()
	$Graphics/Damage.hide()

func destroyed():
	if dead:
		return
	if health <= 0:
		dead = true
		print("I'm dead")
		$CollisionPolygon2D.disabled = true
		animated_sprite_2d.play("destroyed")
		z_index = -1
	else:
		pass
