extends Spatial

export(int) var center_webmercator_x = 1747139
export(int) var center_webmercator_y = 6154178
export(float) var radius =  1000.0
export(int) var max_streets = 300

export(String) var streets_shapefile_path

var street_scene = preload("res://Street.tscn")


func _ready() -> void:
	var lines = Geodot.get_lines(streets_shapefile_path, center_webmercator_x, center_webmercator_y, radius, max_streets)
	print(lines.size())

	for line in lines:
		var street = street_scene.instance()
		street.curve = line.get_offset_curve3d(-center_webmercator_x, 0, -center_webmercator_y)

		var width = float(line.get_attribute("WIDTH"))
		width = max(width, 2) # It's sometimes -1 in the data

		street.get_node("PathFollow/CSGPolygon").polygon[0] = Vector2(-width, 0)
		street.get_node("PathFollow/CSGPolygon").polygon[1] = Vector2(-width, 3)
		street.get_node("PathFollow/CSGPolygon").polygon[2] = Vector2(0, 3)
		street.get_node("PathFollow/CSGPolygon").polygon[3] = Vector2(width, 3)
		street.get_node("PathFollow/CSGPolygon").polygon[4] = Vector2(width, 0)

		print(street.curve.get_baked_points()[0])
		add_child(street)
