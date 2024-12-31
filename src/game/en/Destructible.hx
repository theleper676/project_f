package en;

class Destructible extends Entity {
    var data:Entity_Destructible;
    public static var ALL:Array<Destructible> = [];
    
    public function new(d:Entity_Destructible) {
        data= d;
        super(data.cx, data.cy);
        ALL.push(this);
        initLife(2);
        var graphics = new h2d.Graphics(spr);
        graphics.beginFill(White);
		graphics.drawRect(-innerRadius, -hei, innerRadius*2, hei);
        graphics.endFill();
    }

    public function onpunch(e:Entity){
        trace("hit by " + e);
        hit(1, e);
    }
}