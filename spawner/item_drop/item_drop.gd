extends Area2D
class_name ItemDrop

@export var velocidade: float = 200

var nome_do_item:String
var pontuação_do_item:int
var festival_tag: String = ""

@onready var sprite : Sprite2D

func montar_item(recurso:Resource):
	nome_do_item = recurso.nome
	pontuação_do_item = recurso.pontos
	
	if "festival_tag" in recurso:
		festival_tag = recurso.festival_tag
	
	var sprite = get_node_or_null("Sprite2D")
	
	if sprite and recurso.texture != null:
		sprite.texture = recurso.texture
	
		var tamanho_deseajado = Vector2(80.0,80.0)
		var tamanho_original = recurso.texture.get_size()
		sprite.scale = tamanho_deseajado / tamanho_original
	
func _process(delta: float) -> void:
	position.y += velocidade * delta
	
	if position.y > get_viewport_rect().size.y + 100:
		GameManager.registrar_erro()
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		coletar()

func coletar() -> void:
	GameManager.adicionar_pontos(pontuação_do_item, festival_tag)
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		coletar()
