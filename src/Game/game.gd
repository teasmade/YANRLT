class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 16

@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var map: Map = $Map


func _ready() -> void:
	player = Entity.new(Vector2i.ZERO, player_definition)
	var camera: Camera2D = $Camera2D
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	map.update_fov(player.grid_position)

func get_map_data() -> MapData:
	return map.map_data

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		var previous_player_position: Vector2i = player.grid_position
		action.perform(self, player)
		_handle_enemy_turns()
		map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity == player:
			continue
		print("The %s wonders when it will get to take a real turn." % entity.get_entity_name())
