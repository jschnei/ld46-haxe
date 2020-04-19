package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import Date;
using Lambda;
import GridTile.LetterTile;
import Std;

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
    public var currentWordText:FlxText;

    public var rand:Randomizer;
    public var timer:Float;

    public static var NEW_TILE_FREQ = 1.0;
    public var new_tile_timer:Float = 0;

    public var selectSound:FlxSound;
    public var unselectSound:FlxSound;
    public var clearSound:FlxSound;
    public var badWordSound:FlxSound;

    public function new(playState:PlayState, width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        rand = new Randomizer(this);
        timer = 0.0;

        this.playState = playState;

        gridWidth = width;
        gridHeight = height;

        gridTiles = new Array<GridTile>();

        selectedPath = new Array<GridTile>();

        for(y in 0...height)
        {
            for(x in 0...width)
            {
                // var tile = new LetterTile(this, x, y, "X");
                gridTiles.push(null);
            }
        }

        makeGraphic(gridWidth*CELL_WIDTH+1, 
                    gridHeight*CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);

        currentWordText = new FlxText(gridWidth*CELL_WIDTH+10, gridHeight*CELL_HEIGHT/2);
        currentWordText.setFormat(AssetPaths.Action_Man__ttf, 90, FlxColor.RED, FlxTextAlign.CENTER);
        playState.add(currentWordText);

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(this, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {color: 0xffffffff, thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(this, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {color: 0xffffffff,thickness: 3});
        }

        fallingTiles = new FlxTypedGroup<GridTile>();

        selectSound = FlxG.sound.load(AssetPaths.select__wav);
        unselectSound = FlxG.sound.load(AssetPaths.unselect__wav);
        clearSound = FlxG.sound.load(AssetPaths.clear__wav, .1);
        badWordSound = FlxG.sound.load(AssetPaths.badword__wav, .5);
    }

    override public function update(elapsed:Float):Void
    {
        for (gridTile in selectedPath)
        {
            gridTile.selected = true;
        }

        currentWordText.text = getCurrentWord();

        new_tile_timer += elapsed;
        if (new_tile_timer > NEW_TILE_FREQ) 
        {
            addFallingTile(rand.getColumn(gridWidth));
            new_tile_timer = 0;
        }
    }

    public function randomLetter():String
    {
        return rand.getLetter();
    }

    public function addFallingTile(column:Int)
    {
        var tile:GridTile = new LetterTile(this, column, 0, randomLetter());
        fallingTiles.add(tile);
        playState.add(tile);
    }

    public function addNewLetterTile(gridX:Int, gridY:Int)
    {
        var tile:LetterTile = new LetterTile(this, gridX, gridY, randomLetter());
        tile.falling = false;
        playState.add(tile);
        insertTile(tile, gridX, gridY);
    }

    public function insertTile(gridTile:GridTile, gridX:Int, gridY:Int)
    {
        // align to grid
        gridTile.setPosition(x + Grid.CELL_WIDTH * gridX, y + Grid.CELL_HEIGHT * gridY);
        gridTile.gridX = gridX;
        gridTile.gridY = gridY;

        // insert in gridTiles
        gridTiles[squareId(gridX, gridY)] = gridTile;
    }

    public function insertFallingTile(gridTile:GridTile, gridX:Int, gridY:Int)
    {
        // stop tile
        gridTile.velocity.y = 0;
        gridTile.falling = false;

        // insert into gridTiles
        insertTile(gridTile, gridX, gridY);

        // remove from fallingTiles
        fallingTiles.remove(gridTile);
    }

    public function removeTile(gridTile:GridTile)
    {
        if (gridTile.falling)
        {
            fallingTiles.remove(gridTile);
            gridTile.kill();
        } else {
            var row = gridTile.gridY;
            var column = gridTile.gridX;
            
            gridTiles[squareId(gridTile.gridX, gridTile.gridY)] = null;
            gridTile.kill();

            // make other letters fall
            for (y in 0...row)
            {
                if (gridTiles[squareId(column, y)] != null) 
                {
                    fallTile(gridTiles[squareId(column, y)]);
                }
            }
        }
    }

    public function fallTile(gridTile:GridTile)
    {
        gridTiles[squareId(gridTile.gridX, gridTile.gridY)] = null;
        fallingTiles.add(gridTile);
        gridTile.falling = true;
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

    public function getCurrentWord():String
    {
        var word = "";
        for (gridTile in selectedPath)
        {
            word += gridTile.getLetter();
        }
        return word;
    }

    public function addTileToPath(tile:GridTile)
    {
        selectSound.stop();
        selectSound.play();
        selectedPath.push(tile);
    }

    public function inInscribedDiamond(dx:Float, dy:Float):Bool
    {
        var fracX:Float = (dx/CELL_WIDTH - Math.floor(dx/CELL_WIDTH)) - 1/2;
        var fracY:Float = (dy/CELL_HEIGHT - Math.floor(dy/CELL_HEIGHT)) - 1/2;
        return (Math.abs(fracX) + Math.abs(fracY) <= .5);
    }

    public function extendSelectedPath(dx:Float, dy:Float):Void
    {
        // logGridTiles();
        var selectedTile:GridTile = getTile(dx, dy);
        if (selectedTile == null)
            return;
        // If the path is empty, start the path (regardless of where the tile is being clicked.).
        if (selectedPath.length == 0) 
        {
            addTileToPath(selectedTile);
            return;
        }
        // Check that the cursor is sufficiently inside the tile (this is to facilitate diagonal movement).
        if (!inInscribedDiamond(dx, dy))
            return;
        // If the cursor is over the 2nd to last tile in the path, assume player wants to undo the last tile.
        if (selectedPath.length >= 2)
        {
            var penultimateTile:GridTile = selectedPath[selectedPath.length-2];
            if (selectedTile.gridX == penultimateTile.gridX && selectedTile.gridY == penultimateTile.gridY)
            {
                var lastTile:GridTile = selectedPath.pop();
                lastTile.selected = false;
                unselectSound.stop();
                unselectSound.play();
                return;
            }
        }
        // Check that the path doesn't repeat tiles. TODO: may want to use a hashset instead if performance is bad.
        for (gridTile in selectedPath)
            if (gridTile.gridX == selectedTile.gridX && gridTile.gridY == selectedTile.gridY)
                return;

        var lastPathTile:GridTile = selectedPath[selectedPath.length-1];
        // Make sure that the tile is exactly distance 1 away from the last part of the path.
        if (Math.abs(lastPathTile.gridX - selectedTile.gridX) >= 2 ||
            Math.abs(lastPathTile.gridY - selectedTile.gridY) >= 2)
            return;
        addTileToPath(selectedTile);
    }

    public function clearSelectedPath():Void
    {
        if (getCurrentWord().length == 0)
            return;

        for (gridTile in selectedPath)
            gridTile.selected = false;

        var word = getCurrentWord().toLowerCase();
        if (Registry.isWord(word))
        {
            NetworkingUtils.sendMessage(word);
            for (gridTile in selectedPath)
            {
                removeTile(gridTile);
            }
            clearSound.play();
        }
        else
        {
            if (getCurrentWord().length == 1)
            {
                unselectSound.stop();
                unselectSound.play();
            }
            else
            {
                badWordSound.play();
            }
        }

        selectedPath = [];
    }

    public function addRowsToBottom(numRows:Int)
    {
        // Move all existing tiles up numRows rows.
        for (x in 0...gridWidth)
        {
            for (y in 0...gridHeight)
            {   
                if (gridTiles[squareId(x,y)] == null)
                    continue;
                var tileToMove:GridTile = gridTiles[squareId(x,y)];
                if (y < numRows)
                {
                    trace("uh oh!!! you are dead");
                }
                else
                {
                    // trace("moving tile from: " + x + ", " + y + " to " + x + ", " + (y-numRows));
                    gridTiles[squareId(x,y)] = null;
                    insertTile(tileToMove, x, y-numRows);
                }
            }
        }
        // Add new tiles in the bottom numRows rows.
        for (x in 0...gridWidth)
            for (y in gridHeight-numRows...gridHeight)
                    addNewLetterTile(x, y);
    }

    public function logGridTiles():Void
    {
        trace("logging tiles");
        for (gridTile in gridTiles)
        {
            if (gridTile != null)
                trace("x: " + gridTile.gridX + ", y: " + gridTile.gridY + ", letter: " + gridTile.getLetter());
        }
    }
}
