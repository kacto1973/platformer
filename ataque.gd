extends Area2D

@export var velocidad := 250.0
var direccion := Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Movimiento del hacha
	position += direccion * velocidad * delta
	
	# Rotación del hacha 
	rotation += 6 * delta

func _on_body_entered(body):
	if body.is_in_group("Jugador"):
		# Matar al jugador
		if body.has_method("morir_por_caida"):
			body.morir_por_caida()
		else:
			body.queue_free()

		# El hacha desaparece al pegar
		queue_free()
