/**
 * Created by ElionSea on 02.02.15.
 */
package
{
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

/* поле с ячейками */
public class Board
{
    private var _mainSprite:Sprite;
    private var _cells:Vector.<Vector.<Cell>>; // поле с ячейками
    private var _legalMoves:Vector.<Cell>;      // возможные ходы

    /*CONSTRUCTOR*/
    public function Board(mainSprite:Sprite)
    {
        _mainSprite = mainSprite;
    }

    /* BUILD BOARD */
    public function buildBoard():void
    {
        _cells = new Vector.<Vector.<Cell>>();
        for (var row:int = 0; row < 8; row++)
        {
            _cells[row] = new Vector.<Cell>();
            for (var col:int = 0; col < 8; col++)
            {
                var cell:Cell = new Cell(Cell.EMPTY, row, col);
                _cells[row][col] = cell;
                cell.x = (col*cell.width) + _mainSprite.width/4;
                cell.y = (row*cell.width);
                _mainSprite.addChild(cell);
            }
        }
    }

    /* START STATE */
    public function startState():void
    {
        // размещение первых четырёх фишек
        for (var row:int = 0; row < 8; row++)
        {
            for (var col:int = 0; col < 8; col++)
            {
                var cell:Cell = _cells[row][col];
                if(row < 5 && row > 2 && col < 5 && col > 2)
                {
                    if(row == col)  cell.state = Cell.BLACK;
                    else            cell.state = Cell.WHITE;
                }
                else
                {
                    cell.state = Cell.EMPTY;
                }
                cell.gotoAndStop(Cell.LABEL+String(cell.state));
            }
        }

        indexAll();
    }

    /* INDEX ALL */
    // расстановка коэффициента важных/неважных ячеек. (Влияет на выбор хода компьютера)
    private function indexAll():void
    {
        // угловым ячейкaм и прилежащим к краю, повышается рейтинг, а прилегающим к угловым и прилегающим к крайним - понижается
        for (var i:int = 0; i < 8; i++)
        {
            for (var j:int = 0; j < 8; j++)
            {
                var cell:Cell = _cells[i][j];
                // абсолютная разница ряда и столбца
                var abs:uint = Math.abs(i-j);
                // прилегающие к краям
                if(i == 0 || i == 7 || j == 0 || j == 7)
                {
                    cell.profitIndex += 2;
                    // угловые (позиционно самые важные)
                    if(i == j || abs == 7)  cell.profitIndex += 5;
                }
                // прилегающие к крайним (позиционно самые проигрышные)
                if(i == 1 || j == 1 || i == 6 || j == 6)
                {
                    cell.profitIndex -= 3;
                    // прилегающие крайние к угловым
                    if(abs == 0 || abs == 1 || abs == 5 || abs == 6)
                    {
                        // исключение некоторых
                        if((i != 2 && j != 2) && (i != 5 && j != 5))
                        {
                            cell.profitIndex -= 3;
                        }
                    }
                }
                // отображение индекса ячеек
//                cell.tf.text = String(cell.profitIndex);
            }
        }
    }

    /* UPDATE LEGAL MOVES */
    // обновление возможных ходов
    public function updateLegalMoves(playerColor:int):Vector.<Cell>
    {
        _legalMoves = new Vector.<Cell>();
        for (var row:int = 0; row < 8; row++)
        {
            for (var col:int = 0; col < 8; col++)
            {
                var cell:Cell = _cells[row][col];
                // проверяем все возможные ходы только от пустых ячеек
                if(cell.state == Cell.EMPTY)
                {
                    var turnings:Vector.<Cell> = new Vector.<Cell>();
                    turnings = ghostMove(cell, playerColor);
                    cell.flipsByMove = turnings.concat();
                    if(cell.flipsByMove.length > 0)
                    {
//                        trace("CELL : " + cell.name);
                        cell.updateBg(4);
                    }
                    for each(var flip:Cell in cell.flipsByMove)
                    {
//                        trace("FLIP : " + flip.name);
                    }
                    turnings = null;

                    if(cell.flipsByMove != null)
                    {
                        // если хоть что-то переварачивается - ход возможен
                        if(cell.flipsByMove.length != 0)
                        {
                            _legalMoves.push(cell);
                            // повышаем приоритет хода, за счёт количества возможных переворотов
                            cell.addIndex = cell.flipsByMove.length;
                        }
                    }
                }
            }
        }
        return _legalMoves;
    }

    /* GHOST MOVE */
    public function ghostMove(cell:Cell, playerColor:int):Vector.<Cell>
    {
        var flipArray:Vector.<Cell> = search(cell, playerColor);
        return flipArray;
    }

    /* ANIMATE MOVE */
    public function animateMove(choosedCell:Cell, playerColor:int, endAmimationCallback:Function):void
    {
        // кладём фишку хода
        choosedCell.state = playerColor;
        choosedCell.gotoAndStop(Cell.LABEL+String(choosedCell.state));
        choosedCell.updateBg(3);

        // переворачиваем все оставшиеся
        for each(var turningCell:Cell in choosedCell.flipsByMove)
        {
            if(turningCell.state == Cell.BLACK)
            {
                turningCell.gotoAndPlay("blackToWhite");
                turningCell.state = Cell.WHITE;
            }
            else if(turningCell.state == Cell.WHITE)
            {
                turningCell.gotoAndPlay("whiteToBlack");
                turningCell.state = Cell.BLACK;
            }
//            turningCell.updateBg(2);

            for (var row:int = 0; row < 8; row++)
            {
                for (var col:int = 0; col < 8; col++)
                {
                    var otherCell:Cell = _cells[row][col];

                        if(choosedCell.flipsByMove.indexOf(otherCell) == -1 && otherCell != choosedCell)
                        {
                            otherCell.updateBg(1);
                        }
                }
            }
        }

        var timer:Timer = new Timer(1000, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, tick);
        timer.start();

        function tick(e:TimerEvent):void
        {
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, tick);
            timer = null;

            endAmimationCallback();
        }
    }

    /* SEARCH */
    private function search(cell:Cell, playerColor:int):Vector.<Cell>
    {
        var allFlips: Vector.<Cell> = new Vector.<Cell>();
        var direction:uint = 1;

        // ищем по всем восьми направлениям
        while(direction < 9)
        {
            // временный массив, содержащий кандидатов на переворот или пустой
            var tempArray: Vector.<Cell> = new Vector.<Cell>();
            tempArray = streak(direction, cell, playerColor, _cells);
            // если не пустой - добавляем в общий массив
            if(tempArray != null)
            {
                allFlips = allFlips.concat(tempArray);
            }
            // меняем направление поиска
            direction++;
        }
        return allFlips;
    }

     /* STREAK */
    // возвращает массив кандидатов на переворот по,указанному в аргументе, направлению
    private function streak(dir:int, start:Cell, playerColor:int, cells:Vector.<Vector.<Cell>>):Vector.<Cell>
    {

        var current:Cell = start;
        var count:uint = 1;   // счётчик
        var countRow:int = 0; // два индекса, которые изменяются в зависимости от направления поиска.
        var countCol:int = 0; // влияют на ряд и столбец следующего в поиске
        switch(dir)
        {
            // влево
            case 1:
                countCol--;
                break;
            // вверх влево
            case 2:
                countCol--;
                countRow--;
                break;
            // вверх
            case 3:
                countRow--;
                break;
            // вверх вправо
            case 4:
                countRow--;
                countCol++;
                break;
            // вправо
            case 5:
                countCol++;
                break;
            // вниз вправо
            case 6:
                countRow++;
                countCol++;
                break;
            // вниз
            case 7:
                countRow++;
                break;
            // вниз влево
            case 8:
                countRow++;
                countCol--;
                break;
        }
        var flips:Vector.<Cell> = new Vector.<Cell>;
        while(count <= 8)
        {
            var nextRow:int = current.row + countRow;
            var nextCol:int = current.col + countCol;

            // если значения не выпадают за допустимые
            if(nextRow >= 0 && nextCol >= 0 && nextRow <= 7 && nextCol <= 7)
            {
                var next:Cell = cells[nextRow][nextCol];
            }
            else
            {
                // возврат и смена направления поиска
                return null;
            }
            // если next существует
            if(next != null)
            {
                // если следующий не пустой
                if(next.state != Cell.EMPTY)
                {
                        var opposedColor:int;
                        if(playerColor == Cell.WHITE)       opposedColor = Cell.BLACK;
                        else if(playerColor == Cell.BLACK)  opposedColor = Cell.WHITE;
                    // если следующий противоположного цвета
                    if(next.state == opposedColor)
                    {
//                        trace("PUSH FLIP : " + next.name);
                        flips.push(next);
//                        trace("flips.length : " + flips[0].name);
                    }
                    // если следующий такого же цвета, не является первым в массиве
                    else if(next.state != opposedColor)
                    {
                        if(flips.length > 0) if(next != flips[0])  return flips;
                        return null;
                    }
                }
                // если следующий пустой
                else
                {
                    return null;
                }
            }
            // задаём следующий текущим
            current = next;
            count++;
        }
        return flips;
    }

    public function get cells():Vector.<Vector.<Cell>> {return _cells;}

    public function get legalMoves():Vector.<Cell> {return _legalMoves;}
}
}
