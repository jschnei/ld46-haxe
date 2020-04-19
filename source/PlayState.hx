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
import haxe.io.Eof;

class PlayState extends FlxState
{

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

		_grid = new Grid(this, Registry.PLAYFIELD_WIDTH, Registry.PLAYFIELD_HEIGHT);
		for(tile in _grid.gridTiles)
		{
			if (tile != null) 
			{
				add(tile);
			}
		}
		
		add(_grid);

		// topControlMode = new ControlMode.SelectionControlMode(this, null);
		// currentControlMode = topControlMode;

		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		Registry.initializeWordList();
		NetworkingUtils.test();

		trace("reached here");

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

			_grid.extendSelectedPath(dx, dy);
		}
		if(FlxG.mouse.justReleased)
		{
			_grid.clearSelectedPath();
		}

		if (FlxG.keys.justPressed.X)
		{
			_grid.addRowsToBottom(1);
		}

		if (FlxG.keys.justPressed.L)
		{
			_grid.logGridTiles();
		}

	}


}