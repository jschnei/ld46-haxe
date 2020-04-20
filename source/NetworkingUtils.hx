//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

import js.html.MessageEvent;
import js.html.WebSocket;


class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static var players:Map<String, PlayerInfo>;
    public static var playerBoards:Map<String, String>;
    public static var track:String = "";

    public static function initialize() 
    {
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
            messageBlob.name = Registry.curGame.myName;
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
            case "start":
                processStartMessage(messageObject);
            case "players":
                processPlayersMessage(messageObject);
            
        }
    }

    public static function processJoinMessage(message:Dynamic)
    {
        var playerName:String = message.name;

        Registry.curGame.addPlayer(playerName);
    }

    public static function processLeaveMessage(message:Dynamic)
    {
        var playerName:String = message.name;
        Registry.curGame.removePlayer(playerName);
    }

    public static function processStartMessage(message:Dynamic)
    {
        Registry.curGame.startGame();
    }

    public static function processPlayersMessage(message:Dynamic)
    {
        var existingPlayers:Array<String> = message.players.split(",");
        for (playerName in existingPlayers)
        {
            Registry.curGame.addPlayer(playerName);
        }
    }

    public static function processSyncMessage(message:Dynamic)
    {
        var playerName:String = message.name;
        var board:String = message.board;

        Registry.curGame.updateBoard(playerName, board);
    }


}
