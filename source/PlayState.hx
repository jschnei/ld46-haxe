package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{

	public var _game:Game;
    public var _grid:Grid;

    // var background:FlxBackdrop;
	// public var currentControlMode:ControlMode.ControlMode;
	// public var topControlMode:ControlMode.SelectionControlMode;
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);
        // background = new FlxBackdrop(AssetPaths.grass_dark__png);
        // add(background);
		// Registry.init();

		_game = new Game(7, 12);
		_grid = Grid.fromGame(_game);
		for(tile in _grid.gridTiles)
		{
			add(tile);
		}
		
		add(_grid);

		// topControlMode = new ControlMode.SelectionControlMode(this, null);
		// currentControlMode = topControlMode;

		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// currentControlMode.doInput();

        if(FlxG.mouse.pressed)
		{
			var dx = FlxG.mouse.x - _grid.x;
			var dy = FlxG.mouse.y - _grid.y;

			var selectedSquare:Int = _grid.getSquare(dx, dy);
		}
	}


}