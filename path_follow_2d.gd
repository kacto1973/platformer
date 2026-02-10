extends PathFollow2D

var velocidad := 0.2
var ultima_posicion := 0.0

# Estados
var estado := "idle"
var tiempo_estado := 0.0

@export var escena_hacha: PackedScene
@export var tiempo_ataque := 2.0

var cooldown := 0.0

func _ready():
	tiempo_estado = randf_range(1.0, 3.0)
	$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("idle")

func _process(delta):
	tiempo_estado -= delta
	cooldown -= delta

	if estado == "idle":
		if tiempo_estado <= 0.0:
			estado = "walk"
			tiempo_estado = randf_range(2.0, 4.0)
			$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("caminando")

	elif estado == "walk":
		progress_ratio += velocidad * delta

		# Flip sprite
		if position.x < ultima_posicion:
			$Enemigo/AgentAnimatorEnemy/Sprite2D.flip_h = true
		elif position.x > ultima_posicion:
			$Enemigo/AgentAnimatorEnemy/Sprite2D.flip_h = false

		ultima_posicion = position.x

		if tiempo_estado <= 0.0:
			estado = "idle"
			tiempo_estado = randf_range(1.0, 3.0)
			$Enemigo/AgentAnimatorEnemy/AnimationPlayer.play("idle")

	# 🪓 ATAQUE (independiente del estado)
	if cooldown <= 0.0:
		lanzar_hacha()
		cooldown = tiempo_ataque

func lanzar_hacha():
	if escena_hacha == null:
		print("❌ No hay escena de hacha asignada")
		return

	var hacha = escena_hacha.instantiate()
	$Enemigo.get_parent().add_child(hacha)

	var dir := Vector2.RIGHT
	if $Enemigo/AgentAnimatorEnemy/Sprite2D.flip_h:
		dir = Vector2.LEFT

	hacha.global_position = $Enemigo.global_position + dir * 48
	hacha.direccion = dir
	hacha.duenio = $Enemigo
	
	print("🪓 Hacha lanzada desde: ", hacha.global_position)
	print("Enemigo en: ", $Enemigo.global_position)
	print("Dirección: ", dir)
	
	# Debug: Check if collision is immediately triggered
	await get_tree().physics_frame
	print("Hacha aún existe después de 1 frame: ", not hacha.is_queued_for_deletion())
