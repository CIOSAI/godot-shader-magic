extends Control

# Shader is on Material of Page

@export var page_size:Vector2

func _ready():
	%Page.size = page_size
	%Page.material.set_shader_parameter("page_size", page_size)
	
	# demo
	var tw = create_tween().set_trans(Tween.TRANS_CIRC)
	tw.set_loops()
	tw.tween_method(
		func(f:float): %Page.material.set_shader_parameter("flip_progress", f),
		0.0,1.0,2.0
	)
	tw.tween_method(
		func(f:float): %Page.material.set_shader_parameter("flip_progress", f),
		1.0,0.0,2.0
	)
