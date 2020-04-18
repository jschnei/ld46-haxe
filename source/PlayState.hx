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

		_game = new Game(30, 10);
		_grid = Grid.fromGame(_game);
		for(tile in _grid.gridTiles)
		{
			add(tile);
		}
		
		add(_grid);

		// topControlMode = new ControlMode.SelectionControlMode(this, null);
		// currentControlMode = topControlMode;
		
		if(FlxG.camera.width < Grid.CELL_WIDTH * _grid.gridWidth) {
			FlxG.camera.minScrollX = Grid.CELL_WIDTH/2 - FlxG.camera.width/2;
			FlxG.camera.maxScrollX = Grid.CELL_WIDTH * _grid.gridWidth - Grid.CELL_WIDTH/2 + FlxG.camera.width/2;
		} else {
			FlxG.camera.minScrollX = Grid.CELL_WIDTH * _grid.gridWidth/2 - FlxG.camera.width/2;
			FlxG.camera.maxScrollX = Grid.CELL_WIDTH * _grid.gridWidth/2 + FlxG.camera.width/2;
		}

		if(FlxG.camera.height < Grid.CELL_HEIGHT * _grid.gridHeight) {
			FlxG.camera.minScrollY = Grid.CELL_HEIGHT/2 - FlxG.camera.height/2;
			FlxG.camera.maxScrollY = Grid.CELL_HEIGHT * _grid.gridHeight - Grid.CELL_HEIGHT/2 + FlxG.camera.height/2;
		} else {
			FlxG.camera.minScrollY = Grid.CELL_HEIGHT * _grid.gridHeight/2 - FlxG.camera.height/2;
			FlxG.camera.maxScrollY = Grid.CELL_HEIGHT * _grid.gridHeight/2 + FlxG.camera.height/2;
		}

		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// currentControlMode.doInput();
	}


}