package;

import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxSave;

class Game
{
    public var playState:PlayState;

    public var width:Int;
    public var height:Int;

    public function new(width:Int, height:Int)
    {
        this.width = width;
        this.height = height;

        // field = new Vector<FieldType>(width*height);
        // for(i in 0...(width*height))
        // {
        //     field[i] = FieldType.FLOOR;
        // }

    }

    public function getSquare(x:Int, y:Int):Int
    {
        return y*width + x;
    }

}
