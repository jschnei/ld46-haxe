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

		_grid = new Grid(7, 12);
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

		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// currentControlMode.doInput();
	}


}