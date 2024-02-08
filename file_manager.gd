extends Node

const SAVE_PATH = "user://projects.save"

var projects: Array = []

func load_projects() -> Array:
	if not FileAccess.file_exists(SAVE_PATH): return []
	var save = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(save.get_as_text())
	
	var projects = []
	for raw_proj in json:
		projects.append(Project.from_dict(raw_proj))
	
	self.projects = projects
	return self.projects

func save_projects() -> void:
	var serialized = []
	for proj in projects:
		serialized.append(proj.to_dict())
	
	var save = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save.store_string(JSON.stringify(serialized))
