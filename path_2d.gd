extends Path2D
var velocidad = 0.3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio = delta * velocidad	
