import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 100;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		drag.x = drag.y = 800;

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setSize(8, 8);
		offset.set(4, 4);

		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);
	}

	private function determinateAnimation()
	{
		var action = "idle";

		// check if the player is moving, and not walking into walls
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			action = "walk";
		}
		switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
	}

	private function getAngle(up:Bool, down:Bool, left:Bool, right:Bool):Float
	{
		var newAngle:Float = 0;
		if (up)
		{
			newAngle = -90;
			if (left)
				newAngle -= 45;
			else if (right)
				newAngle += 45;
			facing = UP;
		}
		else if (down)
		{
			newAngle = 90;
			if (left)
				newAngle += 45;
			else if (right)
				newAngle -= 45;
			facing = DOWN;
		}
		else if (left)
		{
			newAngle = 180;
			facing = LEFT;
		}
		else if (right)
		{
			newAngle = 0;
			facing = RIGHT;
		}
		return newAngle;
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = getAngle(up, down, left, right);
			velocity.setPolarDegrees(SPEED, newAngle);
		}
	}

	override public function update(elapsed:Float)
	{
		updateMovement();
		determinateAnimation();
		super.update(elapsed);
	}
}
