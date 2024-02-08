extends Control

var running := false
var selected_project: Project = null : set = _set_selected_project

func _set_selected_project(value: Project) -> void:
	selected_project = value
	if selected_project != null:
		%Title.text = selected_project.title
		%Title.show()
		update_time()
		%Time.show()
		%StartButton.show()
	else:
		%Title.hide()
		%Time.hide()
		%StartButton.hide()

func _ready():
	%ProjectSelectionContainer.show()
	%Title.hide()
	%Time.hide()
	%StartButton.hide()
	%PauseButton.hide()
	FileManager.load_projects()
	update_selection_options()
	if len(FileManager.projects) > 0:
		_on_project_selection_item_selected(0)

func _process(_delta):
	if Input.is_action_just_pressed("enter") and not running:
		var p = Project.new()
		p.title = %NewProjectEdit.text
		p.elapsed_seconds = 0
		FileManager.projects.append(p)
		FileManager.save_projects()
		selected_project = p
		update_selection_options()

func update_selection_options() -> void:
	%ProjectSelection.clear()
	var idx: int = 0
	for project in FileManager.projects:
		%ProjectSelection.add_item(project.title, idx)
		if selected_project != null and project.title == selected_project.title:
			%ProjectSelection.selected = idx
		idx += 1

func update_time() -> void:
	var raw_seconds = selected_project.elapsed_seconds
	var hours = raw_seconds / 3600
	var minutes = (raw_seconds % 3600) / 60
	var seconds = raw_seconds % 60
	%Time.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

func _on_time_emitter_timer_timeout():
	if not running: return
	selected_project.elapsed_seconds += 1
	update_time()

func _on_start_button_pressed():
	running = true
	%ProjectSelectionContainer.hide()
	%StartButton.hide()
	%PauseButton.show()

func _on_pause_button_pressed():
	running = false
	%ProjectSelectionContainer.show()
	%PauseButton.hide()
	%StartButton.show()

func _on_auto_save_timer_timeout():
	if selected_project == null: return
	FileManager.save_projects()

func _on_project_selection_item_selected(idx):
	_on_auto_save_timer_timeout()
	selected_project = FileManager.projects[idx]
