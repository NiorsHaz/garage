class_name CarData extends Resource

var matriculation: String = ""

# Repair complexity (time modifier)
const reparation_level := {
	"Frein": 2,
	"Vidange": 1,
	"Filtre": 1,
	"Batterie": 2,
	"Amortisseurs": 3,
	"Embrayage": 4,
	"Pneus": 2,
	"Système de refroidissement": 5
}

func _set_matriculation(matricule: String) -> void:
	matriculation = matricule
	
func _get_matriculation() -> String:
	return matriculation
