package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class Monster extends GameSprite {
	  [Embed(source="sprites/monsters/monsterLStrip.png")] private var MonsterStrip:Class
	  
	  public static const XSMALL:FlxPoint = new FlxPoint(0.2, 0.2);
	  public static const SMALL:FlxPoint = new FlxPoint(0.4,0.4);
	  public static const MEDIUM:FlxPoint = new FlxPoint(0.6,0.6);
	  public static const LARGE:FlxPoint = new FlxPoint(0.8,0.8);
	  public static const XLARGE:FlxPoint = new FlxPoint(1,1);
	  public static const GIANT:FlxPoint = new FlxPoint(1,1);
	  
	  public var size:String;
	  
	  private var attackStart:FlxPoint;
	  	  
	  public function Monster(X:Number, Y:Number, s:String) {
	    super(X,Y);
	    updateSize(s);
	    
	    loadGraphic(MonsterStrip, true, false, 157, 178);
      addAnimation("wander", spriteArray(1, 35), 24, true);
      addAnimation("hungry", spriteArray(1, 35), 24, true);
      addAnimation("flee", spriteArray(1, 35), 24, true);
      addAnimationCallback(animTransitions);
      maxVelocity.x = 100;
      
      velocity.x = maxVelocity.x;
      
      play("wander");
      //bounding box
/*      width = 130;
      height = 150;
      offset.x = 8;
      offset.y = 16;*/
    }
    
    protected function updateSize(s:String):void {
	    size = s;
      	    
      switch(s) {
        case "xsmall":
          scale = SMALL;
          width = frameWidth*0.2;
          height = frameHeight*0.2;
          maxVelocity.x -= 20;
        break;
        case "small":
          scale = SMALL;
          width = frameWidth*0.4;
          height = frameHeight*0.4;
          maxVelocity.x -= 20;
        break;
        case "medium":
          scale = MEDIUM;
          width = frameWidth*0.6;
          height = frameHeight*0.6;
          maxVelocity.x -=10;
        break;
        case "large":
        scale = LARGE;
        width = frameWidth*0.8;
        height = frameHeight*0.8;
        maxVelocity.x -=10;
        break;
        case "xlarge":
          scale = LARGE;
        break;
      }
      updateFacing();
    }
    
    public function decreaseSize():void {
      var newSize:String;
      
      switch(size) {
        case "xsmall":
          kill();
          return;
        break;
        case "small":
          newSize = "xsmall";
        break;
        case "medium":
          newSize = "small";
        break;
        case "large":
          newSize = "medium";
        break;
        case "xlarge":
          newSize = "large";
        break;
      }
      
      updateSize(newSize);
    }
    
    protected function animTransitions(name:String, frameNumber:uint, frameIndex:uint):void {
      currentState = name;
    }
    
    protected function freeWill():void {
      var food:FlxSprite = findClosestFood();
      
      //switch directions
      if (currentState == "wander" && Math.random() < 0.001) {
        velocity.x = velocity.x * -1;
      } else if (currentState == "wander" && distance(food) < 300 && Math.random() < 0.05) {
        attackStart = new FlxPoint(x, y);
        Log.out("Im hungry!")
        play("hungry");
        if (food.x - x > 0) {
          velocity.x = velocity.x;
        } else {
          velocity.x = velocity.x * -1;
        }
      } else if (currentState == "hungry" && distance(food) > 400) {
        Log.out("got bored");
        play("wander");
      }
    }
    
    protected function findClosestChild():Child {
      var minDist:Number = 18000;
      var minChild:Child;
      for each (var child:Child in PlayState(FlxG.state).childPile.members) {
        var dist:Number = distance(child);
        if (dist < minDist) {
          minDist = dist;
          minChild = child;
        }
      }
      return minChild;
    }
    
    protected function findClosestFood():FlxSprite {
      var minDist:Number = 18000;
      var minMonster:Monster;
      for each (var monster:Monster in PlayState(FlxG.state).monsterPile.members) {
        if (monster.exists && monster.width < width) {
          var dist:Number = distance(monster);
          if (dist < minDist) {
            minDist = dist;
            minMonster = monster;
          }
        }
      }
      
      var minChild:Child = findClosestChild();
      return minChild ? minChild : minMonster;
    }
    
    override public function update():void {
      if (!onScreen()) {
        kill();
      }
      
      freeWill();
      if (currentState == "hungry") {
        y = attackStart.y + Math.sin(Math.abs(attackStart.x - x)/80)*100;
      }
      updateFacing();
      super.update();
    }
  }
}