package ema {
  import org.flixel.*;
  import ema.utils.Log;

  [SWF(width="800", height="400", backgroundColor="#000000")]
  public class Main extends FlxGame {
    public function Main() {
      super(800,400,PlayState,1);
    }
  }
}