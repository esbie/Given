package ema {
  import flash.display.*;
  import flash.events.*;
  import flash.geom.Point;
  import flash.utils.setInterval;
  import org.flixel.*;

  import ema.utils.Log;

  [SWF(width="640", height="480", backgroundColor="#000000")]
  public class Main extends FlxGame {
    public function Main() {
      super(320,240,PlayState,2);
      Log.out("this is only a test");
      
      //setting stage parameters
      stage.align     = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
/*      stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);*/

/*      setInterval(update, 20);*/
    }
  }
}