package ata.levels 
{
    import ata.Level;
    import ata.Parent;
    import ata.Input;
    import ata.GameLogic;
    import flash.display.Shape;
    import ata.Star;
	/**
     * ...
     * @author Ryan
     */
    public class Level1 extends Level
    {
        
        private const movement:Number = 130;
        private var parentObj:Parent;
        private var firstStar:Star;
        
        public function Level1() 
        {
            super(new playground_reality(), new playground_reality_hitbox(), new playground_reality_platforms(),
                    new playground_imagination(), new playground_imagination_hitbox(), new playground_imagination_platforms());
        }
        
        
		public override function update(input:Input, dt:Number, level:Level):void 
        {
            if (Math.abs(parentObj.position.x - GameLogic.instance.player.position.x) < movement*dt)
            {
                parentObj.position.x = GameLogic.instance.player.position.x;
                parentObj.speed.x = 0;
            }
            else if (parentObj.position.x < GameLogic.instance.player.position.x)
            {
                parentObj.speed.x = movement;
            }
            else if (parentObj.position.x > GameLogic.instance.player.position.x)
            {
                parentObj.speed.x = -movement;
            }
        }
        
        override public function setupLevel(logic:GameLogic):void
        {
            super.setupLevel(logic);
            
            parentObj = new Parent();
            parentObj.position.x = 100;
            logic.addEntity(parentObj);
            
            firstStar = new Star();
            firstStar.position.x = 2050;
            firstStar.position.y = -310;
            logic.stars.push(firstStar);
            logic.addEntity(firstStar);
        }
    }

}