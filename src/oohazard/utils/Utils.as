package oohazard.utils
{
	public class Utils
	{
		public function Utils()
		{
		}
		
		public static function arrayCollectionToArray(myArrayCollection:Object):Array {
			
			var values:Array = myArrayCollection.serverInfo.initialData;
			return values;
			
			//var category:Array = myArrayCollection.serverInfo.columnNames;
			
			/*
			var aArr:Array = new Array();
			
			for (var i:Number=0; i < values.length; i++) {
				
				aArr[i] = new Object();
				
				for (var aIndex:* in category) {
					
					aArr[i][category[aIndex]] = values[i][aIndex];
					
				}
				
			}
			
			var dp:DataProvider = new DataProvider(aArr);
			
			return dp;
			*/
		}
	
	}
}