/**
 * Created by ElionSea on 02.02.15.
 */
package
{

/* ячейка поля */
public class Cell extends McCell
{
    private var _state:int;
    private var _row:int;
    private var _col:int;
    private var _name:String;
    private var _profitIndex:int;   // изначальный коэффициент пользы от хода (определяют важность хода для AI)
    private var _addIndex:int;      // дополнительный индекс (меняется в зависимости от количества фишек, которые можно перевернуть за раз, ходом на эту ячейку)
    private var _flipsByMove:Vector.<Cell>; // переварачивающиеся фишки при активации хода

    public static const EMPTY:int = 1;
    public static const BLACK:int = 2;
    public static const WHITE:int = 3;

    public static const LABEL:String = "label_";

    /*CONSTRUCTOR*/
    public function Cell(state:int, row:int, col:int)
    {
        this.state = state;
        this.gotoAndStop(LABEL+String(state));
        _row = row;
        _col = col;
        _name = String(_row) + "_" + String(_col);
//        tf.text = name;
        tf.text = "";
        this.mouseChildren = false;
    }

    /* UPDATE BG */
    // тестовое подвсвечивание ячейки.
    // Жёлтый - перевернулся в прошлом ходу,
    // Голубой - возможный ход (в текущем состоянии для обоих игроков)
    // Красный - прошлый ход
    public function updateBg(frame:int):void
    {
//        bg.gotoAndStop(frame);
    }

    public function get state():int {return _state;}
    public function set state(value:int):void
    {
        _state = value;
//        tf.text = _state.toString();
    }

    public function get profitIndex():int {return _profitIndex;}
    public function set profitIndex(value:int):void {_profitIndex = value;}

    public function get addIndex():int {return _addIndex;}
    public function set addIndex(value:int):void {_addIndex = value;}

    public function get row():int {return _row;}

    public function get col():int {return _col;}

    public function get flipsByMove():Vector.<Cell> {return _flipsByMove;}
    public function set flipsByMove(value:Vector.<Cell>):void {_flipsByMove = value;}

    public override function get name():String{return _name;}

    public function get totalIndex():int
    {
        return _profitIndex + _addIndex;
    }
}
}
