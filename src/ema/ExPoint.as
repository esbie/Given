package ema {
	import org.flixel.*;
	import ema.utils.Log;
	import flash.utils.*;
	import flash.events.Event;
	
	public class ExPoint extends FlxSprite {
 	  [Embed(source="sprites/point.png")] private var PointEmbed:Class
 	  
 	  protected var child:Child;
 	  protected var childOffset:FlxPoint;
 	  
 	  protected var lerpX:Array;
 	  protected var lerpY:Array;
 	  
 	  public function ExPoint(c:Child) {
  	  super(c.x,c.y);
  	  child = c;
      visible = false;
      active = false;
      loadGraphic(PointEmbed, false, false);
      child.addEventListener("learn", onChildLearn);
      
      maxVelocity.x = 200;			//walking speed
      maxVelocity.y = 200;			//walking speed
      drag.x = maxVelocity.x*8;		//deceleration (sliding to a stop)
      drag.y = maxVelocity.y*8;
      
  	  color = child.color;
  	  childOffset = new FlxPoint(14, -height - 5);
    }
    
    override public function update():void {
      followObject(child);
      if (dead) {
        alpha -= 0.05;
      }
      if (alpha == 0) {
        active = false;
        visible = false;
        dead = false;
        alpha = 1;
      }
      super.update();
    }
    
    protected function followObject(obj:FlxPoint):void {
      var objectOffset:FlxPoint = new FlxPoint(obj.x + childOffset.x, obj.y + childOffset.y);
      
      var baseAccel:Number = 10;
      var directX:Number = objectOffset.x > x ? 1 : -1;
      var directY:Number = objectOffset.y > y ? 1 : -1;
      
      velocity.x += (Math.abs(objectOffset.x - x) + 10) * directX;
      velocity.y += (Math.abs(objectOffset.y - y) + 10) * directY;
    }
    
    public function onChildLearn(event:Event):void {
      x = child.x + childOffset.x;
      y = child.y + childOffset.y;
      active = true;
      visible = true;
      alpha = 1;
      setTimeout(function():void{
        dead = true;
      }, 1000);
    }
    
  }
}