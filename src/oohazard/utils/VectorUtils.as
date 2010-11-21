package oohazard.utils
{

	public class VectorUtils
	{
		public static function removeFrom(vector : Vector.<Object>, objectToRemove : Object) : void
		{
			vector.splice(vector.indexOf(objectToRemove), 1);
		}
	}
}