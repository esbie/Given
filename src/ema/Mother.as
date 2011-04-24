package ema {
  import org.flixel.*;
  import ema.utils.Log;
  
  public class Mother extends GameSprite {
    [Embed(source="sprites/mother/motherStrip.png")] private var MotherStrip:Class
    
    public function Mother(X:Number, Y:Number) {
      super(X,Y);
      loadGraphic(MotherStrip, true, false, 160, 165);
      maxVelocity.x = 100;      //walking speed
      acceleration.y = 400;     //gravity
      drag.x = maxVelocity.x*4;   //deceleration (sliding to a stop)
      addAnimation("idle", spriteArray(27,47), 24, true);
      addAnimation("idleWalk", spriteArray(69,72), 24, false);
      addAnimation("walk", spriteArray(2,21), 24, true);
      addAnimation("walkRun", spriteArray(22,26), 24, false);
      addAnimation("walkAttack", spriteArray(94,98), 24, false);
      addAnimation("run", spriteArray(99,118), 24, true);
      addAnimation("attack", spriteArray(120,141), 24, false);
      addAnimation("jump", spriteArray(47,68), 24, false);
      addAnimation("pickup", spriteArray(142,150), 24, false);
      addAnimationCallback(animTransitions);
      
      //getting the bounding box perfect
      width = 127;
      height = 72;
      offset.x = 5;
      offset.y = 70;
    }
    
    protected function animTransitions(name:String, frameNumber:uint, frameIndex:uint):void {
      currentState = name;
      if (name == "idleWalk" && frameNumber == 2) {
        play("walk");
      }
    }
    
    protected function playAnim():void {
      if (onFloor) {
        if (FlxG.keys.LEFT || FlxG.keys.RIGHT) {
          if (currentState == "idle") {
            play("idleWalk", true);
          } else if (currentState == "jump") {
            play("walk");
          }
        } 
        if (FlxG.keys.justPressed("SPACE")) {
          play("jump", true);
        } else if (velocity.x == 0){
          play("idle");
        }
      }
    }
    
    override public function update():void {
      acceleration.x = 0;
      
      playAnim();
      
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

      updateFacing();  
      super.update();
    }
  }
}