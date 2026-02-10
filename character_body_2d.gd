extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -500.0

var esta_vivo = true

func _ready():
	$AgentAnimator/AnimationPlayer.play("idle")

func _physics_process(delta):
	if not esta_vivo:
		return
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		
		if direction < 0:
			$AgentAnimator/Jugador.flip_h = true
		else:
			$AgentAnimator/Jugador.flip_h = false
		
		if $AgentAnimator/AnimationPlayer.current_animation != "caminando":
			$AgentAnimator/AnimationPlayer.play("caminando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if $AgentAnimator/AnimationPlayer.current_animation != "idle":
			$AgentAnimator/AnimationPlayer.play("idle")

	move_and_slide()

	# Caída mortal
	if global_position.y > 700:
		morir_por_caida()

func morir_por_caida():
	if not esta_vivo:
		return
	
	esta_vivo = false

	# Detener movimiento
	velocity = Vector2.ZERO

	# Desactivar colisiones
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true

	# Reproducir animación de muerte
	$AgentAnimator/AnimationPlayer.play("morir")

	# Esperar a que termine la animación
	await $AgentAnimator/AnimationPlayer.animation_finished

	# Eliminar jugador
	queue_free()
