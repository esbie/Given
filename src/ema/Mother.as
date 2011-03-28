package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class Mother extends FlxSprite {
	  public function Mother(X:Number, Y:Number) {
	    super(X,Y,null);
	    
	    maxVelocity.x = 100;			//walking speed
      acceleration.y = 400;			//gravity
      drag.x = maxVelocity.x*4;		//deceleration (sliding to a stop)
	    
	  }
	  
	  override public function update():void {
	    
      acceleration.x = 0;
      
      if(FlxG.keys.LEFT) {
        acceleration.x -= drag.x*2;
      }
      
      if(FlxG.keys.RIGHT) {
        acceleration.x += drag.x*2;
      }
      
      if(onFloor) {
				if(FlxG.keys.justPressed("SPACE")) {
					velocity.y = -acceleration.y*0.51;
				}
			}
      
	    super.update();
	    
	    if(x > FlxG.width-width-4) {
	      x = FlxG.width-width-4;
	    } else if(x < 4) {
        x = 4;
      }
      				
	  }
	}
}