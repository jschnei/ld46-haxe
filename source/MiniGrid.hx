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

class MiniGrid extends FlxSpriteGroup
{
    public var playState:PlayState;

    public static var CELL_WIDTH:Int = 16;
    public static var CELL_HEIGHT:Int = 16;
    public static var MARGIN:Int = 1;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var tracking:PlayerInfo;

    public var updateTimer:Float = 0;
    public static var UPDATE_FREQ:Float = 1.5;

    public var gridSprite:FlxSprite;
    public var letterSprites:Array<FlxSprite>;

    public function new(playState:PlayState, width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        this.playState = playState;

        gridWidth = width;
        gridHeight = height;
        
        gridSprite = new FlxSprite();
        gridSprite.makeGraphic(gridWidth*CELL_WIDTH+1, 
                               gridHeight*CELL_HEIGHT+1, 
                               FlxColor.TRANSPARENT, true);
        add(gridSprite);

        letterSprites = new Array<FlxSprite>();
        for(y in 0...gridHeight)
        {
            for(x in 0...gridWidth)
            {
                var letterSprite:FlxSprite = new FlxSprite(x*CELL_WIDTH + MARGIN, y*CELL_HEIGHT + MARGIN);
                letterSprite.makeGraphic(CELL_WIDTH - MARGIN, CELL_HEIGHT - MARGIN, FlxColor.WHITE);
                letterSprites.push(letterSprite);
                add(letterSprite);
            }
        }

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(gridSprite, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {color: 0xffffffff, thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(gridSprite, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {color: 0xffffffff,thickness: 3});
        }

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
            
            if (tracking != null &&
                tracking.board != null &&
                tracking.board.length == gridWidth * gridHeight)
            {
                updateBoard(tracking.board);
            }
            else
            {
                trace("not tracking anything");
            }
        }
        super.update(elapsed);
    }

    public function trackPlayer(playerInfo:PlayerInfo)
    {
        tracking = playerInfo;
    }

    public function updateBoard(boardString:String)
    {
        trace("updating board");

        for(y in 0...gridHeight)
        {
            for(x in 0...gridWidth)
            {
                var index = gridWidth * y + x;
                if (boardString.charAt(index) == "1")
                {
                    letterSprites[index].color = FlxColor.RED;
                }
                else
                {
                    letterSprites[index].color = FlxColor.BLACK;
                }
            }
        }

    }

}
