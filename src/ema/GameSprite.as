package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class GameSprite extends FlxSprite {
	  
	  public function GameSprite(X:Number, Y:Number) {
	    super(X,Y);
	  }
	  
	  protected function spriteArray(start:Number, end:Number):Array {
      var result:Array = new Array();
      var i:Number = start;

      while (i != end) {
        result.push(i);
        i++;
      }
      
      return result;
    }
	
	}
}