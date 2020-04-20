//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

import js.html.MessageEvent;
import js.html.WebSocket;


class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static var name:String;

    public static var players:Map<String, PlayerInfo>;
    public static var playerBoards:Map<String, String>;
    public static var track:String = "";

    public static function initialize() 
    {   
        name = Randomizer.getName();
        trace('name:', name);

        players = new Map<String, PlayerInfo>();
        playerBoards = new Map<String, String>();

        ws = new WebSocket("ws://localhost:9999/");
        ws.onopen = function() 
        {
            trace('open!');
            sendMessage("join");
        };
        
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }

        ws.onmessage = onMessage;
    }

    public static function sendMessage(type: String, ?message: String = "")
    {
        trace("sending message type", type);
        if (isOpen)
        {
            var messageBlob:Dynamic<String> = {};
            messageBlob.type = type;
            messageBlob.name = name;
            messageBlob.message = message;
            ws.send(Json.stringify(messageBlob));
        }
    }

    public static function onMessage(message:MessageEvent)
    {
        // trace('message from server!');
        trace(message.data);
        var messageObject = Json.parse(message.data);

        trace("incoming message type", messageObject.type);

        switch (messageObject.type)
        {
            case "join":
                processJoinMessage(messageObject);
            case "leave":
                processLeaveMessage(messageObject);
            case "sync":
                processSyncMessage(messageObject);
            case "players":
                processPlayersMessage(messageObject);
            
        }
    }

    public static function processJoinMessage(message:Dynamic)
    {
        var playerName:String = message.name;

        var player:PlayerInfo = new PlayerInfo(playerName);
        players.set(playerName, player);

        trace("added player", playerName);
    }

    public static function processLeaveMessage(message:Dynamic)
    {
        var playerName:String = message.name;

        players.remove(playerName);
    }

    public static function processPlayersMessage(message:Dynamic)
    {
        var existingPlayers:Array<String> = message.players.split(",");
        for (playerName in existingPlayers)
        {
            if (!players.exists(playerName))
            {
                var player = new PlayerInfo(playerName);
                players.set(playerName, player);
            }
        }
    }

    public static function processSyncMessage(message:Dynamic)
    {
        var msg_name:String = message.name;
        var board:String = message.board;

        trace('msg_name', msg_name);
        trace('board', board);

        // if we are not tracking anything and see a name 
        // that isn't ours, track it
        if (track == "" && msg_name != name)
        {
            track = msg_name;
            trace("now tracking", track);
        }

        playerBoards.set(msg_name, board);
    }

    public static function getTrackedBoard():String 
    {
        if (playerBoards.exists(track))
            return playerBoards.get(track);
        return "";
    }

    public static function getCurrentPlayers():Array<String>
    {
        var ret:Array<String> = new Array<String>();
        for (user in players.keys())
        {
            ret.push(user);
        }

        return ret;
    }
}
