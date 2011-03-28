package ema {
	import org.flixel.*;
	import ema.utils.Log;
 
	public class PlayState extends FlxState {
    [Embed(source="sprites/tiles.png")] private var ImgTiles:Class;
	  protected var player:Mother;
	  
		override public function create():void {
      add(new FlxText(0,0,100,"Hello, World!"));
      var t:FlxTileblock = new FlxTileblock(0, FlxG.height-24, FlxG.width, 24);
      t.loadGraphic(ImgTiles);
      player = new Mother(FlxG.width/2-6, FlxG.height-50);
      add(t);
      add(player);
		}
		
		override public function update():void {
      super.update();
      collide();
		}
	}
	
}