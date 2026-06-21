extends Label

func _ready() -> void:
	GameManager.erros_atulizados.connect(_on_erros_atualizados)
	
	_on_erros_atualizados(GameManager.itens_ruins_coletados)

func _on_erros_atualizados(erros_atuais: int):
	text = "Erros: " + str(erros_atuais) + " / " + str(GameManager.limite_erros)
