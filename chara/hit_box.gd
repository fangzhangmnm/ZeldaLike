class_name HitBox
extends Area3D
signal on_hit(hit:HitBox,hurt:HurtBox)

@onready var chara:Node=owner

func _ready():
    collision_layer=0
    collision_mask=1<<HurtBox.COLLISION_LAYER_NUMBER
    area_entered.connect(_on_area_entered)
    

func _on_area_entered(other:Area3D):
    # print("_on_area_entered ",other.get_path())
    if other is HurtBox and other.is_valid_target(self):
        on_hit.emit(self,other)

