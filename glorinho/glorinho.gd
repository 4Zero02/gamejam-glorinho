extends CharacterBody2D

const SPEED = 300.0

@onready var sprite = $Sprite2D

@export var roupa_padrao: Texture2D
@export var roupa_milho: Texture2D
@export var roupa_acai: Texture2D
@export var roupa_farinha: Texture2D

func _ready() -> void:
	GameManager.festival_inicado.connect(_on_festival_iniciado)
	GameManager.festival_encerrado.connect(_on_festival_encerrado)
	
	mudar_roupa_normalizada(roupa_padrao)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var tamanho_da_tela = get_viewport_rect().size
	position.x = clamp(position.x,30 , tamanho_da_tela.x-30)
	
	move_and_slide()

func _process(delta) -> void:
	var tamanho_tela = get_viewport_rect().size
	position.x = clamp(position.x, 30, tamanho_tela.x - 30)

func mudar_roupa_normalizada(nova_textura: Texture2D):
	# Se a textura não foi colocada no Inspetor, ignora para não dar erro
	if sprite == null or nova_textura == null: 
		return
	
	# Aplica a textura nova
	sprite.texture = nova_textura
	
	# Faz a mágica de normalizar o tamanho do personagem para 80x80 pixels
	var tamanho_desejado = Vector2(80.0, 80.0)
	var tamanho_original = nova_textura.get_size()
	sprite.scale = tamanho_desejado / tamanho_original

func _on_festival_iniciado(nome_festival:String):
	if sprite == null:
		return
	
	match nome_festival:
		"milho":
			if roupa_milho: sprite.texture = roupa_milho
		"acai":
			if roupa_acai: sprite.texture = roupa_acai
		"farinha":
			if roupa_farinha: sprite.texture = roupa_farinha

func _on_festival_encerrado():
	if sprite and roupa_padrao:
		sprite.texture = roupa_padrao
