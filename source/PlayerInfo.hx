package;

import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxSave;

class PlayerInfo
{   
    public var name:String;
    public var nickname:String;
    public var board:String;

    public var self:Bool = false;

    public var trackNext:PlayerInfo;
    public var trackPrev:PlayerInfo;

    public function new(name:String, ?nickname:String="", ?self:Bool=false)
    {
        this.name = name;

        if (nickname == "")
        {
            this.nickname = name;
        }
        else
        {
            this.nickname = nickname;
        }

        this.self = self;
    }

    public function setBoard(board:String)
    {
        this.board = board;
    }

    public function setTrackNext(tracking:PlayerInfo)
    {
        if (trackNext != this)
            this.trackNext = tracking;
    }

    public function setTrackPrev(tracking:PlayerInfo)
    {
        if (trackPrev != this)
            this.trackPrev = tracking;
    }

}

