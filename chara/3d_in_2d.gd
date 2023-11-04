extends Sprite3D

@onready var sprite:Sprite3D=self
@onready var subviewport:SubViewport=$SubViewport

func _ready():
    if sprite and subviewport:
        sprite.texture= subviewport.get_texture()
