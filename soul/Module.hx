package soul;

import polymod.hscript.HScriptedClass;

class Module {
    public var id:String;

    public function new(id:String) {
        this.id = id;
    }
}

@:hscriptClass
class ScriptedModule extends Module implements HScriptedClass {}