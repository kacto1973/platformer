extends CharacterBody2D

# 1. VARIABLES BÁSICAS
@export var velocidad: float = 50.0  # Velocidad de movimiento
@export var tiempo_entre_ataques: float = 2.0  # Cada 2 segundos ataca
var jugador_visto: bool = false  # ¿Ve al jugador?
var vida: int = 3  # Vida del enemigo

# 2. REFERENCIAS A NODOS (conéctalas en el editor)
@onready var sprite = $Sprite2D  # Tu sprite del enemigo
@onready var timer_ataque = $TimerAtaque  # Timer para atacar
@onready var punto_ataque = $PuntoAtaque  # Marker2D para lanzar
@onready var area_deteccion = $AreaDeteccion  # Area2D para ver jugador
@onready var animacion = $AnimationPlayer  # Opcional: para animaciones

# 3. CARGAR ESCENA DEL ATAQUE (debes crear "Ataque.tscn")
var escena_ataque = preload("res://Ataque.tscn")

func _ready():
	# Configurar timer
	timer_ataque.wait_time = tiempo_entre_ataques
	timer_ataque.start()
	
	# Conectar señales (si usas Area2D para detección)
	if area_deteccion:
		area_deteccion.body_entered.connect(_ver_jugador)
		area_deteccion.body_exited.connect(_perder_jugador)

func _physics_process(delta):
	if not jugador_visto:
		return  # No hacer nada si no ve al jugador
	
	# MOVIMIENTO HACIA EL JUGADOR
	var jugador = get_tree().get_nodes_in_group("Jugador")
	if jugador.size() > 0:
		var direccion = (jugador[0].global_position - global_position).normalized()
		
		# Girar sprite según dirección
		if direccion.x > 0:
			sprite.flip_h = false
			if punto_ataque:
				punto_ataque.position.x = abs(punto_ataque.position.x)
		else:
			sprite.flip_h = true
			if punto_ataque:
				punto_ataque.position.x = -abs(punto_ataque.position.x)
		
		# Mover enemigo
		velocity = direccion * velocidad
		move_and_slide()

# 4. FUNCIÓN PARA ATACAR (se llama automáticamente por el timer)
func _atacar():
	if not jugador_visto:
		return  # Solo atacar si ve al jugador
	
	# Crear el ataque
	var ataque = escena_ataque.instantiate()
	get_parent().add_child(ataque)
	ataque.global_position = punto_ataque.global_position
	
	# Dirección hacia el jugador
	var jugador = get_tree().get_nodes_in_group("Jugador")
	if jugador.size() > 0:
		var direccion = (jugador[0].global_position - punto_ataque.global_position).normalized()
		ataque.direccion = direccion
	
	# Animación de ataque (opcional)
	if animacion:
		animacion.play("atacar")

# 5. DETECCIÓN DEL JUGADOR
func _ver_jugador(body):
	if body.is_in_group("Jugador"):
		jugador_visto = true
		print("¡Jugador detectado!")

func _perder_jugador(body):
	if body.is_in_group("Jugador"):
		jugador_visto = false
		print("Jugador perdido")

# 6. RECIBIR DAÑO (si el jugador te ataca)
func recibir_dano(cantidad: int):
	vida -= cantidad
	print("Enemigo golpeado. Vida restante: ", vida)
	
	if vida <= 0:
		_morir()

func _morir():
	print("Enemigo muerto")
	queue_free()  # Eliminar enemigo

# 7. COLISIÓN CON JUGADOR (daño por contacto)
func _on_cuerpo_entrado(body):
	if body.is_in_group("Jugador"):
		body.recibir_dano(1)  # Llama a la función del jugador
