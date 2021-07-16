/**
 * Created by ElionSea on 02.02.15.
 */
package
{

/* счётчик фишек */
public class WinCounter extends McWinCounter
{
    private var _cells:Vector.<Vector.<Cell>>;
    private var _whiteCounter:int;
    private var _blackCounter:int;

    /*CONSTRUCTOR*/
    public function WinCounter(cells:Vector.<Vector.<Cell>>)
    {
        _cells = cells;
    }

    /* UPDATE VIEW */
    public function updateView():void
    {
        _whiteCounter = 0;
        _blackCounter = 0;
        for (var row:int = 0; row < _cells.length; row++)
        {
            for (var col:int = 0; col < _cells[row].length; col++)
            {
                var cell:Cell = _cells[row][col];
                if(cell.state == Cell.BLACK)        _blackCounter++;
                else if(cell.state == Cell.WHITE)   _whiteCounter++;
            }
        }

        whiteCount.text = _whiteCounter.toString();
        blackCount.text = _blackCounter.toString();
    }

    public function get whiteCounter():int {return _whiteCounter;}

    public function get blackCounter():int {return _blackCounter;
    }
}
}
