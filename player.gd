extends CharacterBody2D

signal health_depleted

const SPEED = 400
const DASH_SPEED = 1200
const DASH_MAX_DISTANCE = 250
var health = 100.0
#%HealthBar.max_value = health # why doesnt this work?

var click_position = Vector2()
var target_position = Vector2()
var dash_direction = Vector2()
var dash_distance = Vector2()
var mouse_distance = Vector2()

# ability timers
const BASE_Q_CD: float = 5.0
const BASE_W_CD: float = 5.0
const BASE_E_CD: float = 5.0
const BASE_R_CD: float = 20.0
var q_cd: float = 0.0
var w_cd: float = 0.0
var e_cd: float = 0.0
var r_cd: float = 0.0

func _ready():
	click_position = position
	
	# set ability timers (update with cdr later)
	#%QTimer.wait_time = BASE_Q_CD
	#%WTimer.wait_time = BASE_W_CD
	%DashTimer.wait_time = BASE_E_CD
	#%RTimer.wait_time = BASE_R_CD


func _physics_process(delta):
	if Input.is_action_just_pressed("right_click"):
		click_position = get_global_mouse_position()
		print("distance to click:", position.distance_to(click_position))
	
	#if position.distance_to(click_position) > 0:
	target_position = (click_position - position).normalized()
	velocity = target_position * SPEED
	move_and_slide()
	
	# perform lucian dash if not on CD
	if Input.is_action_just_pressed("E") and $DashTimer.is_stopped():
		%DashTimer.start() # begin CD timer
			
		dash_direction = global_position.direction_to(get_global_mouse_position())
		mouse_distance = global_position.distance_to(get_global_mouse_position())
		dash_distance = min(DASH_MAX_DISTANCE, mouse_distance)
		#velocity = dash_direction * DASH_SPEED
		#move_and_slide()
		var positionTween = create_tween()
		var new_position = position + dash_direction * dash_distance
		positionTween.tween_property(self, "position", new_position, 0.4).from_current().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		click_position = new_position
		velocity = Vector2(0,0)
		#positionTween.tween_property(self, "position", position + dash_direction * dash_distance, 0.1*delta).from_current().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
		
		
	#var direction = Input.get_vector("move_left", "move_right", 
									#"move_up", "move_down")
	#velocity = direction * SPEED
	#move_and_slide()
	
	
	
	# only play walk animation when in motion
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()



func _on_dash_timer_timeout():
	e_cd = 0
