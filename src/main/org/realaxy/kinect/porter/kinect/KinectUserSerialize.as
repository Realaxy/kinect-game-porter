package org.realaxy.kinect.porter.kinect
{
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.geom.Point;
	import flash.utils.IDataOutput;

	public class KinectUserSerialize
	{
		public function toBytes(data:IDataOutput, user:User):void
		{
			data.writeUTFBytes('{"userID":');
			data.writeUTFBytes(user.userID.toString());
			
			if(user.hasSkeleton)
			{
				var joints:Vector.<SkeletonJoint> = user.skeletonJoints;
				data.writeUTFBytes(', "joints" : {');
				if(joints)
				{
					for(var index:int = 0, count:int = joints.length; index < count; index++) 
					{
						var joint:SkeletonJoint = joints[index];
						if(index > 0)
						{
							data.writeUTFBytes(", ");							
						}
						//data.writeUTFBytes('"name":');
						data.writeUTFBytes('"');
						data.writeUTFBytes(joint.name);
						data.writeUTFBytes('": ');
						var point:Point = joint.position.rgb;
						data.writeUTFBytes('[');
						data.writeUTFBytes(point.x.toString());
						data.writeUTFBytes(',');
						data.writeUTFBytes(point.y.toString());
						data.writeUTFBytes(']');
					}					
				}
				data.writeUTFBytes('}');
			}
			
			data.writeUTFBytes('}\n');
		}
	}
}