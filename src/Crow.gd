extends Area2D

var direction := Vector2(0.0, 2.0)
var whichonelol := [-1.0, 1.0]

func _ready() -> void:
	#direction = Vector2(whichonelol[randi() % whichonelol.size()], 1)
	if direction.x == -1.0:
		$AnimatedSprite.play("left")
	else:
		$AnimatedSprite.play("right")

func set_direction(dir: float):
	direction.x = dir
	
func _on_WorldTimer_timeout():
	position += direction * Global.GRIDSIZE
	if direction.x == -1.0:
		$AnimatedSprite.play("left")
	else:
		$AnimatedSprite.play("right")
	#if position.x < 0+16:
	#	direction = Vector2(1, 1)
	#elif position.x > 480-16:
	#	direction = Vector2(-1, 1)
	if position.y > 272-32:
		queue_free()
	direction.x = -direction.x


func _on_area_entered(area: Area2D) -> void:
	pass
	
