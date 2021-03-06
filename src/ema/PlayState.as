package ema {
	import flash.utils.*;
	import org.flixel.*;
	import ema.utils.Log;
 
	public class PlayState extends FlxState {
    [Embed(source="sprites/tilesOld.png")] private var ImgTiles:Class;
    [Embed(source="sprites/tiles.png")] private var TilesCover:Class;
    
    [Embed(source="sprites/hill1.png")] private var Hill1:Class;
    [Embed(source="sprites/hill2.png")] private var Hill2:Class;
    [Embed(source="sprites/hill3.png")] private var Hill3:Class;
    [Embed(source="sprites/hill4.png")] private var Hill4:Class;
    
    [Embed(source="sprites/tree1.png")] private var Tree1:Class;
    [Embed(source="sprites/tree2.png")] private var Tree2:Class;
    [Embed(source="sprites/tree3.png")] private var Tree3:Class;
    [Embed(source="sprites/tree4.png")] private var Tree4:Class;
    [Embed(source="sprites/tree5.png")] private var Tree5:Class;
  
    [Embed(source="sprites/grassG.png")] private var GrassTiles:Class;
    [Embed(source="sprites/bgG.png")] private var BGTiles:Class;
    
    [Embed(source="sprites/cave.png")] private var Cave:Class;
    [Embed(source="sprites/nest.png")] private var Nest:Class;
    [Embed(source="sprites/title.png")] private var Title:Class;
    [Embed(source="sprites/arrowDown.png")] private var Arrow:Class;
    
	  public var player:Mother;
	  protected var secondChild:Child;
	  protected var onlyChild:Child;
	  public var childPile:FlxGroup;
	  public var monsterPile:FlxGroup;
	  public var treePile:FlxGroup;
	  protected var t:FlxTileblock;
	  
	  protected var bg:FlxSprite;
	  protected var grass:FlxSprite;
	  
	  protected var debug:FlxSprite;
	  
		override public function create():void {
      FlxG.showBounds = true;

      //the invisi ground
      t = new FlxTileblock(0, FlxG.height-40, FlxG.width*4, 24);
      t.loadGraphic(ImgTiles);
      
      //the rolling hills ground
      var hill1:FlxSprite = new FlxSprite(0,  FlxG.height - 118, Hill1);
      hill1.scrollFactor = new FlxPoint(0.7,0.7);
      var hill2:FlxSprite = new FlxSprite(800, FlxG.height - 195, Hill2);
      hill2.scrollFactor = new FlxPoint(0.7,0.7);
      var hill3:FlxSprite = new FlxSprite(1600, FlxG.height - 243, Hill3);
      hill3.scrollFactor = new FlxPoint(0.7,0.7);
      var hill4:FlxSprite = new FlxSprite(2400, FlxG.height - 320, Hill4);
      hill4.scrollFactor = new FlxPoint(0.7,0.7);
            
      //the bg
      bg = new FlxSprite(0,0, BGTiles);
      //parallax magic!
      bg.scrollFactor = new FlxPoint(0,0);
      
      //actors
      player = new Mother(275, FlxG.height-250);
      onlyChild = new Child(FlxG.width/2-50, FlxG.height-250, {
        "minRadius": new FlxPoint(25, 0),
        "maxRadius": new FlxPoint(75, 100),
        "maxVelocityX": 100,
        "monsterTolerance": 250,
        "jumpProbability": 0.001,
        "idleToFollowProbability": 0.05,
        "followToIdleProbability": 0.001
      }, 0xCFFFEF); //MINT
      secondChild = new Child(FlxG.width/2+10, FlxG.height-250, {
        "minRadius": new FlxPoint(0, 0),
        "maxRadius": new FlxPoint(25, 100),
        "maxVelocityX": 130,
        "monsterTolerance": 180,
        "jumpProbability":0.005,
        "idleToFollowProbability": 0.05,
        "followToIdleProbability": 0.0005
      }, 0xCFD0FF); //PERIWINKLE
      childPile = new FlxGroup();
      childPile.add(onlyChild);
      childPile.add(secondChild);
      
      //title page
      var cave:FlxBackdrop = new FlxBackdrop(Cave, 1, 1, false, false);
      var nest:FlxBackdrop = new FlxBackdrop(Nest, 1, 1, false, false);
      var title:FlxBackdrop = new FlxBackdrop(Title, 1, 1, false, false);
      title.x = 450;
      title.y = 50;
      nest.x = 30;
      nest.y = 330;

      var arrowDown:FlxSprite = new FlxSprite(58, 245, Arrow);
      arrowDown.alpha = 0.5;
      var arrowLeft:FlxSprite = new FlxSprite(500, 200, Arrow);
      arrowLeft.alpha = 0.8;
      arrowLeft.angle = 90;
      var arrowRight:FlxSprite = new FlxSprite(650, 200, Arrow);
      arrowRight.alpha = 0.8;
      arrowRight.angle = 270;
      
      debug = player.mouthDebug;
      
      //monsters
      monsterPile = monsterSpawner();
      
      //camera controls
      FlxG.follow(player);
      FlxG.followBounds(0, 0, FlxG.width*4, FlxG.height);
      
      add(bg);
      add(hill1);
      add(hill2);
      add(hill3);
      add(hill4);
      
      add(cave);
      add(treeSpawner(320));
      
      add(t);
      add(player);
      add(childPile);
      add(nest);
      add(arrowDown);
      add(arrowLeft);
      add(arrowRight);
      
      add(debug);
      
      add(monsterPile);
      add(treeSpawner(360));
      add(title);
      add(new ExPoint(onlyChild));
      add(new ExPoint(secondChild));
		}
		
		public function treeSpawner(starterHeight:Number):FlxGroup {
		 treePile = new FlxGroup();
		 
		 var treeColors:Array = [0xcfe0ff, 0xcff0ff, 0xcffffe, 0xcfffee, 0xcfffde, 0xd0ffcf, 0xe0ffcf, 
		 0xf0ffcf, 0xfffecf, 0xffeecf, 0xffdecf, 0xffcfd0,
     0xffcfe0, 0xffcff0, 0xfecfff, 0xeecfff, 0xdecfff];
		 
		 for (var i:Number = 0; i < 5; i++) {
		   var embed:Class;
		   var num:Number = Math.floor(Math.random() * 5);
       switch(num) {
         case 0: embed = Tree1;
         break;
         case 1: embed = Tree2;
         break;
         case 2: embed = Tree3;
         break;
         case 3: embed = Tree4;
         break;
         case 4: embed = Tree5;
         break;
       }
       var tree:FlxSprite = new FlxSprite(Math.random() * 2000 + 600, Math.random() * 40 + starterHeight, embed);
       tree.y -= tree.height;
       tree.scrollFactor = new FlxPoint(0.7,0.7);
       
       //50% chance of flippage
       if (Math.random() < 0.5) {
         tree.scale = new FlxPoint(-1,1);
       }
       
       tree.color = treeColors[Math.floor(Math.random() * treeColors.length)];
       
       treePile.add(tree);
		 }
		 
		 return treePile;
		}
		
		public function monsterSpawner():FlxGroup {
		  var monsterPile:FlxGroup = new FlxGroup();
		  
		  setInterval(function():void{
		    var size:String;

        var i:Number = Math.round(Math.random() * 5);
        switch(i % 5) {
          case 0: size = "xsmall";
          break;
          case 1: size = "small";
          break;
          case 2: size = "medium";
          break;
          case 3: size = "large";
          break;
          case 4: size = "xlarge";
          break;
        }
        monsterPile.add(new Monster(Math.random() * 800, Math.random() * 400, size));
		  }, 5000);
      
      return monsterPile;
		}
		
		override public function update():void {
      super.update();
      
      //collision detection
      FlxU.collide(player, t);
      FlxU.collide(onlyChild, t);
      FlxU.collide(secondChild, t);
      
      updateMonsterOverlap();
      
      var monsterFound1:Boolean = false;
      var monsterFound2:Boolean = false;
      for each (var monster:Monster in monsterPile.members) {
        if (monsterFound1 && monsterFound2) {
          break;
        }
        
        if (monster.exists && monster.onScreen()) {
          if (onlyChild.distance(monster) < onlyChild.traits["monsterTolerance"]) {
            monsterFound1 = true;
            if (onlyChild.currentai != "shudder") {
              onlyChild.onNearbyMonster();
            }
          }
          
          if (onlyChild.distance(monster) < onlyChild.traits["monsterTolerance"]) {
            monsterFound2 = true;
            if (secondChild.currentai != "shudder") {
              secondChild.onNearbyMonster();            
            }
          }
        }
      }
      
      if (!monsterFound1) {
        onlyChild.onNoMonster();
      }
      if (!monsterFound2) {
        secondChild.onNoMonster();
      }
      
      if (!player.dead) {
        for each (var monster3:Monster in monsterPile.members) {
          if (monster3.exists && monster3.onScreen() && player.overlaps(monster3)) {
            if (player.currentState == "attack") {
              monster3.decreaseSize();
              if (monster3.dead) {
                player.dispatchEvent(player.attackEvent);
              }
            } else {
              player.onMonsterOverlap();
            }
            break;
          }
        }
      }
      
      for each (var monster2:Monster in monsterPile.members) {
        if (monster2.exists && monster2.onScreen()) {
          if(onlyChild.currentai != "dead" && onlyChild.overlaps(monster2)){
            onlyChild.onMonsterOverlap();
          }
          if(secondChild.currentai != "dead" && secondChild.overlaps(monster2)){
            secondChild.onMonsterOverlap();
          }
        }
      }
		}
		
		public function updateMonsterOverlap():void {
      for each (var monster:Monster in monsterPile.members) {
        if (monster.exists && monster.onScreen()) {
          for each (var other:Monster in monsterPile.members) {
            if (monster != other && other.exists && other.onScreen() && monster.overlaps(other)) {
              other.decreaseSize();
              monster.decreaseSize();
            }
          }
        }
      }   
		}
	}
	
}