class_name PartyManager extends Resource

var active_party: Array[Unit]
var noelia_data: NoeliaData
var ash_data: AshData
var omar_data: OmarData

func setup_new_game():
	noelia_data = NoeliaData.new()
	ash_data = AshData.new()
	active_party.append(noelia_data)
	active_party.append(ash_data)
