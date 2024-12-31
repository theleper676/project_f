package en;

import h2d.Graphics;


class Hero extends Entity {

    var ca: ControllerAccess<GameAction>;
    var walkValue:Float = 0;
    static var gravity = 0.05;
    static var jumpForce = 0.45;
    static var speed = 0.10;
    static var frictionX = 0.105;
    static var frictionY = 0.94; // There is gotta be a better way to write this

    /* Cooldown Timers */
    var dashCooldown:Float = 0.8;
    var onGround(get,never):Bool;
        inline function get_onGround() return vBase.dy == 0 && level.hasCollision(cx, cy+1);

    public function new() {
        super(10,10);
        hei = 32;
        var startPos = level.data.l_Entities.all_PlayerStart[0];
        if(startPos != null)
            setPosCase(startPos.cx, startPos.cy);


        

        /** Camera stuff */
        camera.trackEntity(this, true);
        camera.clampToLevelBounds = true;

        /* Phsyics Stuff */
        vBase.setFricts(frictionX, frictionY);


        /* Controller Init */
        ca = App.ME.controller.createAccess();

        /* Spritie Init */
        var graphics = new Graphics(spr);
        graphics.beginFill(Green);
        graphics.drawRect(-innerRadius, -hei, innerRadius*2, hei);
        graphics.endFill();
    }

    inline function isInRange (e:Entity, rangeMult: Float) {
        return e.isAlive() && distPx(e) <= 24* rangeMult && dirTo(e) == dir;
    }

    function onMelee() {
        for (e in en.Destructible.ALL)
            if(isInRange(e, 1))
                e.onpunch(this);
    }

    override function dispose() {
        super.dispose();
        ca.dispose();
    }

    override function onPreStepY() {
        super.onPreStepY();
        if( yr > 1 && level.hasCollision(cx, cy+1)) {
            vBase.dy = 0;
            vBump.dy = 0;
            yr =1;
            onPosManuallyChangedY();
        }
    }

    override function onPreStepX() {
        super.onPreStepX();
        if(xr > 0.5 && level.hasCollision(cx+1, cy))
            xr = 0.5;
        if(xr < 0.5 && level.hasCollision(cx-1, cy))
            xr = 0.5;
    }


    override function frameUpdate() {
        super.frameUpdate();

        if(ca.isPressed(MoveLeft))
            dir = -1;
        if(ca.isPressed(MoveRight))
            dir = 1;

        /* Dash Movement */
        if(!cd.has("dashLock") && ca.isPressed(Dash)){
            cd.setS("dashLock", dashCooldown);

            vBase.dy *= 0.1;
            vBase.dx = dir*0.06*tmod;
        }

        /*Walk Movement */
        var stickDist = ca.getAnalogValue2(MoveLeft, MoveRight);
        if(stickDist != 0)
            vBase.dx +=stickDist * speed * tmod;

        /* Jump */
        if(onGround && ca.isPressed(Jump))
            vBase.dy = -jumpForce;

        /* Attack */
        if(ca.isPressed(Melee)) {
            ca.rumble(0.5,0.045);
            onMelee();
        }
    }
    override function preUpdate() {
        super.preUpdate();
        walkValue = 0;
        
        if(onGround)
            cd.setS("recentlyOnGround", 0.1);

        if(ca.getAnalogDist2(MoveLeft, MoveRight) > 0)
            walkValue = ca.getAnalogValue2(MoveLeft, MoveRight);

       
    }

    override function fixedUpdate() {
        super.fixedUpdate();
        if(!onGround) 
            vBase.dy +=gravity;

       
    }
}