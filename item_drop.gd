extends Area2D
class_name ItemDrop

@export var velocidade: float = 200

var nome_do_item:String
var pontuação_do_item:int

@onready var sprite : Sprite2D

func montar_item(recurso:Resource):
	nome_do_item = recurso.nome
	pontuação_do_item = recurso.pontos
	
	if sprite:
		sprite = recurso.textura

func _process(delta: float) -> void:
	position.y += velocidade * delta
	
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		coletar()

func coletar() -> void:
	queue_free()
