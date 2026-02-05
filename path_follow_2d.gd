extends PathFollow2D
var velocidad = 0.3
var ultima_posicion: float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += velocidad * delta
	if position.x < ultima_posicion:
		$Enemigo/Sprite2D.flip_h = true #mueve a la izquierda
	elif position.x > ultima_posicion:
		$Enemigo/Sprite2D.flip_h = false #mueve a la derecha
	ultima_posicion = position.x
