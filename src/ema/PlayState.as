package ema {
	import org.flixel.*;
	import ema.utils.Log;
 
	public class PlayState extends FlxState {
		override public function create():void {
			add(new FlxText(0,0,100,"Hello, World!")); //adds a 100px wide text field at position 0,0 (upper left)
		}
		
		override public function update():void {
      super.update();
		}
	}
	
}