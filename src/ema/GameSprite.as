package ema {
  import org.flixel.*;
  import ema.utils.Log;
  import flash.events.*;
  
  public class GameSprite extends FlxSprite implements IEventDispatcher {
    public var currentState:String;
    protected var boundingBoxes:Object;
    protected var dispatcher:EventDispatcher;
    
    public function GameSprite(X:Number, Y:Number) {
      dispatcher = new EventDispatcher();
      boundingBoxes = {};
      super(X,Y);
    }
    
    public function distance(P1:FlxPoint):Number{
    	var XX:Number = x - P1.x;
    	var YY:Number = y - P1.y;
    	return Math.sqrt( XX * XX + YY * YY );
    }
    
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
      return dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }
    
    public function dispatchEvent(event:Event):Boolean {
     return dispatcher.dispatchEvent(event);
    }
    
    public function hasEventListener(type:String):Boolean {
      return dispatcher.hasEventListener(type);
    }
    
    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
      return dispatcher.removeEventListener(type, listener, useCapture);
    }
    
    public function willTrigger(type:String):Boolean {
      return dispatcher.willTrigger(type);
    }
    
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
        scale.x = Math.abs(scale.x);
      } else if (velocity.x > 0) {
        facing = RIGHT;
        scale.x = Math.abs(scale.x) * -1;
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
    }
    
    protected function bounded():void {
      //bounds o' the world
      if(x > FlxG.width*4-width-4) {
        x = FlxG.width*4-width-4;
      } else if(x < 4) {
        x = 4;
      }
    }
    
    protected function findClosestSprite(pile:FlxGroup):FlxObject {
      var minDist:Number = 18000;
      var minChild:FlxObject;
      for each (var child:FlxObject in pile.members) {
        var dist:Number = distance(child);
        if (dist < minDist) {
          minDist = dist;
          minChild = child;
        }
      }
      return minChild;
    }
    
    public var maxHealth:Number;
    
    public function updateHealth():void {
      if (health >= maxHealth) return;
      else health = health + 1;
    }
    
    protected var currentGraphic:Object;
    
    public function playGraphic(AnimName:String,Force:Boolean=false, graphic:Object=null):void {
      if (graphic) {
        if (currentGraphic != graphic) {
          y -= graphic["height"] - currentGraphic["height"] + frameHeight - height;
/*          x -= graphic["width"] - currentGraphic["width"] + frameWidth - width;*/
          currentGraphic = graphic;
          loadGraphic(graphic["embed"], true, false, graphic["width"], graphic["height"]);
          super.play(AnimName, Force);
          update();
        } else {
          super.play(AnimName, Force);
        }
      }
    }
    
    protected function addAnimationFromSpriteBox(box:Object):void {
      for (var spriteName:String in box) {
        var sprite:Object = box[spriteName];
        addAnimation(spriteName, sprite["spriteArray"], sprite["framesPerSecond"] || 24, sprite["loop"]);
        addBoundingBox.apply(null, [spriteName].concat(sprite["boundingBox"]));
      }
    }
  
  }
}