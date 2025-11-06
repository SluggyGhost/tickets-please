extends Control

@onready var tickets_container: Node2D = $Tickets
@onready var accept_btn: Button = $AcceptButton
@onready var reject_btn: Button = $RejectButton
@onready var score_label: Label = $ScoreLabel
@onready var strikes_label: Label = $StrikesLabel
@onready var status_label: Label = $StatusLabel

@export var correctness: Array[bool] = [true, true, false, true, false, true, true, false, false, true, false, true, false, true, false, false, false, true, false, true]

var _tickets: Array[Node] = []
var _idx: int = 0
var _score: int = 0
var _strikes: int = 0
const MAX_STRIKES := 3

func _ready() -> void:
	# Collect tickets as they appear under the container
	_tickets = tickets_container.get_children()
	# Hide everything except the first
	for i in _tickets.size():
		_tickets[i].visible = (i == 0)
	
	status_label.text = ""
	_update_hud()
	
	if _tickets.is_empty():
		_end_game("No tickets found.")

func _judge(decision_is_accept: bool) -> void:
	if _is_game_over():
		return
	
	var _is_ticket_correct := _get_ticket_correctness(_idx)
	var chose_correct_action := (decision_is_accept == _is_ticket_correct)
	
	if chose_correct_action:
		_score += 1
	else:
		_strikes += 1
	
	_update_hud()
	
	if _strikes >= MAX_STRIKES:
		_end_game("Three strikes. Game Over!")
		return
	
	_advance()

func _advance() -> void:
	# Hide current
	if _idx < _tickets.size():
		_tickets[_idx].visible = false
	
	_idx += 1
	
	# If finished all tickets
	if _idx >= _tickets.size():
		_end_game("All tickets reviewed. Final score: %d" % _score)
		return
	
	# Show next ticket
	_tickets[_idx].visible = true

func _get_ticket_correctness(i: int) -> bool:
	# Prefer the exported array if it has an entry for i
	if i < correctness.size():
		return correctness[i]
	# Fallback: group-based tagging ("correct" group)
	var node := _tickets[i]
	return node.is_in_group("correct")

func _update_hud() -> void:
	score_label.text = "Score: %d" % _score
	strikes_label.text = "Strikes: %d / %d" % [_strikes, MAX_STRIKES]

func _end_game(msg: String) -> void:
	# Hide current ticket (if any)
	if _idx < _tickets.size():
		_tickets[_idx].visible = false
	# Lock input
	accept_btn.disabled = true
	reject_btn.disabled = true
	status_label.text = msg

func _is_game_over() -> bool:
	return accept_btn.disabled and reject_btn.disabled

func _on_accept_button_pressed() -> void:
	_judge(true)

func _on_reject_button_pressed() -> void:
	_judge(false)
