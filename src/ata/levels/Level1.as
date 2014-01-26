package ata.levels 
{
    import ata.Level;
    import ata.Parent;
    import ata.Input;
    import ata.GameLogic;
	/**
     * ...
     * @author Ryan
     */
    public class Level1 extends Level
    {
        
        private const movement:Number = 200;
        private var parentObj:Parent;
        
        public function Level1() 
        {
            super(new playground_reality(), new playground_reality_hitbox(), new playground_reality_platforms(), new playground_imagination());
            
        }
        
        
		public override function update(input:Input, dt:Number, level:Level):void 
        {
            if (Math.abs(parentObj.position.x - GameLogic.instance.player.position.x) < movement*dt)
            {
                parentObj.position.x = GameLogic.instance.player.position.x;
            }
            else if (parentObj.position.x < GameLogic.instance.player.position.x)
            {
                parentObj.position.x += movement*dt;
            }
            else if (parentObj.position.x > GameLogic.instance.player.position.x)
            {
                parentObj.position.x -= movement*dt;
            }
        }
        
        override public function setupLevel(logic:GameLogic) 
        {
            super.setupLevel(logic);
            
            parentObj = new Parent();
            parentObj.position.x = 800;
            logic.addEntity(parentObj);
        }
    }

}