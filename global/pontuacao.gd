extends Label

func _ready() -> void:
	GameManager.pontuacao_atualizada.connect(_on_pontuacao_atualizada)
	
	_on_pontuacao_atualizada(GameManager.pontos_totais)

func _on_pontuacao_atualizada(novo_valor:int):
	text = "Pontos: " + str(novo_valor)
