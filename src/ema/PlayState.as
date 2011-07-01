package ema {
	import org.flixel.*;
	import ema.utils.Log;
 
	public class PlayState extends FlxState {
    [Embed(source="sprites/tilesOld.png")] private var ImgTiles:Class;
    [Embed(source="sprites/tiles.png")] private var TilesCover:Class;
    
    [Embed(source="sprites/hill1.png")] private var Hill1:Class;
    [Embed(source="sprites/hill2.png")] private var Hill2:Class;
    [Embed(source="sprites/hill3.png")] private var Hill3:Class;
    [Embed(source="sprites/hill4.png")] private var Hill4:Class;
    [Embed(source="sprites/grassG.png")] private var GrassTiles:Class;
    [Embed(source="sprites/bgG.png")] private var BGTiles:Class;
	  protected var player:Mother;
	  protected var secondChild:Child;
	  protected var onlyChild:Child;
	  protected var monster:Monster;
	  protected var t:FlxTileblock;
	  
	  protected var bg:FlxSprite;
	  protected var grass:FlxSprite;
	  
	  protected var debug:FlxSprite;
	  
		override public function create():void {
      FlxG.showBounds = true;

      //the ground
      t = new FlxTileblock(0, FlxG.height-20, FlxG.width*4, 24);
      t.loadGraphic(ImgTiles);

      var cover:FlxBackdrop = new FlxBackdrop(TilesCover, 1, 1, true, false);
      cover.y = FlxG.height - 30
      
      //the pretty ground
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
      player = new Mother(FlxG.width/2-6, FlxG.height-250);
      onlyChild = new Child(FlxG.width/2-50, FlxG.height-250, player, 0xCFFFEF); //MINT
      secondChild = new Child(FlxG.width/2+10, FlxG.height-250, player, 0xCFD0FF); //PERIWINKLE
      
      debug = player.mouthDebug;
      
      //monsters
      monster = new Monster(200,200, "small");
      
      //camera controls
      FlxG.follow(player);
      FlxG.followBounds(0, 0, FlxG.width*4, FlxG.height);
      
      add(bg);
      add(hill1);
      add(hill2);
      add(hill3);
      add(hill4);
      add(t);
      add(cover);
      add(player);
      add(onlyChild);
      add(secondChild);
      
      add(debug);
      
      add(monster);
		}
		
		override public function update():void {
      super.update();
      
      //collision detection
      FlxU.collide(player, t);
      FlxU.collide(onlyChild, t);
      FlxU.collide(secondChild, t);
      
      if (monster.exists && player.overlaps(monster) && player.currentState == "attack") {
        monster.scale = new FlxPoint(monster.scale.x * 0.5, monster.scale.x * 0.5);
        if (monster.scale.x < 0.01) {
          monster.kill();
          player.dispatchEvent(player.attackEvent);
        }
      }
		}
	}
	
}