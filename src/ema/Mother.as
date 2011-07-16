package ema {
  import org.flixel.*;
  import ema.utils.Log;
  import flash.events.*;

  public class Mother extends GameSprite {
    public var spriteBox2:Object = {
      "play": {
        spriteArray: spriteArray(2,16),
        loop: true,
        boundingBox: [4, 77, 126, 74]
      },
      "monsterDeath": {
        spriteArray: spriteArray(19,34),
        framesPerSecond: 15,
        loop: false,
        boundingBox: [4, 0, 257, 157]
      },
      "agedWalk": {
        spriteArray: spriteArray(37,56),
        loop: true,
        boundingBox: [4, 77, 126, 74]
      },
      "veryAgedWalk": {
        spriteArray: spriteArray(58,77),
        loop: true,
        boundingBox: [6, 79, 125, 71]
      },
      "death": {
        spriteArray: spriteArray(78,91),
        loop: false,
        boundingBox: [6, 83, 139, 68]
      },
      "newJump": {
        spriteArray: spriteArray(92,111),
        loop: false,
        boundingBox: [3, 38, 139, 110]
      }
    };
    
    [Embed(source="sprites/mother/motherStripPart1.png")] private var MotherStrip:Class
    [Embed(source="sprites/mother/motherStripPart2.png")] private var MotherStrip2:Class
    public var Graphic1:Object = {
      embed: MotherStrip,
      width: 160,
      height: 165
    };
    public var Graphic2:Object = {
      embed: MotherStrip2,
      width: 262,
      height: 168
    };
    
    
    public var pickupEvent:Event = new Event("pickup");
    public var jumpEvent:Event = new Event("jump");
    public var attackEvent:Event = new Event("attack");
  
    protected var childInMouth:Child;
    public var mouthDebug:FlxSprite; 
    
    public function Mother(X:Number, Y:Number) {
      super(X,Y);
      
      loadGraphic(MotherStrip, true, false, 160, 165);
      maxVelocity.x = 120;      //walking speed
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
      
      currentGraphic = Graphic1;
      
      addAnimationFromSpriteBox(spriteBox2);
      addAnimationCallback(animTransitions);
      
      //getting the bounding box perfect
      width = 127;
      height = 72;
      offset.x = 5;
      offset.y = 70;
      
      mouthDebug = new FlxSprite(X, Y);
      mouthDebug.createGraphic(4,4,0x000000);
    }
    
    protected function animTransitions(name:String, frameNumber:uint, frameIndex:uint):void {
      if (dead) return;
      currentState = name;
      
      //one shot animation resets
      if (finished) {
        if (name == "idleWalk") {
          playGraphic("walk", false, Graphic1);
        } else if (name == "attack" || name == "pickup") {
          playGraphic("idle", false, Graphic1);
        }
      }
    }
    
    protected function playAnim():void {      
      if (dead) return;
      if (onFloor) {
        if (FlxG.keys.LEFT || FlxG.keys.RIGHT) {
          if (currentState == "idle") {
            playGraphic("idleWalk", true, Graphic1);
          } else if (currentState == "jump") {
            playGraphic("walk", false, Graphic1);
          }
        } 
        if (FlxG.keys.justPressed("UP") && !hasChildInMouth()) {
          playGraphic("jump", true, Graphic1);
          dispatchEvent(jumpEvent);
        } else if (FlxG.keys.justPressed("SPACE") && !hasChildInMouth()) {
          playGraphic("attack", true, Graphic1);
        } else if (FlxG.keys.justPressed("DOWN")) {
          playGraphic("pickup", true, Graphic1);
          if (!hasChildInMouth()) {
            dispatchEvent(pickupEvent);
          } else {
            childInMouth.drop();
            childInMouth = null;
          }
        } else if (velocity.x == 0 && currentState != "attack" && currentState != "pickup"){
          playGraphic("idle", false, Graphic1);
        }
      }
    }
    
    override public function update():void {
      acceleration.x = 0;
      if (!dead){
        playAnim();
      
        if(currentState != "attack" && currentState != "pickup") {
          if(FlxG.keys.LEFT) {
            acceleration.x -= drag.x*2;
          }
      
          if(FlxG.keys.RIGHT) {
            acceleration.x += drag.x*2;
          }
        }
      
        //jump
        if(onFloor) {
          if(FlxG.keys.justPressed("UP") && !hasChildInMouth()) {
            velocity.y = -acceleration.y*0.40;
          }
        }
      }

      updateFacing();
      super.update();
      bounded();
    }
    
    public function pickupChild(child:Child):void {
      childInMouth = child;
    }
    
    public function hasChildInMouth():Boolean {
      return !!childInMouth;
    }
    
    public function mouthLocation():FlxPoint {
      var facingOffset:Number = scale.x == -1 ? width - offset.x + 2 : offset.x + 17;
      
      var anim:Array = [0,1,1,2,2,3,3,2,2,1,1,0,1,1,2,2,3,3,2,2,1];
      
      var mouthX:Number = x + facingOffset;
      var mouthY:Number = y + 35;
      
      if(currentState == "walk") {
        mouthY = mouthY - anim[_caf];
      }
      
      mouthDebug.x = mouthX;
      mouthDebug.y = mouthY;
      
      return new FlxPoint(mouthX, mouthY);
    }
    
    public function onMonsterOverlap():void {
      if (dead) return;
      dead = true;
      playGraphic("monsterDeath", true, Graphic2);
    }
  }
}