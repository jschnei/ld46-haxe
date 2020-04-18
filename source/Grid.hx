package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

import GridTile.LetterTile;

class Grid extends FlxSprite
{
    public var playState:PlayState;

    public static var CELL_WIDTH:Int = 64;
    public static var CELL_HEIGHT:Int = 64;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var gridTiles:Array<GridTile>;
    public var fallingTiles:FlxTypedGroup<GridTile>;

    public var selectedPath:Array<GridTile>;

    public function new(playState:PlayState, width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        this.playState = playState;

        gridWidth = width;
        gridHeight = height;

        gridTiles = new Array<GridTile>();

        for(y in 0...height)
        {
            for(x in 0...width)
            {
                // var tile = new EmptyTile(this, x, y);
                gridTiles.push(null);
            }
        }

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

        fallingTiles = new FlxTypedGroup<GridTile>();

        addFallingTile(0);
    }

    public function addFallingTile(column:Int)
    {
        var tile:GridTile = new LetterTile(this, column, 0, "A");
        fallingTiles.add(tile);
        playState.add(tile);
    }

    public function getSquare(dx:Float, dy:Float):Int
    {
        var x:Int = Math.floor(dx/CELL_WIDTH);
        var y:Int = Math.floor(dy/CELL_HEIGHT);

        if(x<0 || x>=gridWidth || y<0 || y>= gridHeight) return -1;
        return y*gridWidth + x;
    }

    public function getTile(dx:Float, dy:Float):GridTile
    {
        return gridTiles[getSquare(dx, dy)];
    }

    // public function getCorner(square:Int):FlxPoint
    // {
    //     var corner:FlxPoint = new FlxPoint();
    //     corner.x = x + (square%gridWidth)*CELL_WIDTH;
    //     corner.y = y + Std.int(square/gridWidth)*CELL_HEIGHT;

    //     return corner;
    // }

    public inline function squareId(x:Int, y:Int):Int
    {
        return y*gridWidth + x;
    }

    public function columnTop(x:Int) 
    {
        for(y in 0...gridHeight)
        {
            if (gridTiles[squareId(x, y)] != null) {
                return y;
            }
        }

        return gridHeight;
    }

    public function extendSelectedPath(tile:GridTile):Void
    {
        if (selectedPath.length == 0) 
        {
            selectedPath.push(tile);
        } 
        else
        {
            var lastPathTile:GridTile = selectedPath[selectedPath.length-1];
            var lastPathTileX:Int = lastPathTile.gridX;
            var lastPathTileY:Int = lastPathTile.gridY;

            var currentTileX:Int = tile.gridX;
            var currentTileY:Int = tile.gridY;
            // Make sure that the tile is exactly distance 1 away from the last part of the path.
            if (lastPathTileX == currentTileX && lastPathTileY == currentTileY)
            {
                return;
            }
            if (Math.abs(lastPathTileX - currentTileX) >= 2 || Math.abs (lastPathTileY - currentTileY) >= 2)
            {
                return;
            }
            selectedPath.push(tile);
        }
    }
}
