extends CharacterBody2D

@export var tiempo_entre_ataques := 2.0
@export var vida := 3

var jugador_visto := false

@onready var timer_ataque: Timer = $TimerAtaque
@onready var punto_ataque: Marker2D = $PuntoAtaque
@onready var area_deteccion: Area2D = $AreaDeteccion
@onready var sprite: Sprite2D = $AgentAnimatorEnemy/Sprite2D
@onready var animacion: AnimationPlayer = $AgentAnimatorEnemy/AnimationPlayer

var escena_ataque := preload("res://Ataque.tscn")

func _ready():
	timer_ataque.wait_time = tiempo_entre_ataques
	timer_ataque.one_shot = false
	timer_ataque.start()
	timer_ataque.timeout.connect(_atacar)

	area_deteccion.body_entered.connect(_ver_jugador)
	area_deteccion.body_exited.connect(_perder_jugador)

	animacion.play("idle")

func _physics_process(_delta):
	# STATIC: no movement
	pass

func _atacar():
	if not jugador_visto:
		return

	print("🪓 ATTACK!")

	var ataque = escena_ataque.instantiate()
	get_parent().add_child(ataque)
	ataque.global_position = punto_ataque.global_position

	var jugadores = get_tree().get_nodes_in_group("Jugador")
	if jugadores.size() == 0:
		return

	var direccion = (jugadores[0].global_position - punto_ataque.global_position).normalized()
	ataque.direccion = direccion

	animacion.play("atacar")

func _ver_jugador(body):
	if body.is_in_group("Jugador"):
		jugador_visto = true

func _perder_jugador(body):
	if body.is_in_group("Jugador"):
		jugador_visto = false

func recibir_dano(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		queue_free()
