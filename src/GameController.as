/**
 * Created by ElionSea on 02.02.15.
 */
package
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

/* игровой контроллер */
public class GameController
{
    private var _mainSprite:Sprite;
    private var _board:Board;
    private var _console:McConsole;
    private var _winCounter:WinCounter;
    private var _players:Vector.<IPlayer>;
    private var _currentPlayer:IPlayer;
    private var _stage:Stage;
    private var _newGameBtn:BtnNewGame;

    /*CONSTRUCTOR*/
    public function GameController(mainSprite:Sprite, stage:Stage)
    {
        _mainSprite = mainSprite;
        _stage = stage;
    }

    /* INIT */
    public function init():void
    {
        // построение игрового поля
        _board = new Board(_mainSprite);
        _board.buildBoard();
        _board.startState();

        // консоль
        _console = new McConsole();
        _mainSprite.addChild(_console);
        _console.y = _mainSprite.height-_console.height;

        // счёт
        _winCounter = new WinCounter(_board.cells);
        _mainSprite.addChild(_winCounter);
        _winCounter.updateView();

        _newGameBtn = new BtnNewGame();
        _newGameBtn.x = 415;
        _newGameBtn.y = 330;
        _mainSprite.addChild(_newGameBtn);
        _newGameBtn.visible = false;
        _newGameBtn.addEventListener(MouseEvent.CLICK, globalReset);

        // игроки
        _players = new Vector.<IPlayer>();
        _players.push(new APlayer(Cell.WHITE, _mainSprite));
        _players.push(new ABot(Cell.BLACK));
    }

    /* CHOOSE PLAYER */
    public function choosePlayer():void
    {
        if(_currentPlayer == _players[0])
        {
            _currentPlayer = _players[1];
            _console.consoleText.text = "AI MOVED"
        }
        else
        {
            _currentPlayer = _players[0];
            _console.consoleText.text = "YOUR MOVE"
        }

        _board.updateLegalMoves(_currentPlayer.chipColor);
        _currentPlayer.startMove(_board.legalMoves, playerMove);
    }

    /* MOVE */
    private function playerMove(choosedCell:Cell):void
    {
//        trace("_-_-_-_-_-_-_-_-_-_-_-_-_");
        _board.animateMove(choosedCell, _currentPlayer.chipColor, checkForEndGame);
        _winCounter.updateView();
    }

    /* CHECK FOR END GAME */
    private function checkForEndGame():void
    {
        var anyCanMoves:Boolean;
        var nextPlayer:IPlayer;
        for each(var player:IPlayer in _players)
        {
            var legalMoves:Vector.<Cell> = _board.updateLegalMoves(player.chipColor);
             player.isCanMove = !(legalMoves.length == 0);
            if(!anyCanMoves && player.isCanMove) anyCanMoves = true;
            if(_players.indexOf(_currentPlayer) == 0) nextPlayer = _players[1];
            else                                      nextPlayer = _players[0];
        }

        // никто не может походить
        if(!anyCanMoves)
        {
            if(_winCounter.blackCounter < _winCounter.whiteCounter)
            {
                _console.consoleText.text = "CONGRATULATIONS ! YOU WIN !";
            }
            else if(_winCounter.blackCounter > _winCounter.whiteCounter)
            {
                _console.consoleText.text = "Sorry, but you lose";
            }
            else
            {
                _console.consoleText.text = "Dead heat";
            }
            _newGameBtn.visible = true;
        }
        // если у следующего игрока нет возможности походить - ходит опять текущий
        else if(!nextPlayer.isCanMove)
        {
            if(nextPlayer is ABot) _console.consoleText.text = "AI can not move";
            else _console.consoleText.text = "You can not move";
            // изменяем текущего игрока, чтобы функция choosePlayer опять вернула ход к текущему
            _currentPlayer = nextPlayer;
            choosePlayer();
        }
        // ходит следующий игрок
        else
        {
            choosePlayer();
        }
    }

    /* GLOBAL RESET */
    private function globalReset(e:MouseEvent):void
    {
        _currentPlayer = null;
        _board.startState();
        _winCounter.updateView();

        _newGameBtn.visible = false;

        choosePlayer();
    }




}
}
