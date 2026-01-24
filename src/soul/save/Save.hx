package soul.save;

import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * A helper class for accessing FlxG.save.data.
 */
class Save {
    public static var path(get, never):String;
        inline static function get_path():String {
            final company:String = FlxG.stage.application.meta.get('company');
            final file:String = FlxG.stage.application.meta.get('file');

		    return '$company/${validate(file)}';
        }

    inline public static function get(name:String):Dynamic {
        return Reflect.getProperty(FlxG.save.data, name) ?? null;
    }

    inline public static function set(name:String, value:Dynamic) {
        Reflect.setProperty(FlxG.save.data, name, value);
    }

    /**
     * Fuck yeah, public save validation!
     * @param str 
     * @return String
     */
    inline public static function validate(str:String):String {
        @:privateAccess
        return FlxSave.validate(str);
    }
}