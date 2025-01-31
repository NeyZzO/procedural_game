extends TileMap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Listen to mouse click, if clicks on a block remove the block;
	if Input.is_action_just_pressed("action1"):
		var mouse_pos: Vector2 = get_global_mouse_position();
		var cell_pos: Vector2i = mouse_pos / 16;
		if cell_pos.x <= 0: cell_pos.x -= 1;
		print(cell_pos);
		set_cell(0, cell_pos, 0, Vector2i(-1, -1), 0);
