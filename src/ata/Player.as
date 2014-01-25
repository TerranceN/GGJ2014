package ata
{
	
	/**
	 * ...
	 * @author Matthew Hyndman
	 */
	public class Player extends Entity
	{
		
		public function Player(x:int, y:int) {
			super(20, 80);
			draw();
			this.x = x;
			this.y = y;
		}
	}
	
}