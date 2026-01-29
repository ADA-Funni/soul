package soul.graphics;

import animate.FlxAnimate;
import animate.FlxAnimateFrames;
import flixel.FlxCamera;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import haxe.Json;
import soul.Res;

enum SoulSpriteFrameType {
    FRAME_LABEL;
    SYMBOL;
}

typedef SoulSpriteAnimationData = {
    @:optional var assetId:Int;

    var name:String;
    var prefix:String;

    var offset:Array<Float>;
    var fps:Int;
    @:optional var indices:Array<Int>;

    @:optional var looped:Bool;

    @:optional var flipX:Bool;
    @:optional var flipY:Bool;
    
    /**
     * FLIXEL-ANIMATE
     * can be 0 for "frame_label" or 1 for "symbol"
     */
    @:optional var frameType:Int;
}

typedef SoulSpriteAssetData = {
    var path:String;
    var renderType:String;

    @:optional var flipX:Bool;
    @:optional var flipY:Bool;
}

typedef SoulSpriteData = {
    var offset:Array<Float>;
    var camera_offset:Array<Float>;
    var antialiasing:Bool;

    var flipX:Bool;
    var flipY:Bool;

    var assets:Array<SoulSpriteAssetData>;
    var metadata:Dynamic;
    var animations:Array<SoulSpriteAnimationData>;
}

/**
 * Basically FNF's offset system, but better.
 * 
 * P.S. I had Jimmy O. Yang on whilst coding this, he's really funny.
 */
class SoulSprite extends FlxAnimate {
    private var zero = FlxPoint.get(0, 0);

    public var data:SoulSpriteData;
    public var assets:Array<FlxAtlasFrames> = [];

    public var globalOffset:FlxPoint;
    public var cameraOffset:FlxPoint; // ADD THIS TO THE CAMERA MANUALLY!
    
    public var animationOffsets:Map<String, FlxPoint> = [];

    override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint {
        var point:FlxPoint = super.getScreenPosition(result, camera);
        if (globalOffset != null) point.add(globalOffset);
        return point;
    }

    public function new(?x:Float, ?y:Float) {
        super(x, y);
    }

    public function loadData(path:String):SoulSprite {
        if (!Res.exists('$path.json')) return this;

        data = cast Json.parse(Res.get('$path.json'));

        antialiasing = data.antialiasing;

        globalOffset = FlxPoint.get(data.offset[0], data.offset[1]);
        cameraOffset = FlxPoint.get(data.camera_offset[0], data.camera_offset[1]);

        for (asset in data.assets) {
            switch(asset.renderType) {
                case 'sparrow':
                    assets.push(FlxAtlasFrames.fromSparrow(Res.path('${asset.path}.png'), Res.get('${asset.path}.xml')));
                    
                case 'packer':
                    assets.push(FlxAtlasFrames.fromSpriteSheetPacker(Res.path('${asset.path}.png'), Res.path('${asset.path}.txt')));

                case 'animateatlas':
                    assets.push(FlxAnimateFrames.fromAnimate(Res.path(asset.path)));
            }
        }

        var _fakeFrames:FlxAtlasFrames = assets[0];
        for (i=>atlas in assets) {
            if (i == 0) continue;
            _fakeFrames.addAtlas(atlas);
        }
        frames = _fakeFrames;
        
        for (anim in data.animations) {
            animationOffsets.set(anim.name, FlxPoint.get(anim.offset[0], anim.offset[1]));

            if (anim.frameType != null) {
                if (anim.frameType == FRAME_LABEL.getIndex()) {
                    if (anim.indices == null) {
                        this.anim.addByFrameLabel(anim.name, anim.prefix, anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
                    } else {
                        this.anim.addByFrameLabelIndices(anim.name, anim.prefix, anim.indices, anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
                    }
                }

                if (anim.frameType == SYMBOL.getIndex()) {
                    if (anim.indices == null) {
                        this.anim.addBySymbol(anim.name, anim.prefix, anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
                    } else {
                        this.anim.addBySymbolIndices(anim.name, anim.prefix, anim.indices, anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
                    }
                }

                continue;
            }
            
            if (anim.indices == null) {
                animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
            } else {
                animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.fps, anim.looped ?? false, anim.flipX ?? data.flipX, anim.flipY ?? data.flipY);
            }
        }

        return this;
    }

    public function playAnimation(name:String, forced:Bool = false) {
        animation.play(name, forced);
        
        var oldSize:FlxPoint = FlxPoint.get(width, height);
        updateHitbox();
        setSize(oldSize.x, oldSize.y);
        oldSize.put();

        final daOffset:FlxPoint = animationOffsets.exists(name) ? animationOffsets.get(name) : zero;
        offset.add(daOffset.x * scale.x, daOffset.y * scale.y);
    }

    override function destroy() {
        super.destroy();

        for (asset in assets) {
            asset.destroy();
        }

        for (anim in animationOffsets) {
            anim.put();
        }

        globalOffset.put();
        cameraOffset.put();
        
        zero.put();
    }
}