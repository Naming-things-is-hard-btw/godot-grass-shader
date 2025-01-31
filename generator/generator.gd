extends Control

@export var sub_vp : SubViewport
@export var preview : TextureRect

@export var gen_min = 1
@export var gen_max = 10
@export var resolution = 30
@export var scale_min = 0.05
@export var scale_max = 0.2
@export var target_rect : Rect2 = Rect2(0.5, 0.95, 0.04, 0.0)

@export var point_rect : Rect2 = Rect2(0,0,1,1)

func _on_generate_pressed() -> void:
	for child in sub_vp.get_children():
		child.queue_free()
	randomize()
	for i in range(randf_range(gen_min, gen_max)):
		var line = Line2D.new()
		line.gradient = preload("res://generator/gradient.tres")
		line.width_curve = preload("res://generator/curve.tres")
		line.width = randf_range(scale_min, scale_max) * (sub_vp.size.x/2.0)
		
		var pos = Vector2(
			randf_range(point_rect.position.x, point_rect.position.x+point_rect.size.x),
			randf_range(point_rect.position.y, point_rect.position.y+point_rect.size.y)
			)
		var target_pos = Vector2(
			randf_range(target_rect.position.x, target_rect.position.x+target_rect.size.x),
			randf_range(target_rect.position.y, target_rect.position.y+target_rect.size.y)
			)
		for a in range(resolution):
			var p_x = 1.0 - preload("res://generator/x.tres").sample_baked(float(a)/float(resolution))
			var p_y = 1.0 - preload("res://generator/y.tres").sample_baked(float(a)/float(resolution))
			line.add_point(
				Vector2(
					lerp(pos.x, target_pos.x, p_x),
					lerp(pos.y, target_pos.y, p_y)
					) * Vector2(sub_vp.size)
				)
			pass
		
		sub_vp.add_child(line)
		pass
	pass


func _on_save_pressed() -> void:
	await RenderingServer.frame_post_draw
	var image : Image = sub_vp.get_texture().get_image()
	image.save_png("res://generator/gen/" + str(DirAccess.get_files_at("res://generator/gen/").size()) + ".png")

func _draw() -> void:
	_on_generate_pressed()
	draw_rect(Rect2(target_rect.position*preview.size, target_rect.size*preview.size), Color.YELLOW, false, 5)
	draw_rect(Rect2(point_rect.position*preview.size, point_rect.size*preview.size), Color.BLUE, false, 5)
	pass

func _ready() -> void:
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer3/point_rect_x.value = point_rect.position.x * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer3/point_rect_y.value = point_rect.position.y * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer4/point_rect_w.value = point_rect.size.x * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer4/point_rect_h.value = point_rect.size.y * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer5/target_rect_x.value = target_rect.position.x * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer5/target_rect_y.value = target_rect.position.y * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer6/target_rect_w.value = target_rect.size.x * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer6/target_rect_h.value = target_rect.size.y * 100.0
	$PanelContainer/BoxContainer2/BoxContainer2/bake_res.value = resolution
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer/width_min.value = scale_min
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer/width_max.value = scale_max
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer2/count_min.value = gen_min
	$PanelContainer/BoxContainer2/BoxContainer2/HBoxContainer2/count_max.value = gen_max
	pass

func _on_point_rect_x_value_changed(value: float) -> void:
	point_rect.position.x = value / 100.0
	queue_redraw()

func _on_point_rect_y_value_changed(value: float) -> void:
	point_rect.position.y = value / 100.0
	queue_redraw()

func _on_point_rect_w_value_changed(value: float) -> void:
	point_rect.size.x = value / 100.0
	queue_redraw()

func _on_point_rect_h_value_changed(value: float) -> void:
	point_rect.size.y = value / 100.0
	queue_redraw()


func _on_target_rect_x_value_changed(value: float) -> void:
	target_rect.position.x = value / 100.0
	queue_redraw()

func _on_target_rect_y_value_changed(value: float) -> void:
	target_rect.position.y = value / 100.0
	queue_redraw()

func _on_target_rect_w_value_changed(value: float) -> void:
	target_rect.size.x = value / 100.0
	queue_redraw()

func _on_target_rect_h_value_changed(value: float) -> void:
	target_rect.size.y = value / 100.0
	queue_redraw()


func _on_bake_res_value_changed(value: float) -> void:
	resolution = value
	queue_redraw()


func _on_count_min_value_changed(value: float) -> void:
	gen_min = value
	queue_redraw()


func _on_count_max_value_changed(value: float) -> void:
	gen_max = value
	queue_redraw()


func _on_width_min_value_changed(value: float) -> void:
	scale_min = value
	queue_redraw()


func _on_width_max_value_changed(value: float) -> void:
	scale_max = value
	queue_redraw()
