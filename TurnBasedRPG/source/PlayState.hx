package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.FlxState;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var coins:FlxTypedGroup<Coin>;
	var enemies:FlxTypedGroup<Enemy>;

	private function getWallConfig():FlxTilemap
	{
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		return walls;
	}

	private function addSprites()
	{
		map = new FlxOgmo3Loader(AssetPaths.turnBaseRPG__ogmo, AssetPaths.room_001__json);
		walls = getWallConfig();
		add(walls);

		player = new Player();
		add(player);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		map.loadEntities(placeEntities, "entities");
	}

	override public function create()
	{
		addSprites();

		FlxG.camera.follow(player, TOPDOWN, 1);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, coins, playerTouchCoin);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				player.setPosition(entity.x, entity.y);
			case "coin":
				coins.add(new Coin(entity.x, entity.y));
			case "enemy":
				enemies.add(new Enemy(entity.x, entity.y, REGULAR));
			case "boss":
				enemies.add(new Enemy(entity.x, entity.y, BOSS));
			default:
				trace("Unknown entity: " + entity.name);
		}
	}

	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
		}
	}
}
