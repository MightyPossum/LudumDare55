extends CanvasLayer

	
func _process(_delta):
	if GLOBALVARIABLES.build != null:
		build_panel(GLOBALVARIABLES.build)

func build_panel(_show:bool):
	if _show == true:
		%build_hud.visible = true
	else:
		%build_hud.visible = false
