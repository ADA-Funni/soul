package soul.loading;

import flixel.FlxG;
import flixel.FlxState;

#if flixel_addons
import flixel.addons.util.FlxAsyncLoop;
#end

class LoadingState extends FlxState {
    private var functions:Array<Void->Dynamic> = [];
    private var nextState:FlxState;

    public function new(nextState:FlxState, ?funcs:Array<Void->Dynamic>) {
        super();

        this.nextState = nextState;

        if (funcs == null) return;
        for (func in funcs) functions.push(func);
    }

    #if flixel_addons
    var async:FlxAsyncLoop;
    #end

    // New loading tip: "Wesley, that's me!"
    inline public static function switchState(next:FlxState, ?funcs:Array<Void->Dynamic>) {
        FlxG.switchState(() -> new LoadingState(next, funcs));
    }

    override function create() {
        super.create();

        if (functions == []) return;

        #if flixel_addons
        var curFunc:Int = 0;
        async = new FlxAsyncLoop(functions.length, () -> {
            functions[curFunc];
            curFunc++;
        }, 1);
        async.start();

        add(async);
        #else
        for (func in functions) {
            func();
        }

        FlxG.switchState(() -> nextState);
        #end
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (functions == []) return;

        #if flixel_addons
        if (async.finished) {
            async.destroy();

            FlxG.switchState(nextState);
        }
        #end
    }

    override function destroy() {
        super.destroy();
    }
}