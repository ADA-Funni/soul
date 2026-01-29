package soul;

import haxe.io.Bytes;

class Utf16 {
    /**
     * Returns UTF-16 String `input` as a UTF-8 String.
     * @param input 
     * @return String
     */
    public static function parse(input:String):String {
        var str:String = "";
        
		var file = Bytes.ofString(input);
		for (i in 0... file.length) {
			if (i < 2) continue;

			if (i % 2 == 0) str += unifill.Utf16.fromCodePoint(file.get(i)).toString();
		}

		return str;
    }
}