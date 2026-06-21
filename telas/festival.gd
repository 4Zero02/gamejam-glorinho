extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	GameManager.festival_inicado.connect(_on_festival_iniciado)
	GameManager.festival_inicado.connect(_on_festival_encerrado)

func _on_festival_iniciado(nome_festival: String):
	var texto_bonito = nome_festival.capitalize()
	
	text = "FESTIVAL INICIADO\n" + texto_bonito + " COM PONTOS DUPLICADOS"
	visible = true

func _on_festival_encerrado():
	visible = false
