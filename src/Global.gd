extends Node

const GRIDSIZE := 16
const MAXSTEPS := 7
const WORLDTIMELIMIT := 30
const WINSCORE := 5

var score := 0
var highscore := 0
var worldtime := 0
var won := false

var gameover := false
var firstrun := true

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func reset():
	score = 0
	worldtime = 0
