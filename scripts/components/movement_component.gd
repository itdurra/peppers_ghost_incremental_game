extends Node

class_name MovementComponent

#MovementComponent: stores the data for what type of movement pattern
#the entity should follow, and executes the pattern. The movement stores
#an original spawn point, and bases movement off of that point

enum MovementType{
	Circle,
	Oval,
	Ushape,
	Diamond,
	FigureEight,
	Shake,
}

#set these when making a new component
@export var origin: Node3D
@export var pivot: Node3D #a child node of origin for extra degree of rotation
@export var movement_type: MovementType = MovementType.Circle

@export_group("Constant Movement")

#movement types
@export_subgroup("circle movement")
@export var circle_offset: Vector3 = Vector3(0, .5, 0)
@export var circle_speed: float = 1.0
@export var circle_duration: float = 3.0

@export_subgroup("oval movement")
@export var oval_offset: Vector3 = Vector3(0, .5, 0)
@export var oval_x: float = .5
@export var oval_duration: float = 6.0

@export_subgroup("u_shape movement")
@export var u_offset: Vector3 = Vector3(0, -.5, 0)
@export var u_rotation_max: Vector3 = Vector3(0, 0, 100)
@export var u_rotation_min: Vector3 = Vector3(0, 0, -100)
@export var u_duration: float = 4.0

@export_subgroup("diamond movement")
@export var diamond_offset: Vector3 = Vector3(0, -3, 0)
@export var diamond_x: float = 4.0
@export var diamond_y: float = 2.5
@export var diamond_duration: float = 6.0

@export_subgroup("figure_eight_shape movement")
@export var eight_offset: Vector3 = Vector3(0, -3, 0)
@export var eight_x: float = 8.0
@export var eight_y: float = 3.0
@export var eight_duration: float = 6.0

@export_group("Event Based Movement")
@export_subgroup("shake movement")
@export var shake_offset: Vector3 = Vector3(0, .03, 0)
@export var shake_duration: float = .3

#tween
var tw: Tween

func _ready() -> void:
	if !self.pivot:
		return

	if movement_type == MovementType.Circle:
		self._circle_tween_movement()
	elif movement_type == MovementType.Oval:
		self._oval_tween_movement()
	elif movement_type == MovementType.Ushape:
		self._ushape_tween_movement()
	elif movement_type == MovementType.Diamond:
		self._diamond_tween_movement()
	elif movement_type == MovementType.FigureEight:
		self._figure_eight_tween_movement()
	else:
		pass


#TODO: add interpolation on rotation speed
func _circle_tween_movement() -> void:
	self.pivot.position = circle_offset
	self.origin.position = circle_offset
	self.origin.rotate_z(get_physics_process_delta_time() * circle_speed)

	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)

	tw.tween_property(self.origin, "rotation_degrees", Vector3(0, 0, 360), oval_duration)
	tw.tween_property(self.origin, "rotation_degrees", Vector3(0, 0, 0), 0.0)
	tw.set_loops()


#make an oval shape movement with interpolation
func _oval_tween_movement() -> void:
	self.pivot.position = oval_offset
	self.origin.position = oval_offset

	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)

	tw.tween_property(self.origin, "rotation_degrees", Vector3(0, 0, 180), oval_duration / 4)
	tw.set_parallel()
	tw.tween_property(self.origin, "position", Vector3(oval_offset.x + oval_x, oval_offset.y, 0.0), oval_duration / 4)
	tw.set_parallel(false)

	tw.tween_property(self.origin, "rotation_degrees", Vector3(0, 0, 360), oval_duration / 4)
	tw.set_parallel()
	tw.tween_property(self.origin, "position", Vector3(oval_offset.x + -oval_x, oval_offset.y, 0.0), oval_duration / 4)
	tw.set_parallel(false)

	tw.tween_property(self.origin, "rotation_degrees", oval_offset, 0.0)

	tw.set_loops()

#make a u shape tween_movement with interpolation
func _ushape_tween_movement() -> void:
	self.pivot.position = u_offset
	self.origin.position.y = -u_offset.y

	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self.origin, "rotation_degrees", u_rotation_max, u_duration)
	tw.tween_property(self.origin, "rotation_degrees", u_rotation_min, u_duration)
	tw.set_loops()


#make a diamond shape movement
func _diamond_tween_movement() -> void:
	self.pivot.position = diamond_offset
	
	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)

	tw.tween_property(self.origin, "position", Vector3(0, -diamond_y, 0), diamond_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(-diamond_x, 0, 0), diamond_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(0, diamond_y, 0), diamond_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(diamond_x, 0, 0), diamond_duration / 4)
	tw.set_loops()

#TODO: big u shape, and go between two points
#TODO: add interpolation
func _figure_eight_tween_movement() -> void:
	#self.pivot.position = eight_offset
	
	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)

	tw.tween_property(self.origin, "position", Vector3(eight_x, eight_y, 0), eight_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(eight_x, -eight_y, 0), eight_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(-eight_x, eight_y, 0), eight_duration / 4)
	tw.tween_property(self.origin, "position", Vector3(-eight_x, -eight_y, 0), eight_duration / 4)

	tw.set_loops()


#--------------------------------- event based movement functions ------------------#

#bounces up and then returns to 0
func _shake_movement(_area: Area3D) -> void:	
	if tw:
		tw.kill()
	tw = self.create_tween()

	tw.set_trans(Tween.TRANS_BOUNCE)
	tw.set_ease(Tween.EASE_IN_OUT)

	tw.tween_property(self.origin, "position", shake_offset, shake_duration)
	tw.tween_property(self.origin, "position", Vector3(0,0,0), shake_duration)