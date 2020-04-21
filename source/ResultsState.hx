package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import haxe.io.Eof;

class ResultsState extends FlxState
{
    public var resultsHeaderText:FlxText;
    public var resultsText:FlxText;

    override public function create():Void
    {
        resultsHeaderText = new FlxText();
        resultsHeaderText.setFormat(AssetPaths.Action_Man__ttf, 40, FlxColor.ORANGE, FlxTextAlign.CENTER);
        resultsHeaderText.text = "FINAL STANDINGS";
        resultsHeaderText.x = (FlxG.width - resultsHeaderText.width) / 2;
        resultsHeaderText.y = 100;
        add(resultsHeaderText);

        resultsText = new FlxText();
        resultsText.setFormat(AssetPaths.Action_Man__ttf, 20, FlxColor.RED, FlxTextAlign.LEFT);
        var resultsStr:String = "";
        for (i in 0...Registry.curGame.startingPlayerCount)
        {
            var player = Registry.curGame.deadPlayers[Registry.curGame.startingPlayerCount - i - 1];
            if (i > 0)
                resultsStr += "\n";
            if (player != null)
                resultsStr += (i+1) + ". " + player.nickname;
        }
        resultsText.text = resultsStr;
        resultsText.x = (FlxG.width - resultsText.width) / 2;
        resultsText.y = 200;
        add(resultsText);
    }
}