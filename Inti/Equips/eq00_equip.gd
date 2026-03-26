class_name Equip extends Inti

var upgrade: int

func _init():
	inti_name = (str(self.class) + "+" + str(self.upgrade))
	pass
