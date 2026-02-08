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
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_left"):
		$AgentAnimator/Jugador.flip_h = true
		$AgentAnimator/AnimationPlayer.play("caminando")
	if Input.is_action_just_pressed("ui_right"):
		$AgentAnimator/Jugador.flip_h = false
		$AgentAnimator/AnimationPlayer.play("caminando")
	
	move_and_slide()
	
	# VERIFICAR MUERTE POR CAÍDA (NUEVO)
	# Si cae más allá de Y = 700 píxeles, muere
	if global_position.y > 700:
		morir_por_caida()

# FUNCIÓN NUEVA: Muerte por caída
func morir_por_caida():
	# Evitar que se llame múltiples veces
	if not esta_vivo:
		return
	
	# Marcar como muerto
	esta_vivo = false
	
	# 1. Ocultar al jugador
	hide()
	
	# 2. Desactivar colisiones para que no interactúe más
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
	
	# 3. Detener animaciones
	$AgentAnimator/AnimationPlayer.stop()
	
	# 4. Mostrar mensaje en consola
	print("💀 ¡Jugador murió por caída! Posición Y: ", global_position.y)
	
