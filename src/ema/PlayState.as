package ema {
	import org.flixel.*;
	import ema.utils.Log;
 
	public class PlayState extends FlxState {
    [Embed(source="sprites/tiles.png")] private var ImgTiles:Class;
    [Embed(source="sprites/grassG.png")] private var GrassTiles:Class;
    [Embed(source="sprites/bgG.png")] private var BGTiles:Class;
	  protected var player:Mother;
	  protected var secondChild:Child;
	  protected var onlyChild:Child;
	  protected var t:FlxTileblock;
	  
	  protected var bg:FlxSprite;
	  protected var grass:FlxSprite;
	  
		override public function create():void {
      FlxG.showBounds = true;

      //the ground
      t = new FlxTileblock(0, FlxG.height-24, FlxG.width*2, 24);
      t.loadGraphic(ImgTiles);
      
      //the grass
      grass = new FlxSprite(0,200, GrassTiles);

      //the bg
      bg = new FlxSprite(0,0, BGTiles);
      //parallax magic!
      bg.scrollFactor = new FlxPoint(0.2 ,0.2);
      
      //actors
      player = new Mother(FlxG.width/2-6, FlxG.height-250);
      onlyChild = new Child(FlxG.width/2-50, FlxG.height-250, player, 0xCFFFEF); //MINT
      secondChild = new Child(FlxG.width/2+10, FlxG.height-250, player, 0xCFD0FF); //PERIWINKLE
      
      //monsters
      var monster:Monster = new Monster(200,200);
      
      //camera controls
      FlxG.follow(player);
      FlxG.followBounds(0, 0, FlxG.width*2, FlxG.height);
      
      add(bg);
      add(grass);
      add(t);
      add(player);
      add(onlyChild);
      add(secondChild);
      
      add(monster);
		}
		
		override public function update():void {
      super.update();
      
      //collision detection
      FlxU.collide(player, t);
      FlxU.collide(onlyChild, t);
      FlxU.collide(secondChild, t);
		}
	}
	
}