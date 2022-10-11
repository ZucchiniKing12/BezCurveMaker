extends Node2D
class_name BezCurve

var end_points := PoolVector2Array()

func _ready():
	end_points.push_back(Vector2(0, 0))
	end_points.push_back(Vector2(10, 10))
	render_points()
	print(lerp(end_points[0].x, end_points[1].x, 0.5))

func _process(delta):
	pass



var resolution = 100

func curve(t) -> Vector2:
	return Vector2(lerp( end_points[0].x, end_points[1].x, t), lerp(end_points[0].y, end_points[1].y, t) )

func dist_from_curve(P, Q):
	var d = direction_vector
	
func direction_vector(t):
	var a = curve(t - 0.01)
	var b = curve(t + 0.01)
	var D = Vector2( b.x - a.x, b.y - a.y)
	return D
	
func render_points():
	var samples: PoolVector2Array
	var pixels: PoolVector3Array
	for i in range(resolution + 1):
		samples.push_back(curve(float(i) / resolution))
	for x in range(Viewport.size.x):
		for y in range(Viewport.size.y):
			pixels.push_back(x, y, distance)
	print(samples)



func ready_mesh():
	var vertices = [Vector3(0, 0, 0), Vector3(100, 0, 0), Vector3(100, -100, 0), Vector3(0, 0, 0), Vector3(0, -100, 0), Vector3(100, -100, 0)]#generate_rectangle_vertices(Vector2(2, 2), Vector2(1, 1))
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mi = MeshInstance2D.new()
	add_child(mi)
	mi.mesh = array_mesh
	print(mi.mesh.get_faces())
	mi.name = 'mi'
	mi.texture = load("res://meshSpriteTest.png")

func generate_rectangle_vertices(rect_dim: Vector2, spacing: Vector2) -> PoolVector3Array:
	var v = PoolVector3Array()
	for j in range(floor(rect_dim.y / spacing.y)):
		for i in range(floor(rect_dim.x / spacing.x)):
			v.push_back(Vector3(i * spacing.x, j * spacing.y, 0))
	return v		

func move_mesh(mesh: ArrayMesh, amt: float) -> ArrayMesh:
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		vertex.x += amt
		mdt.set_vertex(i, vertex)
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	return mesh
