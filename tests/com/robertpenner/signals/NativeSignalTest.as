package com.robertpenner.signals
{
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class NativeSignalTest extends TestCase
	{
		private var clicked:ISignal;
		private var sprite:IEventDispatcher;

		public function NativeSignalTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			sprite = new Sprite();
			clicked = new NativeSignal(sprite, 'click', MouseEvent);
		}

		protected override function tearDown():void
		{
			clicked.removeAll();
			clicked = null;
		}

		public function testInstantiated():void
		{
			assertTrue("NativeSignal instantiated", clicked is NativeSignal);
			assertTrue('implements ISignal', clicked is ISignal);
			assertFalse('sprite has no click event listener to start', sprite.hasEventListener('click'));
		}
		//////
		public function test_signal_add_then_EventDispatcher_dispatch_should_call_signal_listener():void
		{
			clicked.add( addAsync(onClicked, 10) );
			sprite.dispatchEvent(new MouseEvent('click'));
		}
		
		private function onClicked(e:MouseEvent):void
		{
			assertSame(sprite, e.currentTarget);
		}
		//////
		public function test_when_signal_adds_listener_then_target_should_have_listener():void
		{
			clicked.add(emptyHandler);
			assertTrue(sprite.hasEventListener('click'));
		}
		
		private function emptyHandler(e:MouseEvent):void {}
		
		public function test_when_signal_adds_then_removes_listener_then_target_should_not_have_listener():void
		{
			clicked.add(emptyHandler);
			clicked.remove(emptyHandler);
			assertFalse(sprite.hasEventListener('click'));
		}
	}
}
