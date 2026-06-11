extends Node2D

# State & Member vars
var screen_size
var pad_size
var direction = Vector2(1.0,0.0)

#Ball speed variables (all in pixel/sec)
const INITIAL_BALL_SPEED = 80
var cur_ball_speed = INITIAL_BALL_SPEED
const PAD_SPEED = 150

func _ready() -> void:
	print("Ready Running") # shows on output - check if working
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)
	
func _process(delta: float) -> void:
	print("Process running") # prints in output
	# set inital ball & player vars
	var ball_pos = get_node("ball").position
	var left_rect = Rect2(get_node("left").position - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("right").position - pad_size*0.5, pad_size)
	
	# Integrate new ball position
	ball_pos += direction * cur_ball_speed * delta
	
	# Flip when touching edges
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y #flip by using negative
	# redirect ball if it touches player
	if ((left_rect.has_point(ball_pos)) or (right_rect.has_point(ball_pos))):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		cur_ball_speed *= 1.1
	
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size*0.5
		cur_ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		
	# move the ball
	get_node("ball").position = ball_pos
	
	# Start the pad stuff here (players)
	# Move left pad
	var left_pos = get_node("left").position

	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta

	get_node("left").position = left_pos

# Move right pad
	var right_pos = get_node("right").position

	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta

	get_node("right").position = right_pos
