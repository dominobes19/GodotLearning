extends Node2D

@onready var etimer = get_node("Player/DashTimer")
@onready var ebar = get_node("Camera/EBar")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _physics_process(delta):
	ebar.value = etimer.time_left


func spawn_mob():
	var new_mob = preload("res://mobs.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_mob_spawn_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true


# TODO list (game extension ideas):
"""
1) Add a wave system (displays wave number, 
	slightly grows in difficulty)
2) Add MOBA abilities
3) Add attack animation movement lock-out
	(allow turning or inputting another movement 
	command to interrupt this. If this is after a set number of frames,
	the auto animation will cancel, but the auto will still get off!)
4) Use point and click move with a very fast polling rate
5) Implement attack move
6) Enemies explode and have a chance of 
	dropping some health or mana orbs that you should pick up
7) Add Lucian dash ability 
	(move in direction of mouse at either full distance,
	or allow for a quicker but shorter dash.
	dashing resets auto attack timer. Allow dashing over walls)
8) Add a mana bar -- using abilities will decrease until zero
	(mana should slowly regenerate on its own)
9) Add the culling ultimate ability
	(absolutely shreds through waves)
10) Add bounds to the map
11) Add walls to the map
12) Add some teleporters with a very long cooldown
	(and a slightl delay on use -- cant be instantaneous)
13) Different enemy types
	(one type of enemy will shoot slow projectiles back!)
"""

