package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

import GridTile.EmptyTile;


class Grid extends FlxSprite
{
    public static var CELL_WIDTH:Int = 64;
    public static var CELL_HEIGHT:Int = 64;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var gridTiles:Array<GridTile>;

    public function new(width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        gridWidth = width;
        gridHeight = height;

        gridTiles = new Array<GridTile>();

        super(X, Y);
        makeGraphic(gridWidth*CELL_WIDTH+1, 
                    gridHeight*CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(this, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {color: 0xffffffff, thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(this, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {color: 0xffffffff,thickness: 3});
        }

    }

    public static function fromGame(game:Game):Grid
    {
        var grid = new Grid(game.width, game.height);

        for(y in 0...game.height)
        {
            for(x in 0...game.width)
            {
                var tile = new EmptyTile(grid, x, y);
                grid.gridTiles.push(tile);
            }
        }
        return grid;
    }

    public function getSquare(dx:Float, dy:Float):Int
    {
        var x:Int = Math.floor(dx/CELL_WIDTH);
        var y:Int = Math.floor(dy/CELL_HEIGHT);

        if(x<0 || x>=gridWidth || y<0 || y>= gridHeight) return -1;
        return y*gridWidth + x;
    }

    public function getCorner(square:Int):FlxPoint
    {
        var corner:FlxPoint = new FlxPoint();
        corner.x = x + (square%gridWidth)*CELL_WIDTH;
        corner.y = y + Std.int(square/gridWidth)*CELL_HEIGHT;

        return corner;
    }

}
