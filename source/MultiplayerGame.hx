//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

class MultiplayerGame {
    public var players:Map<String, PlayerInfo>;
    public var myName:String;

    public var self:PlayerInfo;

    public var started:Bool = false;

    public function new()
    {
        players = new Map<String, PlayerInfo>();

        myName = Randomizer.getName();
        self = new PlayerInfo(myName, true);

        players.set(myName, self);
    }

    public function addPlayer(playerName:String)
    {
        if (playerName == "") return;

        if (!players.exists(playerName) && !started)
        {
            var player:PlayerInfo = new PlayerInfo(playerName);
            players.set(playerName, player);
        }
    }

    public function removePlayer(playerName)
    {
        players.remove(playerName);
    }

    public function startGame()
    {
        started = true;

        // order the players and set tracking
        var playerNames:Array<String> = getCurrentPlayers();
        playerNames.sort(Reflect.compare);

        for (i in 1...playerNames.length) {
            players[playerNames[i]].setTracking(players[playerNames[i-1]]);
        }
        players[playerNames[0]].setTracking(players[playerNames[playerNames.length - 1]]);
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
    

    public function getCurrentPlayers():Array<String>
    {
        var ret:Array<String> = new Array<String>();
        for (user in players.keys())
        {
            ret.push(user);
        }

        return ret;
    }

    public function getTrackedBoard():String
    {
        if (self.tracking != null) 
        {
            return self.tracking.board;
        }
        return "";
    }

}
