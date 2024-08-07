package core

import "vendor:raylib"

main :: proc() {
	width :: 640
	height :: 480
	raylib.InitWindow(width, height, "raylib [core] example - basic window")
	defer raylib.CloseWindow()
	raylib.SetTargetFPS(60)
	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.WHITE)
		raylib.DrawText("Congrats! You created your first window!", 100, 200, 20, raylib.LIGHTGRAY)
		raylib.EndDrawing()
	}
}
