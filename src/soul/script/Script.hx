package soul.script;

import flixel.FlxG;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;

/**
 * A helper class used for adding Haxe scripting (HScript) to your games.
 */
class Script {
	/**
	 * A list of every single script that is active right now.
	 */
    public static var scripts:Array<Script> = [];

	/**
	 * This runs your code.
	 */
	public var interp:Interp;

	/**
	 * This turns your code from text into `expr`.
	 */
    public var parser:Parser;
	/**
	 * This is what `interp` reads to run your code.
	 */
    public var expr:Expr;

    public function new(code:String) {
        parser = new Parser();
		parser.allowJSON = true; // This allows `haxe.Json`.
        parser.allowMetadata = true; // This allows the `@:thing` metadata.
		parser.allowTypes = true; // This allows `var john:Type;`.

        interp = new Interp();

		// A quick variable for the current state.
		// Beautiful, isn't it?
        interp.variables.set('game', FlxG.state);
        
        expr = parser.parseString(code);
        interp.execute(expr);

        // MSG, fuiyoh!
        // Also, I think trace gets set AFTER the interpreter executes.
        // But since we only code using functions in "Eff En Eff" HScript, we're fine.
        interp.variables.set('trace', function(msg:Dynamic) {
            Log.trace(msg, HSCRIPT);
        });

        scripts.push(this);
    }

	/**
	 * Sets field `name` to `value` in your `interp`.
	 * @param name String
	 * @param value Dynamic
	 */
    inline public function set(name:String, value:Dynamic) {
        interp.variables.exists(name) ? interp.variables.set(name, value) : null;
    }

	/**
	 * Gets field `name` from your `interp`.
	 * @param name String
	 * @return Null<Dynamic>
	 */
	inline public function get(name:String):Null<Dynamic>
	{
        return interp.variables.exists(name) ? interp.variables.get(name) : null;
    }

	/**
	 * Calls function `name` from your `interp`.
	 * @param name String
	 * @param args Null<Array<Dynamic>>
	 * @return Null<Dynamic>
	 */
	inline public function call(name:String, ?args:Dynamic):Null<Dynamic>
	{
        if (interp.variables.exists(name))
            return Reflect.callMethod(this, interp.variables.get(name), args ?? []);

        return null;
    }

	/**
	 * Destroys your script, to be used within the next life.
	 */
    public function destroy() {
		scripts.remove(this);

        parser = null;
        interp = null;
        expr = null;
    }
}