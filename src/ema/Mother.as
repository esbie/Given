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
    }
    
    override public function update():void {

      acceleration.x = 0;
      
      if(FlxG.keys.LEFT) {
        play("walk");
        acceleration.x -= drag.x*2;
      }
      
      if(FlxG.keys.RIGHT) {
        play("walk");
        acceleration.x += drag.x*2;
      }
      
      //jump
      if(onFloor) {
        if(FlxG.keys.justPressed("SPACE")) {
          play("jump");
          velocity.y = -acceleration.y*0.40;
        }
      }
      
      if (velocity.x == 0) {
        play("idle");
      }
      
      if (velocity.x > 0) {
        scale = new FlxPoint(-1,1);
      } else if (velocity.x < 0){
        scale = new FlxPoint(1,1);
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