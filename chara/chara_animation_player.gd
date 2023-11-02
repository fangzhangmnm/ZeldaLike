class_name CharaAnimationPlayer
extends AnimationPlayer


signal anim_finished
signal anim_unlock_input
signal anim_attack_start
signal anim_attack_end
signal anim_invulnerability_start
signal anim_invulnerability_end
signal anim_footstep

func _on_anim_finished(_anim_name:StringName):
    anim_finished.emit()
func emit_anim_unlock_input():
    anim_unlock_input.emit()
func emit_anim_attack_start():
    anim_attack_start.emit()
func emit_anim_attack_end():
    anim_attack_end.emit()
func emit_anim_invulnerability_start():
    anim_invulnerability_start.emit()
func emit_anim_invulnerability_end():
    anim_invulnerability_end.emit()
func emit_anim_footstep():
    anim_footstep.emit()


func _ready():
    animation_finished.connect(_on_anim_finished)