package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;


class MiniGrid extends FlxSprite
{
    public var playState:PlayState;

    public static var CELL_WIDTH:Int = 16;
    public static var CELL_HEIGHT:Int = 16;
    public static var MARGIN:Int = 0;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var updateTimer:Float = 0;
    public static var UPDATE_FREQ:Float = 1.5;

    public function new(playState:PlayState, width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        this.playState = playState;

        gridWidth = width;
        gridHeight = height;

        makeGraphic(gridWidth*CELL_WIDTH+1, 
                    gridHeight*CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);

        var emptyBoardString = "";
        for (i in 0...gridWidth*gridHeight) emptyBoardString += "0";
        updateBoard(emptyBoardString);
    }

    public override function update(elapsed:Float)
    {
        updateTimer += elapsed;
        if (updateTimer > UPDATE_FREQ)
        {
            updateTimer = 0;
            
            var boardString = Registry.curGame.getTrackedBoard();
            if (boardString != null && boardString.length == gridWidth * gridHeight)
            {
                updateBoard(boardString);
            }
            else
            {
                trace("not tracking anything");
            }
        }
    }

    public function updateBoard(boardString:String)
    {
        trace("updating board");

        for(y in 0...gridHeight)
        {
            for(x in 0...gridWidth)
            {
                if (boardString.charAt(gridWidth * y + x) == "1")
                {
                    FlxSpriteUtil.drawRect(this, 
                                           x*CELL_WIDTH + MARGIN, 
                                           y*CELL_HEIGHT + MARGIN, 
                                           CELL_WIDTH - MARGIN, 
                                           CELL_HEIGHT - MARGIN,
                                           FlxColor.YELLOW);
                }
                else
                {
                    FlxSpriteUtil.drawRect(this, 
                                            x*CELL_WIDTH + MARGIN, 
                                            y*CELL_HEIGHT + MARGIN, 
                                            CELL_WIDTH - MARGIN, 
                                            CELL_HEIGHT - MARGIN,
                                            FlxColor.BLACK);
                }
            }
        }

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(this, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {color: 0xffffffff, thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(this, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {color: 0xffffffff,thickness: 3});
        }
    }

}
