package en;

class Enemy extends Entity {
    public static var ALL: Array<Enemy>  = [];
    var data: Entity_Enemy;
    public function new(d:Entity_Enemy) {
        data = d;
        super(d.cx, d.cy);
        ALL.push(this);
        life.initMaxOnMax(15);
        var graphics = new h2d.Graphics(spr);
        graphics.beginFill(0xcc3806);
		graphics.drawRect(-innerRadius, -hei, innerRadius*2, hei);
    }


    override function hit(dmg:Int, from:Null<Entity>) {
        super.hit(dmg, from);
        trace(life);
    }

    override function dispose() {
        super.dispose();
        ALL.remove(this);
    }

    override function onDie() {
        super.onDie();
        trace("this enemy is dead");
    }
}