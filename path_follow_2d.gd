extends PathFollow2D

var velocidad := 0.2
var ultima_posicion: float = 0.0

# Estados
var estado := "idle"   # "idle" | "walk"
var tiempo_estado := 0.0

func _ready():
	# Tiempo inicial en idle
	tiempo_estado = randf_range(1.0, 3.0)
	$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("idle")

func _process(delta):
	tiempo_estado -= delta

	if estado == "idle":
		# No se mueve
		if tiempo_estado <= 0.0:
			# Cambiar a caminar
			estado = "walk"
			tiempo_estado = randf_range(2.0, 4.0)
			$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("caminando")

	elif estado == "walk":
		# Moverse por el path
		progress_ratio += velocidad * delta

		# Flip según dirección
		if position.x < ultima_posicion:
			$Enemigo/AgentAnimatorEnemy/Sprite2D.flip_h = true
		elif position.x > ultima_posicion:
			$Enemigo/AgentAnimatorEnemy/Sprite2D.flip_h = false

		ultima_posicion = position.x

		if tiempo_estado <= 0.0:
			# Volver a idle
			estado = "idle"
			tiempo_estado = randf_range(1.0, 3.0)
			$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("idle")
