extends Node2D

func _ready():
	var vertices = PoolVector3Array()
	vertices.push_back(Vector3(0, 0, 0))
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(1, 1, 0))
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = MeshInstance2D.new()
	m.mesh = arr_mesh
	m.texture = load("res://icon.png")
	add_child(m)
	
