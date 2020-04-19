package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSprite
{
    public static var FALL_SPEED:Int = 200; //= 50;

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

            var topTile = grid.columnTop(gridX);
            var dy = y - grid.y;
            if (dy >= (topTile - 1) * Grid.CELL_HEIGHT) 
            {
                if (topTile - 1 >= 0)
                {
                    grid.insertTile(this, gridX, topTile-1);
                } else{
                    // this block is stuck off the top
                    trace("oh no!");
                    velocity.y = 0;
                    falling = false;
                }
            }
        } 
        else 
        {
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
    public function new(grid:Grid, gridX:Int, gridY:Int, letter:String)
    {
        super(grid, gridX, gridY);
        makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.YELLOW);
    }
}
