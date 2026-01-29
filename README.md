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