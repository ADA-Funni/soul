package soul.flash;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Button extends Sprite {
    public function new(bmp:BitmapData) {
        super();

        buttonMode = true;
        addChild(new Bitmap(bmp));

        addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		addEventListener(MouseEvent.CLICK, click);
    }

    public var onMouseOver:Void->Void = () -> {};
    public var onMouseOut:Void->Void = () -> {};
    public var onClick:Void->Void = () -> {};

    function mouseOver(ev) {
        onMouseOver();
	}

	function mouseOut(ev) {
        onMouseOut();
	}

	function click(ev) {
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		removeEventListener(MouseEvent.CLICK, click);

		onClick();
	}
}