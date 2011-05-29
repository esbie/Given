package ema {
  import org.flixel.*;
  import ema.utils.Log;
  
  public class GameSprite extends FlxSprite {
    
    public function GameSprite(X:Number, Y:Number) {
      boundingBoxes = {};
      super(X,Y);
    }
    
    public var currentState:String;
    
    protected var boundingBoxes:Object;
    
    protected function addBoundingBox(name:String, X:Number, Y:Number, W:Number, H:Number):void {
      boundingBoxes[name] = {
        width: W,
        height: H,
        offsetX: X,
        offsetY: Y
      };
    }
    
    protected function applyBoundingBox(name:String):void {
      var box:Object = boundingBoxes[name];
      
      var heightDelta:Number = height - box.height;
      
      width = box.width;
      height = box.height;
      offset.x = box.offsetX;
      offset.y = box.offsetY;
      
      y += heightDelta;
    }
    
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