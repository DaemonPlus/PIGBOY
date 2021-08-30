extends Area2D

var haswater := false
var cur_frame := 0
var num_frames := 0

var cur_step := Global.MAXSTEPS

signal score_increase
signal water_got
signal gameover

func _ready() -> void:
	num_frames = $AnimatedSprite.get_sprite_frames().get_frame_count("move")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and !Global.gameover:
		move()

func move():
	cur_frame = (cur_frame + 1) % num_frames
	$AnimatedSprite.set_frame(cur_frame)
	if haswater:
		position += Vector2.RIGHT * Global.GRIDSIZE*2
		cur_step += 1
		if cur_step == Global.MAXSTEPS:
			haswater = false
			$AnimatedSprite.set_flip_h(false)
			Global.score += 1
			emit_signal("score_increase")
	else:
		position += Vector2.LEFT * Global.GRIDSIZE*2
		cur_step -= 1
		if cur_step == 1:
			haswater = true
			$AnimatedSprite.set_flip_h(true)
			emit_signal("water_got")

func _on_area_entered(area: Area2D) -> void:
	if (cur_step == 1 or cur_step == Global.MAXSTEPS):
		pass
	elif area.is_in_group("crows"):
		Global.gameover = true
		$"../GameoverSprite".show()
		$HitSound.play()
		yield($HitSound, "finished")
		game_over()

func game_over():
	if Global.score > Global.highscore:
		Global.highscore = Global.score
	Global.gameover = true
	if Global.won:
		$WinSound.play()
		yield($WinSound, "finished")
		yield(get_tree().create_timer(3), "timeout")
	else:
		$GameOverSound.play()
		yield($GameOverSound, "finished")
		yield(get_tree().create_timer(1), "timeout")
	get_tree().reload_current_scene()
	Global.reset()

func _on_WorldTimer_autokill() -> void:
	game_over()
