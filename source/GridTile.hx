package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;

class GridTile extends FlxSprite
{
    public static var FALL_SPEED:Int = 5;

    public var grid:Grid;
    public var gridX:Int;
    public var gridY:Int;

    public var falling:Bool;
    
    public function new(grid:Grid, gridX:Int, gridY:Int, ?falling:Bool=true)
    {
        this.grid = grid;
        this.gridX = gridX;
        this.gridY = gridY;

        this.falling = falling;

        var X = grid.x + Grid.CELL_WIDTH * gridX;
        var Y = grid.y + Grid.CELL_HEIGHT * gridY;

        super(X, Y);
    }

    public function movement()
    {
        if (falling) 
        {
            velocity.y = FALL_SPEED;
        } else {
            velocity.y = 0;
        }
    }

    public override function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

}

class LetterTile extends GridTile 
{    
    var letterText:FlxText; 
    var playState:PlayState;
    public static var FALL_SPEED:Int = 5;
    public function new(grid:Grid, gridX:Int, gridY:Int, letter:String, ps:PlayState)
    {
        super(grid, gridX, gridY);
        playState = ps;
        makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.YELLOW);
        letterText = new FlxText(gridX,gridY,0, letter);
        letterText.setFormat(AssetPaths.Action_Man__ttf, 172, FlxColor.RED, FlxTextAlign.CENTER);
        letterText.width += 10;
        playState.add(letterText);
    }

    public override function update(elapsed:Float)
    {
        letterText.y = letterText.y + elapsed * FALL_SPEED;
        playState.add(letterText);
        super.update(elapsed);
    }
}
