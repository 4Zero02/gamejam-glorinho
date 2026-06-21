extends Control



func _on_novo_jogo_pressed() -> void:
	get_tree().change_scene_to_file("res://telas/tela_de_jogo.tscn")




func _on_sair_pressed() -> void:
	get_tree().quit()
