extends Area2D

const DAMAGE = 1.0
var distance_travelled = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	distance_travelled += SPEED * delta
	
	# destroy the bullet once it passes the outer range
	if distance_travelled > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
