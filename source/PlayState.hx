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
	public var _prevMiniGrid:MiniGrid;
	public var _nextMiniGrid:MiniGrid;
	public var _statusHud:StatusHUD;
	public var _youDiedText:FlxText;
    // var background:FlxBackdrop;
	// public var currentControlMode:ControlMode.ControlMode;
	// public var topControlMode:ControlMode.SelectionControlMode;
	override public function create():Void
	{
		FlxG.autoPause = false;	
		bgColor = new FlxColor(0xff303030);

		_grid = new Grid(Registry.PLAYFIELD_WIDTH, Registry.PLAYFIELD_HEIGHT);
		for(tile in _grid.gridTiles)
		{
			if (tile != null) 
			{
				add(tile);
			}
		}
		
		add(_grid);
		add(_grid.currentWordText);

		_prevMiniGrid = new MiniGrid(this, 
								 Registry.PLAYFIELD_WIDTH, Registry.PLAYFIELD_HEIGHT,
								 -250, 50);
		_prevMiniGrid.trackPlayer(Registry.curGame.self.trackPrev);
		add(_prevMiniGrid);

		_nextMiniGrid = new MiniGrid(this, 
								 Registry.PLAYFIELD_WIDTH, Registry.PLAYFIELD_HEIGHT,
								 160 + Registry.PLAYFIELD_WIDTH*Registry.GRID_SIZE, 50);
		_nextMiniGrid.trackPlayer(Registry.curGame.self.trackNext);
		add(_nextMiniGrid);

		_statusHud = new StatusHUD(370, 450);
		add(_statusHud);

		_youDiedText = new FlxText();
		_youDiedText.setFormat(AssetPaths.Fira_Bold__ttf, 20, FlxColor.ORANGE, FlxTextAlign.LEFT);
		_youDiedText.text = "You lost! Waiting for remaining players to finish...";
		_youDiedText.x =  -_youDiedText.width/2 + 125;
		_youDiedText.y = -30;
		_youDiedText.visible = false;
		add(_youDiedText);

		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		FlxG.sound.playMusic(AssetPaths.boggle_battle__wav, .3);
		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// currentControlMode.doInput();
		if (Registry.curGame.numRemainingPlayers() == 0)
			FlxG.switchState(new ResultsState());

		if (!Registry.curGame.alive)
		{
			_youDiedText.visible = true;
			return;
		}

		if (Registry.curGame.numRemainingPlayers() == 1 && Registry.curGame.startingPlayerCount > 1)
		{
			Registry.curGame.die();
		}

		_prevMiniGrid.trackPlayer(Registry.curGame.self.trackPrev);
		_nextMiniGrid.trackPlayer(Registry.curGame.self.trackNext);

        if(FlxG.mouse.pressed)
		{
			var dx = FlxG.mouse.x - _grid.x;
			var dy = FlxG.mouse.y - _grid.y;

			_grid.onMouseHold(dx, dy);
		}
		if(FlxG.mouse.justReleased)
		{
			_grid.clearSelectedPath();
		}

		// if (FlxG.keys.justPressed.X)
		// {
		// 	_grid.addRowsToBottom(1);
		// }

		// if (FlxG.keys.justPressed.L)
		// {
		// 	_grid.logGridTiles();
		// }
	}


}