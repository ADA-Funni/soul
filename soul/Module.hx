package soul;

import polymod.hscript.HScriptedClass;

class Module {
    public var id:String;

    public function new(id:String) {
        this.id = id;
    }

    public function toString():String {
        return id;
    }
}

@:hscriptClass
class ScriptedModule extends Module implements HScriptedClass {}