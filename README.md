# Soul Utils
This is a library that contains helper classes to be used in **HaxeFlixel** games.

This library is currently in active development, so if you could make pull requests and issues on this page, if you see anything wrong or want to enhance the library's features/functionality, that'd be a big help!

# To-Do:
Finish Sprite JSON Config [X]
Add ZIP functionality for Sprite Config []
Finish Sprite Editor []
Finish Level Editor []

soul v1.0.0 will release when the to-do list is finished.

# How to use SoulSprite:

To add a SoulSprite, just follow this example code:
```haxe
var thomas = new SoulSprite().loadData('data/animations');
add(thomas);
```

The path in `loadData()` works off of:
```haxe
Res.path(/* whatever you input into the function */) + '.json'
```

Also, make sure you follow the template in `soul/templates/animationConfig.json`!