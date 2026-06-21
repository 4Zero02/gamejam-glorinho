extends Node

@export var pasta_objetos = "res://recursos/"
@export var cena_base: PackedScene

var recursos_carregados: Array[Resource] = []

var tempo_spawn_atual: float = 2.0
var tempo_spawn_minimo: float = 0.4
var reducao_por_spawn: float = 0.02

var spawn_timer: Timer

func _ready() -> void:
	carregar_recursos_da_pasta()
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = tempo_spawn_atual
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_timer_timeout)
	add_child(spawn_timer)
	

func carregar_recursos_da_pasta() -> void:
	var dir = DirAccess.open(pasta_objetos)
	if dir:
		for arquivo in dir.get_files():
			var nome_limpo = arquivo.trim_suffix(".remap")
			if nome_limpo.ends_with(".tres"):
				var caminho_completo = pasta_objetos + nome_limpo
				var recurso = load(caminho_completo)
				if recurso:
					recursos_carregados.append(recurso)
		print("recursos carregados com sucesso")
	else:
		push_error("não foi possivel acessa a pasta: " + pasta_objetos)

func spawnar_item() -> void:
	if recursos_carregados.is_empty():
		return
	
	var recurso_escolhido = recursos_carregados.pick_random()
	
	var novo_item = cena_base.instantiate() as ItemDrop
	
	var largura_da_tela = get_viewport().get_visible_rect().size.x
	var posicao_x_aleatoria = randf_range(50.0,largura_da_tela - 50)
	novo_item.position = Vector2(posicao_x_aleatoria,-50)
	
	add_child(novo_item)
	
	novo_item.montar_item(recurso_escolhido)
	
func _on_timer_timeout():
	spawnar_item()
	
	if tempo_spawn_atual > tempo_spawn_minimo:
		tempo_spawn_atual -= reducao_por_spawn
		
		if tempo_spawn_atual < tempo_spawn_minimo:
			tempo_spawn_atual = tempo_spawn_minimo
	
	spawn_timer.wait_time = tempo_spawn_atual
