/**
 * Created by ElionSea on 02.02.15.
 */
package
{
/* AI */
public class ABot implements IPlayer
{
    private var _chipColor:int;
    private var _legalMoves:Vector.<Cell>;
    private var _playerMoveCallback:Function;
    private var _isCanMove:Boolean;

    /*CONSTRUCTOR*/
    public function ABot(chipColor:int)
    {
        _chipColor = chipColor;
    }

    /* MOVE */
    public function startMove(legalMoves:Vector.<Cell>, playerMoveCallback:Function):void
    {
        _legalMoves = legalMoves;
        _playerMoveCallback = playerMoveCallback;

        var moveCell:Cell = bestMove();
        _playerMoveCallback(moveCell);
    }

    /* BEST MOVE */
    // возвращает из массива элемент с наибольшим totalIndex
    private function bestMove():Cell
    {
        // если возможные ходы существуют
        if(_legalMoves.length > 0)
        {
            var bestMove:Cell = _legalMoves[0];
            // если остался один элемент - он лучший
            if(_legalMoves.length == 1)
            {
                return bestMove;
            }
            for each(var cell:Cell in _legalMoves)
            {
                // если у следующего больший приоритет, чем у текущего, следующий не является текущим и следующий - пустой
                if(cell.totalIndex > bestMove.totalIndex && cell != bestMove && cell.state == Cell.EMPTY)
                {
                    // следующий становится лучшим
                    bestMove = cell;
                }
            }
        }
        else
        {
            trace("возможных ходов не существует");
        }
        return bestMove;
    }

    public function get chipColor():int {return _chipColor;}

    public function get isCanMove():Boolean {return _isCanMove;}
    public function set isCanMove(value:Boolean):void {_isCanMove = value;}
}
}
