extends Node
@export var mob_scene: PackedScene
@export var mob_speed = 250.0
var score
var playing=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	playing=false
	#new_game() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $HUD/StartButton.visible:
		if Input.is_action_pressed("A_Button"):
			new_game()
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	get_tree().call_group("all_mobs", "queue_free")
	$Music.play()
	score = 0
	playing=true
	$HUD/StartButton.hide()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position) # Replace with function body.
	$StartTimer.start()
	

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	#spawn from the bottom
	mob_spawn_location.progress_ratio = randf_range(0.5,0.7)
	#spawn from everywhere
	mob_spawn_location.progress_ratio = randf_range(0.0,1.0)
	
	var direction = mob_spawn_location.rotation+ PI/2
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI/4,PI/4)
	mob.rotation=direction
	
	#fast mobs
	#var mobspeed = 250.0
	var velocity = Vector2(mob_speed*randf_range(1.0,1.2),0)
	mob.linear_velocity = velocity.rotated(direction)
	if velocity.rotated(direction).x<0:
		mob.flip_y()
	add_child(mob)	

	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
