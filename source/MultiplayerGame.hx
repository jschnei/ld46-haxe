//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

class MultiplayerGame {
    public var grid:Grid;

    public var startingPlayerCount:Int = 0;
    public var players:Map<String, PlayerInfo>;
    // Ordered by time of death.
    public var deadPlayers:Array<PlayerInfo>;
    public var myName:String;
    public var myNickname:String;

    public var self:PlayerInfo;

    public var started:Bool = false;
    public var alive:Bool = true;

    public function new()
    {
        players = new Map<String, PlayerInfo>();
        deadPlayers = new Array<PlayerInfo>();

        myNickname = Registry.nickname;
        myName = Randomizer.getName();
        self = new PlayerInfo(myName, myNickname, true);

        players.set(myName, self);
    }

    public function setGrid(grid:Grid)
    {
        this.grid = grid;
    }

    public function addPlayer(playerName:String, ?playerNickname:String="")
    {
        if (playerName == "") return;

        if (!players.exists(playerName) && !started)
        {
            var player:PlayerInfo = new PlayerInfo(playerName, playerNickname);
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
        var playerNames:Array<String> = getCurrentPlayerNames();
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
            // trace("error: player does not exist", playerName);
            return;
        }

        player.board = board;
    }

    public function processWord(playerName:String, word:String)
    {
        var player:PlayerInfo = players.get(playerName);

        trace("PROCESSING WORD", playerName, word);

        if (player == null)
        {
            trace("error: player does not exist", playerName);
            return;
        }

        if (player.trackNext == self)
        {
            trace("ATTACK!");
            if (word.length >= 5)
            {
                if (grid != null)
                {
                    grid.addRowsToBottom(word.length - 4);
                }
            }
        }
    }
    

    public function getCurrentPlayerNames():Array<String>
    {
        var ret:Array<String> = new Array<String>();
        for (playerName in players.keys())
        {
            ret.push(playerName);
        }

        return ret;
    }

    public function getCurrentPlayerNicknames():Array<String>
    {
        var ret:Array<String> = new Array<String>();
        for (playerName in players.keys())
        {
            ret.push(players[playerName].nickname);
        }

        return ret;
    }

    public function numRemainingPlayers():Int
    {
        return startingPlayerCount - deadPlayers.length;
    }
}
