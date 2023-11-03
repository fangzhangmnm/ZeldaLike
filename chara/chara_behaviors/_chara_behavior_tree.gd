class_name CharaBehaviorTree
extends BehaviorTree

@onready var chara:Chara=owner

func tick(_delta):
    chara.input_move=Vector3.ZERO
    super(_delta)
