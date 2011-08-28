package ema {
  public class SpriteManifest {
    public const momSpriteBox1:Object = {
      "idle": {
        spriteArray: spriteArray(27,47),
        loop: true,
        boundingBox: [5, 70, 128, 74]
      },
      "idleWalk": {
        spriteArray: spriteArray(69,72),
        loop: false,
        boundingBox: [5, 70, 128, 74]
      },
      "walk": {
        spriteArray: spriteArray(2,21),
        loop: true,
        boundingBox: [5, 70, 132, 74]
      },
      "walkRun": {
        spriteArray: spriteArray(22,26),
        loop: false,
        boundingBox: [6, 72, 148, 78]
      },
      "walkAttack": {
        spriteArray: spriteArray(94,98),
        loop: false,
        boundingBox: [5, 70, 127, 72]
      },
      "walkRun": {
        spriteArray: spriteArray(22,26),
        loop: false,
        boundingBox: [5, 70, 127, 72]
      },
      "run": {
        spriteArray: spriteArray(99,118),
        loop: true,
        boundingBox: [6, 72, 148, 78]
      },
      "attack": {
        spriteArray: spriteArray(120,141),
        loop: false,
        boundingBox: [5, 2, 132, 140]
      },
      "jump": {
        spriteArray: spriteArray(47,68),
        loop: false,
        boundingBox: [4, 33, 154, 110]
      },
      "pickup": {
        spriteArray: spriteArray(142,150),
        loop: false,
        boundingBox: [5, 70, 128, 74]
      }
    };
    
    public const momSpriteBox2:Object = {
      "play": {
        spriteArray: spriteArray(2,16),
        loop: true,
        boundingBox: [4, 77, 126, 74]
      },
      "monsterDeath": {
        spriteArray: spriteArray(19,34),
        framesPerSecond: 15,
        loop: false,
        boundingBox: [4, 0, 257, 157]
      },
      "agedWalk": {
        spriteArray: spriteArray(37,56),
        loop: true,
        boundingBox: [4, 77, 126, 74]
      },
      "veryAgedWalk": {
        spriteArray: spriteArray(58,77),
        loop: true,
        boundingBox: [6, 79, 125, 71]
      },
      "death": {
        spriteArray: spriteArray(78,91),
        loop: false,
        boundingBox: [6, 83, 139, 68]
      },
      "newJump": {
        spriteArray: spriteArray(92,111),
        loop: false,
        boundingBox: [3, 38, 139, 110]
      }
    };
    
    public const teenSpriteBox1:Object = {
      "idle": {
        spriteArray: spriteArray(27,47),
        loop: true,
        boundingBox: [3, 49, 90, 52]
      },
      "idleWalk": {
        spriteArray: spriteArray(69,72),
        loop: false,
        boundingBox: [3, 49, 90, 52]
      },
      "walk": {
        spriteArray: spriteArray(2,21),
        loop: true,
        boundingBox: [3, 49, 92, 52]
      },
      "walkRun": {
        spriteArray: spriteArray(22,26),
        loop: false,
        boundingBox: [4, 50, 104, 55]
      },
      "walkAttack": {
        spriteArray: spriteArray(94,98),
        loop: false,
        boundingBox: [3, 49, 89, 50]
      },
      "walkRun": {
        spriteArray: spriteArray(22,26),
        loop: false,
        boundingBox: [3, 49, 89, 50]
      },
      "run": {
        spriteArray: spriteArray(99,118),
        loop: true,
        boundingBox: [4, 50, 103, 55]
      },
      "attack": {
        spriteArray: spriteArray(120,141),
        loop: false,
        boundingBox: [3, 1, 92, 98]
      },
      "jump": {
        spriteArray: spriteArray(47,68),
        loop: false,
        boundingBox: [3, 23.1, 108, 77]
      },
      "pickup": {
        spriteArray: spriteArray(142,150),
        loop: false,
        boundingBox: [3, 49, 90, 52]
      }
    };
    
    public const teenSpriteBox2:Object = {
      "play": {
        spriteArray: spriteArray(2,16),
        loop: true,
        boundingBox: [3, 54, 88, 52]
      },
      "monsterDeath": {
        spriteArray: spriteArray(19,34),
        framesPerSecond: 15,
        loop: false,
        boundingBox: [3, 0, 180, 110]
      },
      "agedWalk": {
        spriteArray: spriteArray(37,56),
        loop: true,
        boundingBox: [3, 54, 88, 52]
      },
      "veryAgedWalk": {
        spriteArray: spriteArray(58,77),
        loop: true,
        boundingBox: [4, 55, 87, 50]
      },
      "death": {
        spriteArray: spriteArray(78,91),
        loop: false,
        boundingBox: [4, 58, 97, 47]
      },
      "newJump": {
        spriteArray: spriteArray(92,111),
        loop: false,
        boundingBox: [2, 27, 97, 77]
      }
    };
    
    public const BabySpriteBox1:Object = {
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
    
	  public const BabySpriteBox2:Object = {
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
    
    [Embed(source="sprites/mother/motherStripPart1.png")] public const MotherStrip:Class
    [Embed(source="sprites/mother/motherStripPart2.png")] public const MotherStrip2:Class
    public const MomGraphic1:Object = {
      embed: MotherStrip,
      width: 160,
      height: 165
    };
    public const MomGraphic2:Object = {
      embed: MotherStrip2,
      width: 262,
      height: 168
    };
    
    [Embed(source="sprites/mother/motherStripPart1_teen.png")] public const TeenStrip:Class
    [Embed(source="sprites/mother/motherStripPart2_teen.png")] public const TeenStrip2:Class
    public const TeenGraphic1:Object = {
      embed: TeenStrip,
      width: 112,
      height: 116
    };
    public const TeenGraphic2:Object = {
      embed: TeenStrip2,
      width: 183,
      height: 118
    };
    
    [Embed(source="sprites/baby/babyStripPart1.png")] public const BabyStrip:Class
	  [Embed(source="sprites/baby/babyStripPart2.png")] public const BabyStrip2:Class
    public const BabyGraphic1:Object = {
      embed: BabyStrip,
      width: 80,
      height: 75
    };
    
    public const BabyGraphic2:Object = {
      embed: BabyStrip2,
      width: 86,
      height: 81
    };
    
    public function SpriteManifest() {}
    
    private function spriteArray(start:Number, end:Number):Array {
      var result:Array = new Array();
      var i:Number = start;

      while (i != end) {
        result.push(i);
        i++;
      }
      
      return result;
    }
  }
}