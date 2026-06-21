extends Label

func _ready() -> void:
	GameManager.erros_atualizados.connect(_on_erros_atualizados)
	
	_on_erros_atualizados(GameManager.erros_cometidos)

func _on_erros_atualizados(erros_atuais: int):
	text = "Erros: " + str(erros_atuais) + " / " + str(GameManager.limite_erros)
