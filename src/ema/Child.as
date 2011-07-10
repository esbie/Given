package ema {
	import org.flixel.*;
	import ema.utils.Log;
	import flash.utils.*;
	import flash.events.Event;
	
	public class Child extends GameSprite {
	  
    public var learnEvent:Event = new Event("learn");
	  public var aiBox:Object = {
	    "followMom": {
	      "priority" : 1,
	      "anims": ["idle", "walk", "jump", "attack"]
	    },
	    "pickedUpByMom": {
	      "priority" : 5,
	      "anims": ["grabbed", "ungrabbed", "held", "bouncing"]
	    },
	    "shudder": {
	      "priority" : 4,
	      "anims": ["shudder"]
	    }
	  };
	  
	  public var currentai:String = "pickedUpByMom";
	  
	  protected var mom:Mother;
	  protected var skills:Object = {};
	  protected var maxRadius:FlxPoint;
	  protected var minRadius:FlxPoint;
	  [Embed(source="sprites/baby/babyStripg.png")] private var BabyStrip:Class
	  
	  public function Child(X:Number, Y:Number, mother:Mother, c:uint) {
	    super(X,Y);
	    loadGraphic(BabyStrip, true, false, 80, 75);
	    
	    maxVelocity.x = Math.random() * 20 + 100;			//walking speed
      acceleration.y = 400;			//gravity
      drag.x = maxVelocity.x*4;		//deceleration (sliding to a stop)
      mom = mother;
      color = c;
      maxRadius = new FlxPoint(75, 100);  //point at which you run to catch up w/ mom
      minRadius = new FlxPoint(10, 0);

      addAnimation("idle", spriteArray(13, 25), 24, true);
      addAnimation("walk", spriteArray(2,12), 24, true);
      addAnimation("readyJump", spriteArray(26,32), 24, false)
      addAnimation("jump", spriteArray(32,46), 24, false);
      addAnimation("attack", spriteArray(47,54), 24, false);
      addAnimation("grabbed", spriteArray(56,60), 24, false);
      addAnimation("ungrabbed", [60,59,58,57,56], 24, false);
      addAnimation("bouncing", spriteArray(60,68), 10, true);
      addAnimation("held", [64]);
      addAnimation("shudder", [2]);
      addAnimationCallback(animTransitions);
      
      addBoundingBox("idle", 18, 48, 44, 27);
      addBoundingBox("walk", 14, 45, 51, 30);
      addBoundingBox("readyJump", 13, 45, 67, 30);
      addBoundingBox("jump", 18, 0, 44, 75);
      addBoundingBox("attack", 18, 27, 49, 48);
      addBoundingBox("grabbed", 18, 31, 44, 43);
      addBoundingBox("ungrabbed", 18, 31, 44, 43);
      addBoundingBox("bouncing", 17, 28, 29, 40);
      addBoundingBox("held", 17, 28, 29, 40);
      addBoundingBox("shudder", 18, 48, 44, 27);
      
      applyBoundingBox("idle");
      
      mom.addEventListener("pickup", onMomPickup);
      mom.addEventListener("jump", onMomJump);
      mom.addEventListener("attack", onMomAttack);
      
      currentai = "followMom";
    }
    
    public function isWithinLearningDistance():Boolean {
      return Math.abs(mom.x - x) < 400;
    }
    
    protected function animTransitions(name:String, frameNumber:uint, frameIndex:uint):void {
      currentState = name;
      
      if (finished) {
        //some roundabout logic to delay the baby jumps
        if (name == "readyJump") {
          velocity.y = -acceleration.y*0.35;
          play("jump", true);
        } else if (name == "jump" || name == "attack" || name == "ungrabbed") {
          play("idle");
        } else if(name == "grabbed") {
          play("bouncing");
        }
      }
    }
    
    protected function currentlyBusy():Boolean {
      return currentai == "pickedUpByMom" || currentState == "jump" || currentState == "readyJump" || currentState == "attack";
    }
    
    protected function playAnim():void {
      if (currentai == "pickedUpByMom") {
        if (mom.currentState == "walk") {
          play("bouncing");
        } else {
          play("held", true);
        }
      } else {
        if (!currentlyBusy()) {
          if (velocity.x == 0) {
            play("idle");
          } else {
            play("walk");
          }
          if(hasLearned("jump") && Math.random() < 0.005) {
            play("readyJump", true);
          } else if(mom.currentState == "attack" && Math.random() < 0.03) {
            play("attack", true);
          }
        }
      }
      applyBoundingBox(currentState);
    }
    
    override public function update():void {
      playAnim();
      
      acceleration.x = 0;
      
      if (currentai == "pickedUpByMom") {
        var mouthLocation:FlxPoint = mom.mouthLocation();
        if (facing == LEFT) {
          x = mouthLocation.x - 12;
        } else {
          x = mouthLocation.x - 30;
        }
        y = mouthLocation.y - 7;
      } else {
        var baseAccel:Number = drag.x*2;
        var direct:Number = mom.x > x ? 1 : -1;
        var xFromMom:Number = Math.abs(mom.x - x);
        var linearAccel:Number = xFromMom / maxRadius.x;
      
        //cap linear x acceleration at 1
        if (onFloor && currentState != "attack") {
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
        
        var nearestMonster:FlxSprite = findClosestSprite(FlxG.state().monsterPile);
        if (distance(nearestMonster) < 400) {
          Log.out("shuddering");
          currentai = "shudder";
          play("shudder");
        }
        
      }
      
      updateFacing();
      super.update();
      bounded();
    }
    
    public function onMomPickup(event:Event):void {
      if (!mom.hasChildInMouth()) {
        var mouthLocation:FlxPoint = mom.mouthLocation();
      	
      	if (distance(mouthLocation) < 75) {
      	  mom.pickupChild(this);
      	  currentai = "pickedUpByMom";
          play("held", true);
          
          //babys are weightless!
          acceleration.y = 0;
      	}
      }
    }
    
    public function drop():void {
      currentai = "followMom";
      play("ungrabbed", true);
      
      acceleration.y = 400;
    }
    
    public function hasLearned(skill:String):Boolean {
      return skills[skill] == 4;
    }
    
    public function genericLearning(s:String, anim:String, animRestart:Boolean=false):void {
      if (isWithinLearningDistance()) {
        if (!hasLearned(s)) {
          if (!skills[s]) {
            skills[s] = 0;
          }

          //it takes time to learn!
          setTimeout(function():void{
            if (!currentlyBusy()) {
              skills[s] += 1;;
              dispatchEvent(learnEvent);
              Log.out("I gained a learn point!"+ skills[s]);
            }
          }, (Math.random() * 200 + 100));
        }
      }
    }
    
    public function onMomJump(event:Event):void {
      genericLearning("jump", "readyJump", true);
    }
    
    public function onMomAttack(event:Event):void {
      genericLearning("attack", "attack");
    }
  }
}