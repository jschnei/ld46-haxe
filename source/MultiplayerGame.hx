//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

class MultiplayerGame {
    public var startingPlayerCount:Int = 0;
    public var players:Map<String, PlayerInfo>;
    // Ordered by time of death.
    public var deadPlayers:Array<PlayerInfo>;
    public var myName:String;

    public var self:PlayerInfo;

    public var started:Bool = false;
    public var alive:Bool = true;

    public function new()
    {
        players = new Map<String, PlayerInfo>();
        deadPlayers = new Array<PlayerInfo>();

        myName = Registry.name;
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
        var player = players.get(playerName);
        if (player != null)
        {
            var prevPlayer = player.trackPrev;
            var nextPlayer = player.trackNext;
            if (prevPlayer != null && nextPlayer != null)
            {
                prevPlayer.setTrackNext(nextPlayer);
                nextPlayer.setTrackPrev(prevPlayer);
            }
        }
        var playerAlreadyDead = false;
        for (playerInfo in deadPlayers)
            if (playerInfo.name == playerName)
            {
                playerAlreadyDead = true;
                break;
            }
        if (!playerAlreadyDead)
            deadPlayers.push(player);
        players.remove(playerName);
    }

    public function die()
    {
        if (alive)
        {
            alive = false;
            NetworkingUtils.sendMessage("die");
        }
    }

    public function startGame()
    {
        started = true;
        // order the players and set tracking
        var playerNames:Array<String> = getCurrentPlayers();
        startingPlayerCount = playerNames.length;
        playerNames.sort(Reflect.compare);

        for (i in 1...playerNames.length) {
            players[playerNames[i]].setTrackPrev(players[playerNames[i-1]]);
            players[playerNames[i-1]].setTrackNext(players[playerNames[i]]);
        }
        players[playerNames[0]].setTrackPrev(players[playerNames[playerNames.length - 1]]);
        players[playerNames[playerNames.length - 1]].setTrackNext(players[playerNames[0]]);
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

}
