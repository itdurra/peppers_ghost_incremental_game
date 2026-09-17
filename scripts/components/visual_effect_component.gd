extends Node

#visual effect component that triggers GPUParticle3D nodes

@export var coin_particles: GPUParticles3D
@export var water_particles: GPUParticles3D

@export var amount: int = 10

func emit_coins(_area: Area3D) -> void:
	if !coin_particles:
		return

	coin_particles.amount = amount
	coin_particles.emitting = true

func emit_water(_area: Area3D) -> void:
	if !water_particles:
		return

	water_particles.amount = amount
	water_particles.emitting = true

#onclick
func _on_area_3d_input_event(
	_camera: Node,
	event: InputEvent, 
	_event_position: Vector3, 
	_normal: Vector3, 
	_shape_idx: int
) -> void:
	if event.is_action_pressed("interact"):
		if !coin_particles:
			return

		coin_particles.amount = amount
		coin_particles.emitting = true