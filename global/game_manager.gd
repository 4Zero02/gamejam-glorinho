extends Node

signal pontuacao_atualizada(novo_valor: int)
signal erros_atualizados(qunatidade: int)
signal festival_inicado(nome_do_festival: String)
signal festival_encerrado()


var pontos_totais: int = 0
var erros_cometidos = 0
var limite_erros = 3

const CAMINHO_SAVE = "user://top_scores.save"
var top_pontuacoes: Array = [0, 0, 0, 0, 0]

var festival_ativo:String = ""
var multiplicador_festival:int = 2
var lista_festivais: Array[String] = ["milho","acai","farinha"]

var timer_espera_festival: Timer
var timer_duracao_festival: Timer

func _ready() -> void:
	carregar_top_5()
	configurar_timer_festival()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
			if festival_ativo == "":
				print("🛠️ [DEBUG] Forçando início do festival via teclado...")
				_inciar_festival_aleatorio()

func configurar_timer_festival():
	timer_espera_festival = Timer.new()
	timer_espera_festival.one_shot = true
	timer_espera_festival.timeout.connect(_inciar_festival_aleatorio)
	add_child(timer_espera_festival)
	
	timer_duracao_festival = Timer.new()
	timer_duracao_festival.one_shot = true
	timer_duracao_festival.timeout.connect(_encerar_festival)
	add_child(timer_duracao_festival)
	
	timer_espera_festival.start(randf_range(15.0,20.0))

func _inciar_festival_aleatorio():
	festival_ativo = lista_festivais.pick_random()
	festival_inicado.emit(festival_ativo)
	timer_duracao_festival.start(15)

func _encerar_festival():
	festival_ativo = ""
	festival_encerrado.emit()
	
	timer_espera_festival.start(randf_range(30.0,50.0))

func adicionar_pontos(valor: int,tag_do_item:String = ""):
	var pontos_ganhos = valor
	
	if festival_ativo != "" and tag_do_item == festival_ativo:
		pontos_ganhos *= multiplicador_festival
		print("BÔNUS DE FESTIVAL! +", pontos_ganhos)
	
	pontos_totais += pontos_ganhos
	pontuacao_atualizada.emit(pontos_totais)

func registrar_erro():
	erros_cometidos += 1
	erros_atualizados.emit(erros_cometidos)
	
	if erros_cometidos >= limite_erros:
		chamar_game_over()

func chamar_game_over():
	verificar_e_atualizar_top_5(pontos_totais)
	get_tree().change_scene_to_file("res://telas/game_over.tscn")

func resetar_status():
	pontos_totais = 0
	erros_cometidos = 0

func verificar_e_atualizar_top_5(nova_pontuacao: int):
	top_pontuacoes.append(nova_pontuacao)
	
	top_pontuacoes.sort_custom(func(a, b): return a>b)
	
	if top_pontuacoes.size() > 5:
		top_pontuacoes.resize(5)
	
	salvar_top_5()


func salvar_top_5():
	var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.WRITE)
	if arquivo:
		arquivo.store_var(top_pontuacoes)
		print("pontuação salva")
		arquivo.close()

func carregar_top_5():
	if FileAccess.file_exists(CAMINHO_SAVE):
		var arquivo = FileAccess.open(CAMINHO_SAVE, FileAccess.READ)
		if arquivo:
			top_pontuacoes = arquivo.get_var()
			arquivo.close()
