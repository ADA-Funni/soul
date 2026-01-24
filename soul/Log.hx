package soul;

import haxe.PosInfos;

#if sys
import lime.app.Application;
#end

/**
 * Used for getting colours when calling `trace()`.
 */
enum LogType
{
	ENGINE;
	INFO;

	LUA;
	HSCRIPT;

	WARNING;
	ERROR;
	API(apiName:String);
}

#if sys
/**
 * A helper class for printing to the command line.
 * 
 * Code stolen from InvertZ, and refactored by ADA_Funni
 * @see https://github.com/InvertedZed (Thanks, Harper!)
**/
class Log
{
	/**
	 * A big map of all log types and their corresponding colours.
	 */
	static final colorMap:Map<LogType, Int> = [
		ENGINE => 0xFFFFFF,
		INFO => 0x81AEF1,

		LUA => 0x3FB7FC,
		HSCRIPT => 0xF36F22,
		
		WARNING => 0xFCFC40,
		ERROR => 0xFF3838,

		API('GAMEJOLT') => 0x3DB31F,
		API('GAMEJOLT ERROR') => 0xCBFF8F,

		API('NEWGROUNDS') => 0xF5AB23,
		API('NEWGROUNDS ERROR') => 0xFFCA98,

        API('DISCORD') => 0x4E3BFA,
		API('DISCORD ERROR') => 0x968AFF,
	];

	public static var initialised:Bool = false;

	/**
	 * Outputs string `input` to the command line.
	 * 
	 * Note: This class supports coloured text with `colorMap`.
	 * @param input Dynamic
	 * @param type LogType
	 * @param posInfos PosInfos
	 */
	public static function trace(input:Dynamic, type:LogType, ?posInfos:PosInfos)
	{
		final icolor:Array<Int> = Color.hex2RGB(colorMap[type ?? ENGINE]);
		final prefix:String = type.getParameters()[0] ?? type.getName();
		final posInfoStr:String = posInfos != null ? ' (${posInfos.className}:${posInfos.lineNumber})' : '';

		Sys.println('\x1b[0m\033[38;2;${icolor[0]};${icolor[1]};${icolor[2]}m' + '[$prefix]$posInfoStr: ${Std.string(input)}');

		// Don't initialise the program using
		// an `init()` function, that's for losers!
		if (!initialised) {
			Application.current.window.onClose.add(onEndProgram);
			initialised = true;
		}
	}

	inline public static function onEndProgram()
	{
		Sys.print("\x1b[0m"); // Clear the colour!
	}
}

/**
 * A helper class for using coloured text on the command line.
 */
class Color {
    /**
      * Converts a hex colour (#RRGGBB) into an RGB colour. [R, G, B]
    **/
    public static function hex2RGB(hex:Int):Array<Int> {
		return [((hex >> 16) & 0xff), ((hex >> 8) & 0xff), ((hex) & 0xff)];
	}
    
    /**
      * Converts a an RGB colour [R, G, B] into a hex colour (#RRGGBB).
    **/
	public static function rgb2Hex(r:Int, g:Int, b:Int):Int {
		return (1 << 24 | r << 16 | g << 8 | b);
	}
}
#else
/**
 * A helper class for accessing the command line.
 * 
 * This class is limited because you aren't on a `sys` target.
**/
class Log {
	public static function trace(input:Dynamic, type:LogType, ?posInfos:PosInfos) {
		haxe.Log.trace(input, posInfos);
	}
}
#end