extends Resource
class_name Project

@export var title: String
@export var elapsed_seconds: int

static func from_dict(dict: Dictionary) -> Project:
	var p = Project.new()
	p.title = dict["title"]
	p.elapsed_seconds = dict["elapsed-seconds"]
	return p

func to_dict() -> Dictionary:
	return {
		"title": title,
		"elapsed-seconds": elapsed_seconds,
	}
