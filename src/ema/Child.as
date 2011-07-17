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
	  
	  public var currentai:String;
	  
	  protected var mom:Mother;
	  protected var objectOfInterest:FlxPoint;
	  protected var skills:Object = {};
	  protected var maxRadius:FlxPoint;
	  protected var minRadius:FlxPoint;
	  protected var mode:String;
	  private var interestOffset:Number;
	  public var traits:Object;
	  
	  public function Child(X:Number, Y:Number, t:Object, c:uint) {
	    super(X,Y);


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


/*      useChildSprites();*/
      useAdultSprites();

      setCurrentAI("idle", false, true);
      
      mom.addEventListener("pickup", onMomPickup);
      mom.addEventListener("jump", onMomJump);
      mom.addEventListener("attack", onMomAttack);
    }
    
    private function useChildSprites():void {
      mode = "child";
      loadGraphic(manifest.BabyStrip, true, false, 80, 75);
      addAnimationFromSpriteBox(manifest.BabySpriteBox1);      
      addAnimationFromSpriteBox(manifest.BabySpriteBox2);

      addAnimationCallback(animTransitions);
      currentGraphic = manifest.BabyGraphic1;
      applyBoundingBox("idle");
    }
    
    private function useAdultSprites():void {
      mode = "adult";
      loadGraphic(manifest.MotherStrip, true, false, 160, 165);
      addAnimationFromSpriteBox(manifest.momSpriteBox1);      
      addAnimationFromSpriteBox(manifest.momSpriteBox2);

      addAnimationCallback(animTransitionsAdult);
      currentGraphic = manifest.MomGraphic1;
      applyBoundingBox("idle");
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
          playGraphic("jump", true, manifest.BabyGraphic1);
        } else if (name == "jump" || name == "attack" || name == "ungrabbed") {
          playGraphic("idle", false, manifest.BabyGraphic1);
        } else if(name == "grabbed") {
          playGraphic("bouncing", false, manifest.BabyGraphic1);
        }
      }
    }
    
    protected function animTransitionsAdult(name:String, frameNumber:uint, frameIndex:uint):void {
      if (dead) return;
      currentState = name;
      
      //one shot animation resets
      if (finished) {
        if (name == "idleWalk") {
          playGraphic("walk", false, manifest.MomGraphic1);
        } else if (name == "attack" || name == "jump") {
          playGraphic("idle", false, manifest.MomGraphic1);
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
    
    protected function playAnimAdult():void {
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
        case "followMom":
          if (!currentlyBusy()) {
            if (velocity.x == 0) {
              play("idle");
            } else {
              play("walk");
            }
            if(hasLearned("jump") && Math.random() < traits["jumpProbability"]) {
              play("jump", true);
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
              play("jump", true);
            } else if(hasLearned("attack") && Math.random() < 0.0005) {
              play("attack", true);
            } else if(Math.random() < 0.001) {
              setCurrentAI("followMom");
            }
          }
        break;
      }

      applyBoundingBox(currentState);
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
      if (mode == "adult") {
        playAnimAdult();
      } else {
        playAnim();
      }
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
      if (currentai != "shudder" && mode != "adult") {
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
        playGraphic("monsterDeath", true, mode == "adult"? manifest.MomGraphic1 : manifest.BabyGraphic2);
      }
    }
    
    public function onMomPickup(event:Event):void {
      if (!mom.hasChildInMouth() && mode != "adult") {
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