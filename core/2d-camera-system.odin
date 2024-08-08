package core

import "vendor:raylib"

@(private = "file")
MAX_BUILDINGS :: 100

main :: proc() {
	screen_width :: 800
	screen_height :: 450
	raylib.InitWindow(screen_width, screen_height, "raylib [core] example - 2d camera")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)

	player := raylib.Rectangle {
		x      = 400,
		y      = 280,
		width  = 40,
		height = 40,
	}
	buildings: [MAX_BUILDINGS]raylib.Rectangle
	building_colors: [MAX_BUILDINGS]raylib.Color

	spacing: i32 = 0

	for i := 0; i < MAX_BUILDINGS; i += 1 {
		building_width := raylib.GetRandomValue(50, 200)
		building_height := raylib.GetRandomValue(100, 800)
		buildings[i] = raylib.Rectangle {
			width  = f32(building_width),
			height = f32(building_height),
			x      = -6000.0 + f32(spacing),
			y      = screen_height - 130.0 - f32(building_height),
		}

		spacing += building_width

		building_colors[i] = raylib.Color {
			u8(raylib.GetRandomValue(200, 240)),
			u8(raylib.GetRandomValue(200, 240)),
			u8(raylib.GetRandomValue(200, 250)),
			255,
		}
	}

	camera := raylib.Camera2D {
		target   = raylib.Vector2{player.x + 20.0, player.y + 20.0},
		offset   = raylib.Vector2{screen_width / 2.0, screen_height / 2.0},
		rotation = 0.0,
		zoom     = 1.0,
	}

	for !raylib.WindowShouldClose() {
		if raylib.IsKeyDown(raylib.KeyboardKey.A) {
			player.x -= 10
		} else if raylib.IsKeyDown(raylib.KeyboardKey.D) {
			player.x += 10
		}

		camera.target.xy = {player.x + 20, player.y + 20}

		if raylib.IsKeyDown(raylib.KeyboardKey.Q) {
			camera.rotation -= 1
		} else if raylib.IsKeyDown(raylib.KeyboardKey.E) {
			camera.rotation += 1
		}

		if camera.rotation > 40 {
			camera.rotation = 40
		} else if camera.rotation < -40 {
			camera.rotation = -40
		}

		camera.zoom += raylib.GetMouseWheelMove() * 0.05

		if camera.zoom > 3 {
			camera.zoom = 3
		} else if camera.zoom < 0.1 {
			camera.zoom = 0.1
		}

		if raylib.IsKeyDown(raylib.KeyboardKey.R) {
			camera.rotation = 0
			camera.zoom = 1
		}

		raylib.BeginDrawing()
		defer raylib.EndDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)

		{
			raylib.BeginMode2D(camera)
			defer raylib.EndMode2D()

			raylib.DrawRectangle(-6000, 320, 13000, 8000, raylib.DARKGRAY)

			for i := 0; i < MAX_BUILDINGS; i += 1 {
				raylib.DrawRectangleRec(buildings[i], building_colors[i])
			}

			raylib.DrawRectangleRec(player, raylib.RED)

			raylib.DrawLine(
				i32(camera.target.x),
				-screen_height * 10,
				i32(camera.target.x),
				screen_height * 10,
				raylib.GREEN,
			)
			raylib.DrawLine(
				-screen_width * 10,
				i32(camera.target.y),
				screen_width * 10,
				i32(camera.target.y),
				raylib.GREEN,
			)
		}

		raylib.DrawText("SCREEN AREA", 640, 10, 20, raylib.RED)

		raylib.DrawRectangle(0, 0, screen_width, 5, raylib.RED)
		raylib.DrawRectangle(0, 5, 5, screen_height - 10, raylib.RED)
		raylib.DrawRectangle(screen_width - 5, 5, 5, screen_height - 10, raylib.RED)
		raylib.DrawRectangle(0, screen_height - 5, screen_width, 5, raylib.RED)


		raylib.DrawRectangle(10, 10, 250, 113, raylib.Fade(raylib.SKYBLUE, 0.5))
		raylib.DrawRectangleLines(10, 10, 250, 113, raylib.BLUE)

		raylib.DrawText("Free 2d camera controls:", 20, 20, 10, raylib.BLACK)
		raylib.DrawText("- A / S to move Offset", 40, 40, 10, raylib.DARKGRAY)
		raylib.DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, raylib.DARKGRAY)
		raylib.DrawText("- Q / E to Rotate", 40, 80, 10, raylib.DARKGRAY)
		raylib.DrawText("- R to reset Zoom and Rotation", 40, 100, 10, raylib.DARKGRAY)
	}
}
