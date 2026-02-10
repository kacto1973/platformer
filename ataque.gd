extends Area2D

@export var velocidad := 250.0
@export var distancia_max := 300.0

var direccion := Vector2.ZERO
var origen := Vector2.ZERO
var duenio: Node2D   # ← typed, no null inference issue

@onready var col := $CollisionShape2D

func _ready():
	await get_tree().physics_frame
	origen = global_position

	col.disabled = true
	await get_tree().physics_frame
	col.disabled = false

	body_entered.connect(_on_body_entered)
	
func _physics_process(delta):
	global_position += direccion * velocidad * delta
	rotation += 6 * delta

	var distancia = origen.distance_to(global_position)
	print("Distancia recorrida: ", distancia)
	
	if distancia >= distancia_max:
		print("Hacha eliminada por distancia")
		queue_free()

func _on_body_entered(body):
	if body == duenio:
		return

	if body.is_in_group("jugador"):
		if body.has_method("morir_por_caida"):
			body.morir_por_caida()
		else:
			body.queue_free()

	queue_free()
