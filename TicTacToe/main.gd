extends Node
@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var player : int
var boardSize: int
var cellSize: int
var gridPos : Vector2i
var gridData : Array
var gameOver :  bool

func _ready():	
	newGame()
func _input(event):
	$circle.modulate.a = (1 if player == 1 else 0)
	$cross.modulate.a = (1 if player == -1 else 0)
	if event is InputEventMouseButton and !gameOver:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and event.position.x < boardSize:
			gridPos = Vector2i (event.position / cellSize)
			if gridData[gridPos.y][gridPos.x] == 0:
				gridData[gridPos.y][gridPos.x] = player
				addPiece(player, gridPos)
				if is_win(gridData, gridPos):
					$Label.modulate.a = 1
					gameOver = true
					if player == 1: $Label.modulate = Color.GREEN
					else: $Label.modulate = Color.RED
				player *= -1
				
func is_win(gridData, gridPos):
	var count = [0,0,0,0]
	for i in range(3): count[0] += (1 if gridData[gridPos.y][i] == gridData[gridPos.y][gridPos.x] else 0)
	for i in range(3): count[1] += (1 if gridData[i][gridPos.x] == gridData[gridPos.y][gridPos.x] else 0)
	for i in range(3): count[2] += (1 if gridData[i][i] == gridData[gridPos.y][gridPos.x] else 0)
	for i in range(3): count[3] += (1 if gridData[i][2-i] == gridData[gridPos.y][gridPos.x] else 0)

	for c in count:
		if c == 3: return true
	return false

func newGame():
	$Label.modulate.a = 0
	$circle.modulate.a = 0
	$cross.modulate.a = 0
	gameOver = false
	player = 1
	boardSize = $chess.texture.get_width() * 25
	cellSize = boardSize / 3
	gridData =  [ [0,0,0], [0,0,0], [0,0,0] ]
	
func addPiece(player, position):
	#create a marker
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position * cellSize + Vector2i(cellSize / 2,cellSize / 2 )
		circle.scale = Vector2(25, 25)
		add_child(circle)
	else:
		var cross = cross_scene.instantiate()
		cross.position = position * cellSize + Vector2i(cellSize / 2,cellSize / 2 )
		cross.scale = Vector2(25, 25)
		add_child(cross)
