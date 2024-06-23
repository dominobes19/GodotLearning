extends Node2D

@onready var screenSize: Vector2 = get_viewport().size
@onready var divScreenSize: Vector2 = Vector2(1.0, 1.0) / screenSize
@onready var mobaCamera = $mobaCamera

var cameraSpeed: float = 0.1
var positionRatio: Vector2 = Vector2(0.5, 0.5) # init mouse center first frame (avoids initial movement)
const MAXSPEED: float = 10.0 # defines the base movement shift of the camera


# Called when the node enters the scene tree for the first time.
func _ready():
	print("screenSize:", screenSize)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _input(event):
	if event is InputEventMouseMotion:
		positionRatio = (screenSize - event.position) * divScreenSize


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cameraMovement = Vector2(0,0)
	var move: bool = false
	# move camera if mouse has been registered as outer edges of screen
	if positionRatio.x > 0.98:
	#if positionRatio.x > 0.98 and positionRatio.x < 1:
		cameraMovement.x = -MAXSPEED
		move = true
	elif positionRatio.x < 0.02:
	#elif positionRatio.x < 0.02 and positionRatio.x > 0:
		cameraMovement.x = MAXSPEED
		move = true
	
	if positionRatio.y > 0.98:
	#if positionRatio.y > 0.98 and positionRatio.y < 1:
		cameraMovement.y = -MAXSPEED
		move = true
	elif positionRatio.y < 0.02:	
	#elif positionRatio.y < 0.02 and positionRatio.y > 0:	
		cameraMovement.y = MAXSPEED
		move = true

	if move:
		moveCamera(cameraMovement, delta)
		#global_position += cameraMovement

func moveCamera(direction, delta):
	#var cameraPosition = mobaCamera.get_translation()
	var cameraPosition = global_position
	var new_position = cameraPosition + direction
	var cameraTween = create_tween().set_parallel(true)
	#cameraTween.tween_property(self, "position", cameraPosition, cameraSpeed*delta).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	cameraTween.tween_property(self, "position", new_position,  cameraSpeed*delta).from_current().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#cameraTween.start()
