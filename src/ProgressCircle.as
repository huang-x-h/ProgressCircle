package
{
	import flash.display.Graphics;
	
	import mx.controls.Label;
	import mx.core.UIComponent;

	[Style(name="trackColor", inherit="no", type="Color")]
	
	[Style(name="circleColor", inherit="yes", type="Color")]
	/**
	 * 圆圈进度条
	 *  
	 * @author huang.xinghui
	 * 
	 */	
	public class ProgressCircle extends UIComponent
	{
		public function ProgressCircle()
		{
		}
		
		private var sector:Sector;
		
		private var textField:Label;
		
		private var sectorChanged:Boolean;
		
		private var _radius:Number;

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			sectorChanged = true;
			invalidateProperties();
			invalidateSize();
		}
		
		private var _trackThickness:Number;
		
		public function get trackThickness():Number
		{
			return _trackThickness;
		}

		public function set trackThickness(value:Number):void
		{
			_trackThickness = value;
			sectorChanged = true;
			invalidateProperties();
		}

		private var _angle:Number;

		private var angleChanged:Boolean = false;
		
		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			angleChanged = true;
			invalidateProperties();
		}
		
		private var _progress:Number;
		
		private var progressChanged:Boolean = false;

		public function get progress():Number
		{
			return _progress;
		}

		public function set progress(value:Number):void
		{
			_progress = value;
			progressChanged = true;
			invalidateProperties();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			sector = new Sector();
			sector.styleName = this;
			addChild(sector);
			
			textField = new Label();
			textField.styleName = this;
			addChild(textField);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (angleChanged) 
			{
				sector.startAngle = this._angle;
				angleChanged = false;
			}
			
			if (sectorChanged)
			{
				sector.innerRadius = this._radius - this._trackThickness;
				sector.outerRadius = this._radius;
				sectorChanged = false;
			}
			
			if (progressChanged)
			{
				textField.text = this._progress + '%';
				sector.angle = this._progress / 100 * 360;
				progressChanged = false;
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = measuredMinWidth = measuredHeight = measuredMinHeight = this._radius * 2;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var trackColor:uint = getStyle("trackColor");
			var backgroundColor:uint = getStyle("backgroundColor");
			
			var g:Graphics = graphics;
			g.clear();
			
			// draw outer circle
			g.beginFill(trackColor);
			g.drawCircle(this._radius, this._radius, this._radius);
			g.endFill();
			
			// draw inner circle
			g.beginFill(backgroundColor);
			g.drawCircle(this._radius, this._radius, this._radius - this._trackThickness);
			g.endFill();
			
			sector.setActualSize(sector.getExplicitOrMeasuredWidth(), sector.getExplicitOrMeasuredHeight());
			sector.move((unscaledWidth - sector.width) / 2, (unscaledHeight - sector.height) / 2);
			
			textField.setActualSize(textField.getExplicitOrMeasuredWidth(), textField.getExplicitOrMeasuredHeight());
			textField.move((unscaledWidth - textField.width) / 2, (unscaledHeight - textField.height) / 2);
		}
	}
}