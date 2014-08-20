package
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;

	/**
	 * 扇型组件 
	 * @author huang.xinghui
	 * 
	 */	
	public class Sector extends UIComponent
	{
		public function Sector()
		{
		}
		
		private var _angle:Number;

		/**
		 * 扇型角度
		 * @return 
		 * 
		 */		
		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			if (Math.abs(value) > 360)
				_angle = 360;
			else 
				_angle = value;
			invalidateDisplayList();
		}

		private var _startAngle:Number;

		/**
		 * 扇型起始角度 
		 * @return 
		 * 
		 */		
		public function get startAngle():Number
		{
			return _startAngle;
		}

		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			invalidateDisplayList();
		}
		
		private var _innerRadius:Number;

		/**
		 * 扇型内圈半径 
		 * @return 
		 * 
		 */		
		public function get innerRadius():Number
		{
			return _innerRadius;
		}

		public function set innerRadius(value:Number):void
		{
			_innerRadius = value;
			invalidateDisplayList();
		}
		
		private var _outerRadius:Number;

		/**
		 * 扇型外圈半径 
		 * @return 
		 * 
		 */		
		public function get outerRadius():Number
		{
			return _outerRadius;
		}

		public function set outerRadius(value:Number):void
		{
			_outerRadius = value;
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = measuredHeight = measuredMinWidth = measuredMinHeight = this._outerRadius * 2;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var g:Graphics = graphics;
			g.clear();
			
			if (!this._angle) return;
			
			var circleColor:uint = getStyle("circleColor");
			g.lineStyle(1, circleColor);
			g.beginFill(circleColor);
			
			// draw sector 
			// http://ntt.cc/2008/09/22/tutorials-step-by-step-to-create-your-sector-menu.html
			var n:Number = Math.ceil(Math.abs(_angle) / 45);
			var angleA:Number = _angle / n * Math.PI / 180;
			var startA:Number = _startAngle * Math.PI / 180;
			var startB:Number = startA;
			var startX:Number = this._outerRadius;
			var startY:Number = this._outerRadius;
			
			//start edge
			g.moveTo(startX + _innerRadius * Math.cos(startA), startY + _innerRadius * Math.sin(startA));
			g.lineTo(startX + _outerRadius * Math.cos(startA), startY + _outerRadius * Math.sin(startA));
			
			//outer arc
			for (var i:uint = 1; i <= n; i++)
			{
				startA += angleA;
				
				var angleMid1:Number = startA - angleA / 2;
				var bx:Number = startX + _outerRadius / Math.cos(angleA / 2) * Math.cos(angleMid1);
				var by:Number = startY + _outerRadius / Math.cos(angleA / 2) * Math.sin(angleMid1);
				var cx:Number = startX + _outerRadius * Math.cos(startA);
				var cy:Number = startY + _outerRadius * Math.sin(startA);
				
				g.curveTo(bx, by, cx, cy);
			}
			
			// start position of inner arc
			g.lineTo(startX + _innerRadius * Math.cos(startA),startY + _innerRadius * Math.sin(startA));
			
			//inner arc
			for (var j:uint = n; j >= 1; j--)
			{
				startA -= angleA;
				
				var angleMid2:Number=startA + angleA / 2;
				var bx2:Number = startX + _innerRadius / Math.cos(angleA / 2) * Math.cos(angleMid2);
				var by2:Number = startY + _innerRadius / Math.cos(angleA / 2) * Math.sin(angleMid2);
				var cx2:Number = startX + _innerRadius * Math.cos(startA);
				var cy2:Number = startY + _innerRadius * Math.sin(startA);
				
				g.curveTo(bx2, by2, cx2, cy2);
			}
			
			// end position of inner arc.
			g.lineTo(startX + _innerRadius * Math.cos(startB), startY + _innerRadius * Math.sin(startB));
			
			//done
			g.endFill();
		}
	}
}