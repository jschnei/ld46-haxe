package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
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
    var letterText:FlxText; 
    var letterTileSprite:FlxSprite;
    public function new(grid:Grid, gridX:Int, gridY:Int, letter:String)
    {
        super(grid, gridX, gridY);
        letterTileSprite = new FlxSprite();
        letterTileSprite.makeGraphic(Grid.CELL_WIDTH, Grid.CELL_HEIGHT, FlxColor.fromRGB(255,255,0,100));
        letterTileSprite.x = gridX;
        letterTileSprite.y = gridY;
        add(letterTileSprite);
        letterText = new FlxText(gridX,gridY,0, letter);
        letterText.setFormat(AssetPaths.Action_Man__ttf, 90, FlxColor.RED, FlxTextAlign.CENTER);
        letterText.width += 10;
        add(letterText);
    }

    public override function update(elapsed:Float)
    {
        if (selected)
            letterTileSprite.color = 0xff0000;
        else
            letterTileSprite.color = 0xffffff;
        super.update(elapsed);
    }
}
