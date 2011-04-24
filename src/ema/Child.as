package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class Child extends GameSprite {
	  protected var mom:Mother;
	  protected var skills:Object = {};
	  protected var maxRadius:FlxPoint;
	  protected var minRadius:FlxPoint;
	  [Embed(source="sprites/baby/babyStripg.png")] private var BabyStrip:Class
	  
	  public function Child(X:Number, Y:Number, mother:Mother, c:uint) {
	    super(X,Y);
	    loadGraphic(BabyStrip, true, false, 80, 75);
	    
	    maxVelocity.x = Math.random() * 20 + 80;			//walking speed
      acceleration.y = 400;			//gravity
      drag.x = maxVelocity.x*4;		//deceleration (sliding to a stop)
      mom = mother;
      color = c;
      maxRadius = new FlxPoint(75, 100);  //point at which you run to catch up w/ mom
      minRadius = new FlxPoint(10, 0);

      //800x400
      addAnimation("idle", spriteArray(13, 25), 24, true);
      addAnimation("walk", spriteArray(2,12), 24, true);
      addAnimation("readyJump", spriteArray(26,32), 24, false)
      addAnimation("jump", spriteArray(32,46), 24, false);
      addAnimation("attack", spriteArray(47,54), 24, false);
      addAnimation("grabbed", spriteArray(56,60), 24, false);
      addAnimation("ungrabbed", [60,59,58,57,56], 24, false);
      addAnimationCallback(animTransitions);
      
      //getting the bounding box perfect
      width = 44;
      height = 27;
      offset.x = 18;
      offset.y = 48;
    }
    
    protected function animTransitions(name:String, frameNumber:uint, frameIndex:uint):void {
      currentState = name;
      
      //some roundabout logic to delay the baby jumps
      if (name == "readyJump" && frameNumber == 5) {
        velocity.y = -acceleration.y*0.35;
        play("jump", true);
      } else if (name == "jump" && frameNumber == 13) {
        play("idle");
      }
    }
    
    protected function playAnim():void {
      if (currentState != "jump" && currentState != "readyJump") {
        if (velocity.x == 0) {
          play("idle");
        } else {
          play("walk");
        }
        if(mom.currentState == "jump" && Math.random() < 0.05) {
          play("readyJump", true);
        } 
      }
    }
    
    override public function update():void {
      playAnim();
      
      acceleration.x = 0;
      var baseAccel:Number = drag.x*2;
      var direct:Number = mom.x > x ? 1 : -1;
      var xFromMom:Number = Math.abs(mom.x - x);
      var linearAccel:Number = xFromMom / maxRadius.x;
      
      //cap linear x acceleration at 1
      if (onFloor) {
        if(linearAccel > 1) {
          acceleration.x += baseAccel*direct;
        } else if (xFromMom < minRadius.x) {
          acceleration.x = 0; //todo this is superfluous
        }else {
          //exponential acceleration inbetween the maxRadius and the minRadius
          var expAccel:Number = Math.pow(linearAccel,4);
          acceleration.x += baseAccel*expAccel*direct;
        }
      }
      
      updateFacing();
      super.update();
    }
  }
}