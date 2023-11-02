@tool
extends CharaState

func tick()->void:
    super()
    if process_default_transitions():return
    chara.process_grounded_movement()


