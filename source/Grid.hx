package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
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

class Grid extends FlxSpriteGroup
{
    public static var CELL_WIDTH:Int = 64;
    public static var CELL_HEIGHT:Int = 64;

    public var gridSprite:FlxSprite;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var gridTiles:Array<GridTile>;
    public var fallingTiles:FlxTypedGroup<GridTile>;

    public var selectedPath:Array<GridTile>;
    public var currentWordText:FlxText;

    public var newTilePeriod:Float = 0;
    public var newTileTimer:Float = 0;
    public var totalTime:Float = 0;

    public static var NETWORK_SYNC_FREQ = 1.5;
    public var network_sync_timer:Float = 0;

    public var selectSound:FlxSound;
    public var unselectSound:FlxSound;
    public var clearSound:FlxSound;
    public var badWordSound:FlxSound;
    public var attackedSound:FlxSound;

    // Coordinates of the last held mouse location. 
    public var mouseHeldX:Float = 0;
    public var mouseHeldY:Float = 0;

    public function new(width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

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
        gridSprite = new FlxSprite();
        gridSprite.makeGraphic(gridWidth*CELL_WIDTH+1, 
                               gridHeight*CELL_HEIGHT+1, 
                               FlxColor.TRANSPARENT, true);
        add(gridSprite);
        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(gridSprite, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {color: 0xffffffff, thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(gridSprite, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {color: 0xffffffff,thickness: 3});
        }

        fallingTiles = new FlxTypedGroup<GridTile>();

        selectSound = FlxG.sound.load(AssetPaths.select__wav);
        unselectSound = FlxG.sound.load(AssetPaths.unselect__wav);
        clearSound = FlxG.sound.load(AssetPaths.clear__wav, .1);
        badWordSound = FlxG.sound.load(AssetPaths.badword__wav, .5);
        attackedSound = FlxG.sound.load(AssetPaths.attacked__wav, .1);

        currentWordText = new FlxText(gridWidth*CELL_WIDTH+10, gridHeight*CELL_HEIGHT/2);
        currentWordText.setFormat(AssetPaths.Fira_Bold__ttf, 90, FlxColor.RED, FlxTextAlign.CENTER);
        // currentWordText is being added in PlayState so it can appear above the grid, sorry for hack

        Registry.curGame.setGrid(this);
    }

    override public function update(elapsed:Float):Void
    {
        if (!Registry.curGame.alive) return;

        totalTime += elapsed;
        for (gridTile in selectedPath)
        {
            gridTile.selected = true;
        }

        currentWordText.text = getCurrentWord();
        currentWordText.y = mouseHeldY - 160;
        currentWordText.x = mouseHeldX - (currentWordText.width / 2);

        newTileTimer += elapsed;
        if (newTileTimer > newTilePeriod) 
        {
            addFallingTile(Randomizer.getColumn());
            newTileTimer = 0;
            newTilePeriod = 1/(Registry.START_FREQ + Registry.FREQ_SCALING * totalTime);
        }

        network_sync_timer += elapsed;
        if (network_sync_timer > NETWORK_SYNC_FREQ)
        {
            NetworkingUtils.sendMessage("sync", gridString());
            network_sync_timer = 0;
        }

        super.update(elapsed);
    }

    public function randomLetter():String
    {
        return Randomizer.getLetter();
    }

    public function addFallingTile(column:Int)
    {
        var tile:GridTile = new LetterTile(this, column, 0, randomLetter());
        fallingTiles.add(tile);
        add(tile);
    }

    public function addNewLetterTile(gridX:Int, gridY:Int)
    {
        var tile:LetterTile = new LetterTile(this, gridX, gridY, randomLetter());
        tile.falling = false;
        add(tile);
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

    public function onMouseHold(dx:Float, dy:Float):Void
    {
        mouseHeldX = dx;
        mouseHeldY = dy;
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
            NetworkingUtils.sendMessage("word", word);
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
        attackedSound.play();
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
                    Registry.curGame.die();
                }
                else
                {
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

    public function gridString():String
    {
        var ret:String = "";
        for (gridTile in gridTiles)
        {
            if (gridTile != null)
            {
                ret += "1";
            }
            else
            {
                ret += "0";
            }
        }

        return ret;
    }
}
