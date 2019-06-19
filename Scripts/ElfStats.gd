extends Resource

class_name ElfStats

##################################################

class Stat:
	signal value_changed(me)
	
	var name : String
	var default_value : float = 0
	var value : float = 0 setget set_value, get_value
	var changers : Array = []
	
	func _init(n:String, dv:float=0):
		name = n
		default_value = dv
		set_value(dv)
		
	func set_value(v:float) -> void:
		value = v
		emit_signal("value_changed", self)
		
	func get_value() -> float:
		var changed_value = value
		
		for c in changers:
			changed_value = c.get_changed_value(changed_value)
		
		return changed_value
	
	func reset() -> void:
		value = default_value
		changers.clear()
	
	func named(n:String) -> bool:
		return name == n
		
	func add_changer(changer) -> void:
		changers.push_back(changer)
		emit_signal("value_changed", self)
		
##################################################

var stats = [
	Stat.new("bows_knowledge", 1),
	Stat.new("agility", 0.1),
	Stat.new("vitality", 10),
	Stat.new("charisma", 0),
	Stat.new("sensinitive_points", 0),
	Stat.new("eagle_eye", 0.1),
	Stat.new("strength", 1),
	Stat.new("magic", 0),
	Stat.new("lucky", 0),
	Stat.new("stamina", 10)
]

export(Array, Resource) var items

func restore_to_default() -> void:
	for s in stats:
		s.reset()
		
	items.clear()
		
func get_stat(stat_name:String) -> Stat:
	for s in stats:
		if s.named(stat_name):
			return s
	
	printerr("nonexist stat with name: \"" + stat_name + "\"")
	return null
	
func get_stat_value(stat_name:String) -> float:
	var stat = get_stat(stat_name)
	
	if stat:
		return stat.value
	
	return 0.0
	
func add_item(item:Resource):
	items.push_back(item)
	
	for s in stats:
		for c in item.stat_changers:
			if s.named(c.stat_name):
				s.add_changer(c)
	
	