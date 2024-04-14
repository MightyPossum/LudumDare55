extends CanvasLayer

	
func _process(delta):
	if GLOBALVARIABLES.build != null:
		build_panel(GLOBALVARIABLES.build)

func build_panel(show:bool):
	if show == true:
		%build_hud.visible = true
	else:
		%build_hud.visible = false
