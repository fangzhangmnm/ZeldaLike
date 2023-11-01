class_name CharaAnimationPlayer
extends AnimationPlayer


signal anim_finished
signal anim_enable_canceling
signal anim_attack_start
signal anim_attack_end
signal anim_invulnerability_start
signal anim_invulnerability_end

func _on_anim_finished(_anim_name:StringName):
    anim_finished.emit()
func emit_anim_enable_canceling():
    anim_enable_canceling.emit()
func emit_anim_attack_start():
    anim_attack_start.emit()
func emit_anim_attack_end():
    anim_attack_end.emit()
func emit_anim_invulnerability_start():
    anim_invulnerability_start.emit()
func emit_anim_invulnerability_end():
    anim_invulnerability_end.emit()


func _ready():
    animation_finished.connect(_on_anim_finished)