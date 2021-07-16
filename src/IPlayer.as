/**
 * Created by ElionSea on 02.02.15.
 */
package
{
public interface IPlayer
{
    function startMove(legalMoves:Vector.<Cell>, playerMoveCallback:Function):void
    function get chipColor():int
    function get isCanMove():Boolean
    function set isCanMove(value:Boolean):void
}
}
