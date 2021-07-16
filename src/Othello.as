package
{

import flash.display.Sprite;

[SWF (width="550", height="400", frameRate="30", backgroundColor="0x333333")]
public class Othello extends Sprite
{
    private var _gameController:GameController;
    private var _mainSprite:McMainSprite;

    public function Othello()
    {
        _mainSprite = new McMainSprite();
        stage.addChild(_mainSprite);
        _gameController = new GameController(_mainSprite, stage);
        _gameController.init();
        _gameController.choosePlayer();
    }
}
}
