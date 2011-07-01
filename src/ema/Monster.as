package ema {
	import org.flixel.*;
	import ema.utils.Log;
	
	public class Monster extends GameSprite {
	  [Embed(source="sprites/monsters/monsterLStrip.png")] private var MonsterStrip:Class
	  
	  public static const SMALL:FlxPoint = new FlxPoint(0.3,0.3);
	  public static const MEDIUM:FlxPoint = new FlxPoint(0.6,0.6);
	  public static const LARGE:FlxPoint = new FlxPoint(1,1);
	  	  
	  public function Monster(X:Number, Y:Number, size:String) {
	    super(X,Y);
	    loadGraphic(MonsterStrip, true, false, 157, 178);
      addAnimation("wander", spriteArray(1, 35), 24, true);
      addAnimation("hungry", spriteArray(1, 35), 24, true);
      addAnimation("flee", spriteArray(1, 35), 24, true);
      maxVelocity.x = 70;
      
      switch(size) {
        case "small":
          scale = SMALL;
          width = frameWidth*0.3;
          height = frameHeight*0.3;
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
        break;
      }
      
      velocity.x = maxVelocity.x;
      
      //bounding box
/*      width = 130;
      height = 150;
      offset.x = 8;
      offset.y = 16;*/
    }
    
    protected function freeWill():void {
      //switch directions
      if (Math.random() < 0.001) {
        velocity.x = velocity.x * -1;
      }
    }
    
    override public function update():void {
      play('wander');
      freeWill();
      super.update();
    }
  }
}