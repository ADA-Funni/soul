package soul.save;

import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * A helper class for accessing FlxG.save.data.
 */
class Save {
    /**
     * The file path for your save folder. (in %appdata%/Roaming on Windows)
     */
    public static var path(get, never):String;
        inline static function get_path():String {
            final company:String = FlxG.stage.application.meta.get('company');
            final file:String = FlxG.stage.application.meta.get('file');

		    return '$company/${validate(file)}';
        }

    /**
     * Gets field `name` from your save file.
     * @param name String
     * @return Null<Dynamic>
     */
    inline public static function get(name:String):Null<Dynamic> {
        return Reflect.getProperty(FlxG.save.data, name) ?? null;
    }

    /**
     * Sets field `name` to `value` in your save file.
     * @param name String
     * @param value Dynamic
     */
    inline public static function set(name:String, value:Dynamic) {
        Reflect.setProperty(FlxG.save.data, name, value);
    }

    /**
     * Formats `str` to always work as a save directory.
     * @param str String
     * @return String
     */
    inline public static function validate(str:String):String {
        @:privateAccess
        return FlxSave.validate(str);
    }
}