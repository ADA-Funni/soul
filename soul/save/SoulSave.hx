package soul.save;

import flixel.util.FlxSave;

/**
 * A helper class used for binding save files and stuff without using `soul.save.Save`.
 */
class SoulSave {
    public var save:FlxSave;

    public function new() {
        save = new FlxSave();
    }

    /**
     * Gets field `name` from the save file.
     * @param name String
     * @return Null<Dynamic>
     */
    inline public function get(name:String):Null<Dynamic> {
        return Reflect.getProperty(save.data, name) ?? null;
    }

    /**
     * Sets field `name` to `value` in the save file.
     * @param name String
     * @param value Dynamic
     */
    inline public function set(name:String, value:Dynamic) {
        Reflect.setProperty(save.data, name, value);
    }

    /**
     * Binds the save file for your `SoulSave` instance to "`name`.sol" in the save folder for your game.
     * @param name String
     */
    inline public function bind(name:String) {
        save.bind(Save.validate(name), Save.path);
    }

    /**
     * Actually saves your save file to the file system.
     * 
     * Think of it like flushing a toilet.
     * @param sizeLimit Null<Int> (Optional) The size limit for your save file, in bytes.
     */
    inline public function flush(?sizeLimit:Int) {
        save.flush(sizeLimit);
    }

    /**
     * Erases your save file.
     * 
     * (Note: This is permanent and cannot be undone!)
     */
    inline public function erase() {
        save.erase();
    }
    
    /**
     * Destroys your `SoulSave` instance.
     * 
     * This can be used when you don't need it anymore.
     */
    inline public function destroy() {
        save.destroy();
    }

    /**
     * Calls `flush()` and `destroy()`.
     * @param sizeLimit Null<Int> (Optional) The size limit for your save file, in bytes.
     */
    inline public function close(?sizeLimit:Int) {
        save.close(sizeLimit);
    }
}