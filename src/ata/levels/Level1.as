package ata.levels 
{
    import ata.Level;
    import ata.Parent;
    import ata.Input;
    import ata.GameLogic;
    import flash.display.Shape;
    import ata.Star;
    import ata.Bird;
    import ata.Vector2;
	/**
     * ...
     * @author Ryan
     */
    public class Level1 extends Level
    {
        
        private const movement:Number = 130;
        private var parentObj:Parent;
        private var firstStar:Star;
        private var bird:Bird
        
        public function Level1() 
        {
            super(new playground_reality(), new playground_reality_hitbox(), new playground_reality_platforms(),
                    new playground_imagination(), new playground_imagination_hitbox(), new playground_imagination_platforms());
        }
        
        
		public override function update(input:Input, dt:Number, level:Level):void 
        {
            if (parentObj.position.x < GameLogic.instance.player.position.x - 100)
            {
                parentObj.speed.x = movement;
            }
            else if (parentObj.position.x > GameLogic.instance.player.position.x + 100)
            {
                parentObj.speed.x = -movement;
            } else {
                parentObj.speed.x = 0
            }
        }
        
        override public function setupLevel(logic:GameLogic):void
        {
            super.setupLevel(logic);
            
            parentObj = new Parent();
            parentObj.position.x = 100;
            logic.addEntity(parentObj);
            
            firstStar = new Star();
            firstStar.position.x = 2250;
            firstStar.position.y = -310;
            logic.stars.push(firstStar);
            logic.addEntity(firstStar);

            var height = -250;

            bird = new Bird(x2 - 1000, height);
            logic.addEntity(bird)

            birdX1 = x2 - 1200;
            birdX2 = x2 - 700;
            
            var nextStar:Star = new Star();
            nextStar.position.x = 350;
            nextStar.position.y = -500;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
            
            nextStar = new Star();
            nextStar.position.x = 1200;
            nextStar.position.y = -500;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
            
            nextStar = new Star();
            nextStar.position.x = 1300;
            nextStar.position.y = -500;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
            
            nextStar = new Star();
            nextStar.position.x = 1270;
            nextStar.position.y = -100;
            logic.stars.push(nextStar);
            logic.addEntity(nextStar);
        }
    }

}
