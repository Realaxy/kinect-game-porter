package org.realaxy.kinect.porter.tests.kinect
{
	import com.as3nui.nativeExtensions.air.kinect.data.Position;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.text.emptyString;
	import org.realaxy.kinect.porter.kinect.KinectUserSerialize;
	
	public class KinectUserSerializeTest
	{		
		private var _serializer:KinectUserSerialize = new KinectUserSerialize();
		
		[Test]
		public function testToBytesNotNull():void
		{
			var user:User = new User();
			var bytes:ByteArray = new ByteArray();
			_serializer.toBytes(bytes, user);
			assertThat(bytes, notNullValue());
			assertThat(bytes.length, greaterThan(0));
		}
		
		[Test]
		public function testToBytesForUserWithoutSkeleton():void
		{
			var user:User = new User();
			user.userID = 1;
			user.hasSkeleton = false;
			var bytes:ByteArray = new ByteArray();
			_serializer.toBytes(bytes, user);
			assertThat(bytes, notNullValue());
			bytes.position = 0;
			var json:String = bytes.readUTFBytes(bytes.length);
			assertThat(json, not(emptyString()));
			
			var test:String = JSON.stringify({userId:1});
			
			try
			{
				var result:Object = JSON.parse(json);				
			}
			catch(e:Error)
			{
				assertThat(e.message, emptyString());
			}
			
			assertThat(result.userID, equalTo(1));
		}
		
		[Test]
		public function testToBytesForUserWithSkeleton():void
		{
			var user:User = new User();
			user.userID = 1;
			user.hasSkeleton = true;
			user.skeletonJointNameIndices = new Dictionary();
			
			var joint:SkeletonJoint = new SkeletonJoint();
			joint.name = "head";
			joint.position = new Position();
			user.skeletonJointNameIndices[joint.name] = joint;
			
			var bytes:ByteArray = new ByteArray();
			_serializer.toBytes(bytes, user);
			
			bytes.position = 0;
			
			var json:String = bytes.readUTFBytes(bytes.length);
			assertThat(json, not(emptyString()));
			
			var test:String = JSON.stringify({userId:1});
			
			try
			{
				var result:Object = JSON.parse(json);				
			}
			catch(e:Error)
			{
				assertThat(e.message, emptyString());
			}
			
			assertThat(result.userID, equalTo(1));
			assertThat(result.joints, notNullValue());
		}
	}
}