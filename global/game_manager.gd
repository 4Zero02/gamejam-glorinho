extends Node

signal pontuacao_atualizada(novo_valor: int)
signal erros_atualizados(qunatidade: int)

var pontos_totais: int = 0
var erros_cometidos = 0
var limite_erros = 3

const CAMINHO_SAVE = "user://top_scores.save"
var top_pontuacoes: Array = [0, 0, 0, 0, 0]

func _ready() -> void:
	carregar_top_5()

func adicionar_pontos(valor: int):
	pontos_totais += valor
	pontuacao_atualizada.emit(pontos_totais)

func registrar_erro():
	erros_cometidos += 1
	erros_atualizados.emit(erros_cometidos)
	
	if erros_cometidos >= limite_erros:
		chamar_game_over()

func chamar_game_over():
	get_tree().change_scene_to_file("res://telas/game_over.tscn")

func resetar_status():
	pontos_totais = 0
	erros_cometidos = 0

func verificar_e_atulizar_top_5(nova_pontuacao: int):
	top_pontuacoes.append(nova_pontuacao)
	
	top_pontuacoes.sort_custom(func(a, b): return a>b)
	
	if top_pontuacoes.size() > 5:
		top_pontuacoes.resize(5)
	
	salvar_top_5()
	

func salvar_top_5():
	var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	if arquivo:
		arquivo.store_var(top_pontuacoes)
		arquivo.close()

func carregar_top_5():
	if FileAccess.file_exists(CAMINHO_SAVE):
		var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		if arquivo:
			top_pontuacoes = arquivo.get_var()
			arquivo.close()
