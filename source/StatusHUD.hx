package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class StatusHUD extends FlxSpriteGroup
{
    public var deadCountText:FlxText;

    public function new(?X:Float = 0, ?Y:Float = 0)
    {
        super(X, Y);

        deadCountText = new FlxText();
        deadCountText.setFormat(AssetPaths.Action_Man__ttf, 20, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(deadCountText);
    }

    public override function update(elapsed:Float)
    {
        var totalPlayers = Registry.curGame.startingPlayerCount;
        var remainingPlayers = totalPlayers - Registry.curGame.deadPlayers.length;
        deadCountText.text = "Players remaining: " + remainingPlayers + "/" + totalPlayers;
        super.update(elapsed);
    }
}