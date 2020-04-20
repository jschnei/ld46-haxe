//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

import js.html.MessageEvent;
import js.html.WebSocket;


class MultiplayerGame {
    public var players:Map<String, PlayerInfo>;
    public var myName:String;

    public var self:PlayerInfo;

    public function new()
    {
        players = new Map<String, PlayerInfo>();

        myName = Randomizer.getName();
        self = new PlayerInfo(myName, true);

        players.set(myName, self);
    }

    public function addPlayer(playerName:String)
    {
        if (!players.exists(playerName))
        {
            var player:PlayerInfo = new PlayerInfo(playerName);
            players.set(playerName, player);
        }
    }

    public function removePlayer(playerName)
    {
        players.remove(playerName);
    }

    public function getCurrentPlayers():Array<String>
    {
        var ret:Array<String> = new Array<String>();
        for (user in players.keys())
        {
            ret.push(user);
        }

        return ret;
    }

    public function updateBoard(playerName:String, board:String)
    {
        var player:PlayerInfo = players.get(playerName);

        if (player == null)
        {
            trace("error: player does not exist", playerName);
            return;
        }

        player.board = board;
    }

    public function getTrackedBoard():String
    {
        return "";
    }

}
