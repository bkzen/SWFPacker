package  
{
	import com.bkzen.utils.SWFPacker;
	/**
	 * ...
	 * @author jc at bk-zen.com
	 */
	public class Materials extends SWFPacker
	{
		[Embed(source = "/../assets/mat1.swf")]
		public const Mat1: Class;
		[Embed(source = "/../assets/mat2.swf")]
		private var Mat2: Class;
		
		
		public function Materials() 
		{
			addClass(Mat1);
			addClass(Mat2);
		}
		
	}

}