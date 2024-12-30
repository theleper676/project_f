package ui.component;


class DebugSlider extends ui.UiComponent {
    var slider:h2d.Slider;
    var label: h2d.Text;
    var getter: Void->Int;
    var setter:Int->Void;
    public function new(labelText:String, getter: Void->Int,setter: Int->Void,?parent:h2d.Object,col:dn.Col=Black) {
        super(parent);
        this.getter = getter;
        this.setter = setter;        
        slider = new h2d.Slider(50,50, this);
        label = new h2d.Text(Assets.fontPixelMono, this);
        label.text = labelText;
        label.textColor = col;
        slider.maxValue = 100;
        slider.minValue = 0;
    }

}