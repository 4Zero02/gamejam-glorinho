extends Control

func _ready() -> void:
	exibir_ranking()
	$Pontuacao_final.text = "Sua pontuação: " + str(GameManager.pontos_totais)

func exibir_ranking():
	var texto_ranking = "Maiores pontuações \n\n"
	
	for i in range(GameManager.top_pontuacoes.size()):
		var posicao = i + 1
		var pontos = GameManager.top_pontuacoes[i]
		texto_ranking += str(posicao) + "° lugar: " + str(pontos) + "pts\n"

func _on_jogar_novamente_pressed() -> void:
	GameManager.resetar_status()
	get_tree().change_scene_to_file("res://telas/tela_de_jogo.tscn")


func _on_menu_pressed() -> void:
	GameManager.resetar_status()
	get_tree().change_scene_to_file("res://telas/menu.tscn")
