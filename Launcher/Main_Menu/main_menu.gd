extends Control

@onready var scroll_container = $ScrollContainer
@onready var hbox = $ScrollContainer/MarginContainer/HBoxContainer

var scroll_tween: Tween

func _ready() -> void:
	await get_tree().process_frame
	
	for card in hbox.get_children():
		card.focus_entered.connect(_on_card_focus.bind(card))
		if card.has_signal("start_game_requested"):
			card.start_game_requested.connect(_on_start_game_requested)
	
	if hbox.get_child_count() > 0:
		hbox.get_child(0).grab_focus()

func _on_card_focus(card: Control) -> void:
	if scroll_tween:
		scroll_tween.kill()
	var scrollbar = scroll_container.get_h_scroll_bar()

	# globale Positionen
	var card_center = card.global_position.x + card.size.x * 0.5
	var view_center = scroll_container.global_position.x + scroll_container.size.x * 0.5

	var target_scroll = scrollbar.value + (card_center - view_center)

	# clamp damit wir nicht über die Ränder scrollen
	target_scroll = clamp(
		target_scroll,
		scrollbar.min_value,
		scrollbar.max_value
	)

	scroll_tween = create_tween()
	scroll_tween.tween_property(scrollbar, "value", target_scroll, 0.18)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

func _on_start_game_requested(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

func _on_quit_button_pressed() -> void:
	# Desktop und Android
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
