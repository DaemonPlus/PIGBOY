extends Timer

const CROW = preload("res://src/Crow.tscn")

var lastcrowpos := Vector2()

signal autokill

func _ready():
	self.connect("timeout", self, "_on_timeout")
	Global.won = false
	if Global.firstrun:
		$"../Player".hide()
		$"../StartSprite".show()
		Global.gameover = true
		$StartupSound.play()
		yield($StartupSound, "finished")
		Global.gameover = false
		Global.firstrun = false
		self.start()
		$"../Player".show()
		$"../StartSprite".hide()
	else:
		Global.gameover = false
		self.start()

func _on_timeout():
	Global.worldtime += 1
	if !Global.worldtime % 2:
		spawn_crows(1*Global.worldtime/3)
	else:
		spawn_crows(randi() % 2)
	if Global.worldtime == Global.WORLDTIMELIMIT:
		if Global.score >= Global.WINSCORE:
			Global.won = true
			$"../WinnerSprite".show()
		else:
			$"../GameoverSprite".show()
		emit_signal("autokill")

func spawn_crows(count: int):
	for i in count:
		var tmppos := Vector2(Global.GRIDSIZE+32*Global.rng.randi_range(1, Global.MAXSTEPS-2),Global.GRIDSIZE-8)
		var dir := 0.0
		match tmppos.x:
			48.0:
				dir = 1.0
			80.0:
				dir = -1.0
			112.0:
				dir = 1.0
			144.0:
				dir = -1.0
			176.0:
				dir = 1.0
			
		if tmppos != lastcrowpos:
			lastcrowpos = tmppos
			var crow := CROW.instance()
			crow.position = Vector2(tmppos)
			crow.set_direction(dir)
			connect("timeout", crow, "_on_WorldTimer_timeout")
			get_parent().add_child(crow)
	lastcrowpos = Vector2()

func _on_Player_gameover() -> void:
	stop()
