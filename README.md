# How to use SoulSprite:

The path in `loadData()` works off of
```haxe
Res.path(/* whatever you input into the function */) + '.json'
```

To add a SoulSprite, just follow this example code:
```haxe
var thomas = new SoulSprite().loadData('data/animations');
add(thomas);
```

Also, make sure you follow the template in `soul/templates/animationConfig.json`!