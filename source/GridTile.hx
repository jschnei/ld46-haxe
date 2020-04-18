package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

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
    public function new(grid:Grid, gridX:Int, gridY:Int, letter:String)
    {
        super(grid, gridX, gridY);
        makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.YELLOW);
        // switch(type)
        // {
        //     case Game.FieldType.FLOOR:
        //         loadGraphic(AssetPaths.grass_small__png);
        //     case Game.FieldType.WALL:
        //         loadGraphic(AssetPaths.grass_wall__png);
        //     case Game.FieldType.RED_GOAL:
        //         loadGraphic(AssetPaths.grass_red_goal__png);
        //     case Game.FieldType.BLUE_GOAL:
        //         loadGraphic(AssetPaths.grass_blue_goal__png);
        //     default:
        //         loadGraphic(AssetPaths.grass_small__png);
        // }
    }
}
