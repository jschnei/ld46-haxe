package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;

class GridTile extends FlxSpriteGroup
{
    public var grid:Grid;
    public var gridX:Int;
    public var gridY:Int;

    public var selected:Bool;

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
            velocity.y = Registry.FALL_SPEED;

            var topTile = grid.columnTop(gridX);
            var dy = y - grid.y;
            if (dy >= (topTile - 1) * Grid.CELL_HEIGHT) 
            {
                if (topTile - 1 >= 0)
                {
                    grid.insertFallingTile(this, gridX, topTile-1);
                } else{
                    // this block is stuck off the top
                    trace("oh no!");
                    Registry.curGame.die();
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

    public function getLetter():String
    {
        return "";
    }

    public override function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }
}

class LetterTile extends GridTile 
{
    var letter:String;    
    var letterText:FlxText; 
    var letterTileSprite:FlxSprite;
    public function new(grid:Grid, gridX:Int, gridY:Int, letter:String)
    {
        super(grid, gridX, gridY);
        letterTileSprite = new FlxSprite();
        letterTileSprite.makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRoundRect(letterTileSprite, 0, 0, Grid.CELL_WIDTH, Grid.CELL_HEIGHT, 10, 10, FlxColor.fromRGB(0,255,255,255));
        FlxSpriteUtil.drawRoundRect(letterTileSprite, 4, 4, Grid.CELL_WIDTH-8, Grid.CELL_HEIGHT-8, 10, 10, FlxColor.fromRGB(0,200,200,255));
        add(letterTileSprite);
        letterText = new FlxText(7, 5, 0, letter);
        letterText.setFormat(AssetPaths.Fira_Bold__ttf, 70, FlxColor.BLACK, FlxTextAlign.CENTER);
        letterText.width = Grid.CELL_WIDTH;
        add(letterText);
        
        this.letter = letter;
    }

    public override function update(elapsed:Float)
    {
        if (selected)
            letterTileSprite.color = FlxColor.fromRGB(0,100,100,255);
        else
            letterTileSprite.color = FlxColor.fromRGB(0,255,255,255);
        super.update(elapsed);
    }

    public override function getLetter():String
    {
        return letter;
    }
}
