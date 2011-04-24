package ema {
  import org.flixel.*;
  import ema.utils.Log;
  
  public class GameSprite extends FlxSprite {
    
    public function GameSprite(X:Number, Y:Number) {
      super(X,Y);
    }
    
    public var currentState:String;
    
    //making these class variables so we aren't making new point objects on every update
    //these assume that asset is facing to the left
    protected var scaleLeft:FlxPoint = new FlxPoint(1,1);
    protected var scaleRight:FlxPoint = new FlxPoint(-1,1);
    
    protected function updateFacing():void {
      if (velocity.x < 0) {
        facing = LEFT;
        scale = scaleLeft;
      } else if (velocity.x > 0) {
        facing = RIGHT;
        scale = scaleRight;
      }
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

    override public function update():void {
      super.update();
      
      //bounds o' the world
      if(x > FlxG.width*2-width-4) {
        x = FlxG.width*2-width-4;
      } else if(x < 4) {
        x = 4;
      }
    }
  
  }
}