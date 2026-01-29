package soul;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.typeLimit.OneOfTwo;
import haxe.Json;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import openfl.Assets;

using StringTools;

#if sys
import sys.FileSystem;
#end

/**
 * A helper class for accessing the assets folder.
 */
class Res {
    /**
     * Your asset folder.
     */
    static final ASSET_FOLDER:String = "assets";

    /**
     * Detects if your file isn't audio.
     * @param fileName String
     * @return Bool
     */
    inline private static function isntAudio(fileName:String):Bool {
        return !fileName.endsWith(".mp3") && !fileName.endsWith(".ogg");
    }

    /**
     * Detects if any item in `array` ends with `str`.
     * @param array Array<String>
     * @param str String
     * @return Bool
     */
    public static function arrayHasEnding(array:Array<String>, str:String):Bool {
        for (key in array) {
            if (key.endsWith(str)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Formats `str` to "-`str`", or "" if it's blank.
     * @param str String
     * @return String
     */
    inline public static function formatVariation(str:String):String {
        return str == "" ? str : '-$str';
    }

    /**
     * Returns "`ASSET_FOLDER`/`file`".
     * @param file String
     * @return String
     */
    inline public static function path(file:String):String {
        return '$ASSET_FOLDER/$file';
    }

    /**
     * Reads a file directory for `directory`.
     * @param directory String
     * @return Array<String>
     */
    public static function read(directory:String):Array<String> {
        final file:String = path(directory);

        var entries:Array<String> = [];

        #if sys
        for (name in FileSystem.readDirectory(file)) {
            entries.push('$file/$name');
        }
        #else
        for (name in Assets.list(null).filter(f -> f.startsWith(file) && isntAudio(f))) {
            entries.push(name);
        }
        #end

        return entries;
    }

    /**
     * Gets data from a file.
     * @param file String
     * @param usePath Null<Bool>
     * @return Dynamic
     */
    inline public static function get(file:String, ?usePath:Bool = true):Dynamic {
        return #if sys sys.io.File.getContent(usePath ? path(file) : file) #else Assets.getText(usePath ? path(file) : file) #end;
    }

    /**
     * Gets `haxe.io.Bytes` from a file.
     * @param file 
     * @param usePath 
     * @return Dynamic
     */
    inline public static function getBytes(file:String, ?usePath:Bool = true):Bytes {
        return #if sys sys.io.File.getBytes(usePath ? path(file) : file) #else Bytes.ofData(Assets.getBytes(usePath ? path(file) : file)) #end;
    }

    /**
     * Detects if your file exists.
     * @param file String
     * @param usePath Null<Bool>
     * @return Bool
     */
    inline public static function exists(file:String, ?usePath:Bool = true):Bool {
        return #if sys FileSystem.exists #else Assets.exists #end(usePath ? path(file) : file);
    }

    /**
     * My very own ZIP parsing function!
     * 
     * It will return a Dynamic for JSON stuff, and a Bytes for everything else.
     * @param file File path.
     * @return Map<String, OneOfTwo<Dynamic, Bytes>>
     */
    public static function readZIP(file:String):Map<String, OneOfTwo<Dynamic, Bytes>> {
        final data:Bytes = Bytes.ofData(Assets.getBytes(file));

        var zipReader = new haxe.zip.Reader(new BytesInput(data));
        final entries = zipReader.read();

        var map:Map<String, Dynamic> = [];
        for (entry in entries) {
            if (entry.fileName.endsWith(".json")) {
                map.set(entry.fileName, cast Json.parse(entry.data.toString()));
                continue;
            }

            map.set(entry.fileName, entry.data);
        }

        zipReader = null;

        return map;
    }

    inline public static function sparrow(name:String):FlxAtlasFrames {
        return FlxAtlasFrames.fromSparrow('$name.png', '$name.xml');
    }
}