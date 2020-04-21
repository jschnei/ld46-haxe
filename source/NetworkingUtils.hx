//import haxe.net.WebSocket;
import js.html.URLSearchParams;
import haxe.DynamicAccess;
import haxe.Json;

import js.Browser;
import js.html.MessageEvent;
import js.html.URL;
import js.html.WebSocket;

class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static var room:String;

    public static function initialize() 
    {
        room = getRoomName();
        trace("room name:", room);

        ws = new WebSocket(Registry.SERVER_ADDRESS);
        ws.onopen = function() 
        {
            trace('open!');
            sendMessage("join", Registry.curGame.myNickname);
        };
        
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }

        ws.onmessage = onMessage;
    }

    public static function getRoomName()
    {
        var doc = Browser.window.document;
        var url:URL = new URL(doc.URL);
        
        if (url.searchParams.has("room")) 
        {
            return url.searchParams.get("room").toLowerCase();
        }
        else
        {
            return Randomizer.getName().toLowerCase();
        }
    }

    public static function sendMessage(type: String, ?message: String = "")
    {
        trace("sending message type", type);
        if (isOpen)
        {
            var messageBlob:Dynamic<String> = {};
            messageBlob.type = type;
            messageBlob.name = Registry.curGame.myName;
            messageBlob.room = room;
            messageBlob.message = message;
            ws.send(Json.stringify(messageBlob));
        }
    }

    public static function onMessage(message:MessageEvent)
    {
        // trace('message from server!');
        // trace(message.data);
        var messageObject = Json.parse(message.data);

        // trace("incoming message type", messageObject.type);

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
            case "word":
                processWordMessage(messageObject);
        }
    }

    public static function processJoinMessage(message:Dynamic)
    {
        var playerName:String = message.name;
        var playerNickname:String = message.nickname;

        Registry.curGame.addPlayer(playerName, playerNickname);
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
        var existingNicknames:Array<String> = message.nicknames.split(",");

        var numPlayers = existingPlayers.length;

        for (i in 0...numPlayers)
        {
            Registry.curGame.addPlayer(existingPlayers[i], existingNicknames[i]);
        }
    }

    public static function processSyncMessage(message:Dynamic)
    {
        var playerName:String = message.name;
        var board:String = message.board;

        Registry.curGame.updateBoard(playerName, board);
    }

    public static function processWordMessage(message:Dynamic)
    {
        var playerName:String = message.name;
        var word:String = message.word;

        Registry.curGame.processWord(playerName, word);
    }

}
