package ema {
	import org.flixel.*;
	import ema.utils.Log;
	import flash.utils.*;
	import flash.events.Event;
	
	public class ExPoint extends FlxSprite {
 	  [Embed(source="sprites/point.png")] private var PointEmbed:Class
 	  
 	  protected var child:Child;
 	  
 	  public function ExPoint(c:Child) {
  	  super(c.x,c.y);
  	  child = c;
      visible = false;
      active = false;
      loadGraphic(PointEmbed, false, false);
      child.addEventListener("learn", onChildLearn);
  	  color = child.color;
    }
    
    override public function update():void {
      x = child.x + 10;
      y = child.y - height - 5;
      super.update();
    }
    
    public function onChildLearn(event:Event):void {
      active = true;
      visible = true;
      setTimeout(function():void{
        active = false;
        visible = false;
      }, 1000);
    }
    
  }
}