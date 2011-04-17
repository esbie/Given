package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class Mother extends FlxSprite {
	  [Embed(source="sprites/mother/motherStrip.png")] private var MotherStrip:Class
	  
	  public function Mother(X:Number, Y:Number) {
	    super(X,Y,null);
	    loadGraphic(MotherStrip, true, false, 160, 165);
	    maxVelocity.x = 100;			//walking speed
      acceleration.y = 400;			//gravity
      drag.x = maxVelocity.x*4;		//deceleration (sliding to a stop)
      addAnimation("idle", [1]);
	  }
	  
	  override public function update():void {
	    play("idle");
      acceleration.x = 0;
      
      if(FlxG.keys.LEFT) {
        acceleration.x -= drag.x*2;
      }
      
      if(FlxG.keys.RIGHT) {
        acceleration.x += drag.x*2;
      }
      
      //jump
      if(onFloor) {
				if(FlxG.keys.justPressed("SPACE")) {
					velocity.y = -acceleration.y*0.40;
				}
			}
      
	    super.update();
	    
	    //bounds
	    if(x > FlxG.width*2-width-4) {
	      x = FlxG.width*2-width-4;
	    } else if(x < 4) {
        x = 4;
      }
      				
	  }
	}
}