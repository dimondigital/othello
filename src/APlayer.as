/**
 * Created by ElionSea on 02.02.15.
 */
package
{
import flash.display.Sprite;
import flash.events.MouseEvent;

/* игрок */
public class APlayer implements IPlayer
{
    private var _chipColor:int;
    private var _mainSprite:Sprite;
    private var _ghostChip:McChip;              // призрачная фишка, узазывающая на возможный ход
    private var _legalMoves:Vector.<Cell>;
    private var _playerMoveCallback:Function;
    private var _isCanMove:Boolean;

    /*CONSTRUCTOR*/
    public function APlayer(chipColor:int, mainSprite:Sprite)
    {
        _chipColor = chipColor;
        _mainSprite = mainSprite;

        _ghostChip = new McChip();
        _ghostChip.gotoAndStop(chipColor+1);
    }

    /* START MOVE */
    public function startMove(legalMoves:Vector.<Cell>, playerMoveCallback:Function):void
    {
        _legalMoves = legalMoves;
        _playerMoveCallback = playerMoveCallback;

        _mainSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
        _mainSprite.addEventListener(MouseEvent.CLICK, move);
    }

    /* MOUSE MOVE LISTENER */
    protected function mouseMoveListener(e:MouseEvent):void
    {
        if(e.target is Cell)
        {
            var cell:Cell = Cell(e.target);
            if(cell.state == Cell.EMPTY)
            {
                _ghostChip.alpha = .5;
                cell.addChild(_ghostChip);
            }
        }
        else
        {
            _ghostChip.alpha = 0;
        }
    }

    /* MOVE */
    private function move(e:MouseEvent):void
    {
        if(e.target is Cell)
        {
            var clickCell:Cell = Cell(e.target);
            for each(var legalMoveCell:Cell in _legalMoves)
            {
                if(clickCell == legalMoveCell)
                {
                    _ghostChip.alpha = 0;
                    _mainSprite.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
                    _mainSprite.removeEventListener(MouseEvent.CLICK, move);
                    _playerMoveCallback(clickCell);
                }
            }
        }
    }

    public function get chipColor():int {return _chipColor;}

    public function get isCanMove():Boolean {return _isCanMove;}
    public function set isCanMove(value:Boolean):void {_isCanMove = value;}
}
}
