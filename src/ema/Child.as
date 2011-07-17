package ema {
	import org.flixel.*;
	import ema.utils.Log;
	import flash.utils.*;
	import flash.events.Event;
	
	public class Child extends GameSprite {
	  
    public var learnEvent:Event = new Event("learn");
	  public var aiBox:Object = {
	    "idle": {
	      "priority" : 0,
	      "anims": ["idle"]
	    },
	    "followMom": {
	      "priority" : 1,
	      "anims": ["idle", "walk", "jump", "attack"]
	    },
	    "curious": {
	      "priority" : 1,
	      "anims": ["idle", "walk", "jump"]
	    },
	    "pickedUpByMom": {
	      "priority" : 5,
	      "anims": ["grabbed", "ungrabbed", "held", "bouncing"]
	    },
	    "shudder": {
	      "priority" : 4,
	      "anims": ["shudder"]
	    },
	    "death": {
	      "priority": 5,
	      "anims": ["monsterDeath"]
	    }
	  };
	  
	  public var spriteBox1:Object = {
	    "idle": {
	      spriteArray: spriteArray(13,25),
        loop: true,
        boundingBox: [18, 48, 44, 27]
	    },
	    "walk": {
	      spriteArray: spriteArray(2,12),
        loop: true,
        boundingBox: [14, 45, 51, 30]
	    },
	    "readyJump": {
	      spriteArray: spriteArray(26,32),
        loop: false,
        boundingBox: [13, 45, 67, 30]
	    },
	    "jump": {
	      spriteArray: spriteArray(32,46),
        loop: false,
        boundingBox: [18, 0, 44, 75]
	    },
	    "attack": {
	      spriteArray: spriteArray(47,54),
        loop: false,
        boundingBox: [18, 27, 49, 48]
	    },
	    "grabbed": {
	      spriteArray: spriteArray(56, 60),
        loop: false,
        boundingBox: [18, 31, 44, 43]
	    },
	    "ungrabbed": {
	      spriteArray: [60,59,58,57,56],
        loop: false,
        boundingBox: [18, 31, 44, 43]
	    },
	    "bouncing": {
	      spriteArray: spriteArray(60,68),
	      framesPerSecond: 10,
        loop: true,
        boundingBox: [17, 28, 29, 40]
	    },
	    "held": {
	      spriteArray: [64],
	      framesPerSecond: 0,
        loop: false,
        boundingBox: [17, 28, 29, 40]
	    },
	    "shudder": {
	      spriteArray: [2, 3],
        loop: true,
        boundingBox: [18, 48, 44, 27]
	    }
	  };
	  
	  public var spriteBox2:Object = {
	    "monsterDeath": {
	      spriteArray: spriteArray(1,10),
	      framesPerSecond: 10,
        loop: false,
        boundingBox: [19,40,68,36]
	    }
    };
	  
/*    addAnimation("introSad", spriteArray(11,20), 24, false);
    addAnimation("sad", spriteArray(21,31), 24, true);
    addAnimation("outroSad", spriteArray(31, 42), 42, false);
    addAnimation("play", spriteArray(44,46), 24, true);
    addAnimation("swim", spriteArray(47,50), 24, true);
    addAnimation("ball", spriteArray(51,54), 24, false);*/
	  
	  public var currentai:String;
	  
	  protected var mom:Mother;
	  protected var objectOfInterest:FlxPoint;
	  protected var skills:Object = {};
	  protected var maxRadius:FlxPoint;
	  protected var minRadius:FlxPoint;
	  private var interestOffset:Number;
	  public var traits:Object;

	  [Embed(source="sprites/baby/babyStripPart1.png")] private var BabyStrip:Class
	  [Embed(source="sprites/baby/babyStripPart2.png")] private var BabyStrip2:Class
    public var Graphic1:Object = {
      embed: BabyStrip,
      width: 80,
      height: 75
    };
    
    public var Graphic2:Object = {
      embed: BabyStrip2,
      width: 86,
      height: 81
    };
	  
	  public function Child(X:Number, Y:Number, t:Object, c:uint) {
	    super(X,Y);
      loadGraphic(BabyStrip, true, false, 80, 75);
	    
	    maxVelocity.x = Math.random() * 20 + 100;			//walking speed
      acceleration.y = 400;			//gravity
      drag.x = maxVelocity.x*4;		//deceleration (sliding to a stop)
      mom = PlayState(FlxG.state).player;
      color = c;
      traits = t;
      maxHealth = 600;
      health = 600;
      maxRadius = traits["maxRadius"];  //point at which you run to catch up w/ mom
      minRadius = traits["minRadius"];

      addAnimationFromSpriteBox(spriteBox1);      
      addAnimationFromSpriteBox(spriteBox2);
      
      addAnimationCallback(animTransitions);
      currentGraphic = Graphic1;
      applyBoundingBox("idle");
      setCurrentAI("idle", false, true);
      
      mom.addEventListener("pickup", onMomPickup);
      mom.addEventListener("jump", onMomJump);
      mom.addEventListener("attack", onMomAttack);
    }
    
    public function isWithinLearningDistance():Boolean {
      return Math.abs(mom.x - x) < 400 && Math.random() < 0.4;
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
      return currentState == "jump" || currentState == "readyJump" || currentState == "attack";
    }
    
    protected function overlappingTree():Boolean {
      return FlxU.overlap(this, PlayState(FlxG.state).treePile, function(a:FlxObject, b:FlxObject):Boolean{
        objectOfInterest = b;
        interestOffset = b.width * Math.random();
        return true;
      });
    }
    
    protected function playAnim():void {
      if (!onScreen()) {
        setCurrentAI("shudder", true);
      }
      
      switch(currentai) {
        case "idle":
          play("idle");
          if (hasLearned("walk")) {
            if (Math.random() < traits["idleToFollowProbability"]) {
              setCurrentAI("followMom");
              interestOffset = mom.width * Math.random();
            }
          } else if (mom.currentState == "walk"){
            genericLearning("walk");
          }
        break;
        case "pickedUpByMom":
          if (mom.currentState == "walk" || mom.currentState == "run") {
            play("bouncing");
          } else {
            play("held", true);
          }
        break;
        case "followMom":
          if (!currentlyBusy()) {
            if (velocity.x == 0) {
              play("idle");
            } else {
              play("walk");
            }
            if(hasLearned("jump") && Math.random() < traits["jumpProbability"]) {
              play("readyJump", true);
            } else if(hasLearned("attack") && Math.random() < 0.0005) {
              play("attack", true);
            } else if(Math.random() < 0.001 && overlappingTree()) {
              setCurrentAI("curious");
            } else if (Math.random() < traits["followToIdleProbability"]) {
              setCurrentAI("idle");
            }
          }
        break;
        case "curious":
          if (!currentlyBusy()) {
            if (velocity.x == 0) {
              play("idle");
            } else {
              play("walk");
            }
            if(hasLearned("jump") && Math.random() < traits["jumpProbability"]) {
              play("readyJump", true);
            } else if(hasLearned("attack") && Math.random() < 0.0005) {
              play("attack", true);
            } else if(Math.random() < 0.001) {
              setCurrentAI("followMom");
            }
          }
        break;
        case "shudder":
          play("shudder");
        break;
      }
      
      applyBoundingBox(currentState);
    }
    
    override public function update():void {
      playAnim();
      acceleration.x = 0;
      
      switch(currentai) {
        case "idle":
          //nuthin
        break;
        case "pickedUpByMom":
          var mouthLocation:FlxPoint = mom.mouthLocation();
          if (facing == LEFT) {
            x = mouthLocation.x - 12;
          } else {
            x = mouthLocation.x - 30;
          }
          y = mouthLocation.y - 7;
        break;
        case "followMom":
          followObject(mom);
        break;
        case "curious":
          followObject(objectOfInterest);
        break;
        case "shudder":
          // stay where you are :(
        break;
        case "dead":
          //also nuthin
        break;
      }
      
      updateHealth();
      updateFacing();
      super.update();
      bounded();
    }
    
    protected function followObject(obj:FlxPoint):void {
      var objectX:Number = obj.x + interestOffset;
      var baseAccel:Number = drag.x*2;
      var direct:Number = objectX > x ? 1 : -1;
      var xFromMom:Number = Math.abs(objectX - x);
      var linearAccel:Number = xFromMom / maxRadius.x;
  
      //cap linear x acceleration at 1
      if (onFloor && currentState != "attack") {
        if(linearAccel > 1) {
          acceleration.x += baseAccel*direct;
        } else if (xFromMom < minRadius.x) {
          acceleration.x = 0; //todo this is superfluous
        } else {
          //exponential acceleration inbetween the maxRadius and the minRadius
          var expAccel:Number = Math.pow(linearAccel,4);
          acceleration.x += baseAccel*expAccel*direct;
        }
      }
    }
    
    public function onNearbyMonster():void {
      if (currentai != "shudder") {
        setCurrentAI("shudder", true);
      }
    }
    
    public function onNoMonster():void {
      if (currentai == "shudder"){
        setCurrentAI("idle");
      }
    }
    
    public function onMonsterOverlap():void {
      health -= 5;
      flicker(0.3);
      if (health <= 0) {
        dead = true;
        setCurrentAI("dead", false, true);
        playGraphic("monsterDeath", true, Graphic2);
      }
    }
    
    public function onMomPickup(event:Event):void {
      if (!mom.hasChildInMouth()) {
        var mouthLocation:FlxPoint = mom.mouthLocation();
      	
      	if (distance(mouthLocation) < 75) {
      	  mom.pickupChild(this);
      	  setCurrentAI("pickedUpByMom");
      	  if(!dead)
            play("held", true);
          
          //babys are weightless!
          acceleration.y = 0;
      	}
      }
    }
    
    public function drop():void {
      setCurrentAI("idle");
      if(!dead)
        play("ungrabbed", true);
      acceleration.y = 400;
    }
    
    public function hasLearned(skill:String):Boolean {
      return skills[skill] >= 4;
    }
    
    public function genericLearning(s:String):void {
      if (!hasLearned(s) && isWithinLearningDistance()) {
        if (!skills[s]) {
          skills[s] = 0;
        }

        //it takes time to learn!
        setTimeout(function():void{
          if (aiBox[currentai].priority < 3 && !hasLearned(s)) {
            skills[s] += 1;
            dispatchEvent(learnEvent);
            Log.out("I gained a learn point!"+ skills[s]);
          }
        }, (Math.random() * 200 + 100));
      }
    }
    
    public function setCurrentAI(ai:String, usePriority:Boolean = false, force:Boolean = false):void {
      if (force) {
        currentai = ai;
      } else if (currentai != "dead") {
        if (!usePriority || aiBox[currentai].priority <= aiBox[ai].priority) {
          currentai = ai
        }
      }
    }
    
    public function onMomJump(event:Event):void {
      genericLearning("jump");
    }
    
    public function onMomAttack(event:Event):void {
      genericLearning("attack");
    }
  }
}