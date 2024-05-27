class_name PlayerExports extends CharacterBody2D

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D


@export var sprite_texture: Texture2D:
  set(new_texture):
    sprite_texture = new_texture
    
    if not is_inside_tree():
      await self.ready
    
    $Sprite2D.texture = sprite_texture
    queue_redraw()

@export_group("Idle Frames")
@export var idle_frame_1: Texture2D:
  set(new_texture):
    idle_frame_1 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("idle", 0, new_texture, 3.0)
@export var idle_frame_2: Texture2D:
  set(new_texture):
    idle_frame_2 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("idle", 1, new_texture, 1.0)
    animation_player.sprite_frames.set_frame("idle", 3, new_texture, 1.0)
@export var idle_frame_3: Texture2D:
  set(new_texture):
    idle_frame_3 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("idle", 0, new_texture, 1.0)

@export_group("Walk Frames")
@export var walk_frame_1: Texture2D:
  set(new_texture):
    walk_frame_1 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("walk", 0, new_texture, 1.0)
@export var walk_frame_2: Texture2D:
  set(new_texture):
    walk_frame_2 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("walk", 1, new_texture, 1.0)
@export var walk_frame_3: Texture2D:
  set(new_texture):
    walk_frame_3 = new_texture
    if not is_inside_tree():
      await self.ready
    
    animation_player.sprite_frames.set_frame("walk", 0, new_texture, 1.0)
