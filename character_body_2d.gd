extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -600.0

# Variable para controlar si está vivo
var esta_vivo = true

func _ready():
	$AgentAnimator/AnimationPlayer.play("idle")

func _physics_process(delta):
	# Si está muerto, no procesar movimiento
	if not esta_vivo:
		return
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Dirección horizontal
	var direction = Input.get_axis("ui_left", "ui_right")

	# Movimiento + animación
	if direction != 0:
		velocity.x = direction * SPEED
		
		# Flip del sprite
		if direction < 0:
			$AgentAnimator/Jugador.flip_h = true
		else:
			$AgentAnimator/Jugador.flip_h = false
		
		# Animación caminar
		if $AgentAnimator/AnimationPlayer.current_animation != "caminando":
			$AgentAnimator/AnimationPlayer.play("caminando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Animación idle
		if $AgentAnimator/AnimationPlayer.current_animation != "idle":
			$AgentAnimator/AnimationPlayer.play("idle")

	move_and_slide()

	# Muerte por caída
	if global_position.y > 700:
		morir_por_caida()

# FUNCIÓN: Muerte por caída
func morir_por_caida():
	if not esta_vivo:
		return
	
	esta_vivo = false
	
	# Ocultar jugador
	hide()
	
	# Desactivar colisiones
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
	
	# Detener animaciones
	$AgentAnimator/AnimationPlayer.stop()
	
	print("💀 ¡Jugador murió por caída! Posición Y: ", global_position.y)
