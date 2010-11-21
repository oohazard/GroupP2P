package oohazard.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mx.core.TextFieldAsset;

	public class UI
	{
		private var _textFields : Object;
		private var _buttons : Object;
		private var _root : DisplayObjectContainer;
		
		public function UI(root : DisplayObjectContainer)
		{
			_root = root;
			_textFields = new Object;
			_buttons = new Object;
		}
		
		public function addTextField(name : String, x : uint, y : uint, value :String = "--", multiLine : Boolean = false, editable : Boolean = false) : void
		{
			var textField : TextField = new TextField;
			textField.multiline = multiLine;
			textField.text = value;
			textField.x = x;
			textField.y = y;
			
			if (editable)
			{
				textField.type = TextFieldType.INPUT;
			}
			
			if (_root.stage)
			{
				textField.width = _root.stage.stageWidth;	
			}
			else
			{
				textField.width = 400;	
			}
			_textFields[name] = textField;
			_root.addChild(textField);
		}
		
		public function getText(name : String) : String
		{
			if (_textFields[name])
			{
				return TextField(_textFields[name]).text;
			}
			else
			{
				return null;
			}
		}
		
		public function setText(name : String, value : String) : void
		{
			if (_textFields[name])
			{
				TextField(_textFields[name]).text = value;
			}
			else
			{
				addTextField(name, 0, 0, value);
			}
		}
		
		public function appendText(name : String, value : String, newLine : Boolean = true) : void
		{
			if (_textFields[name])
			{
				if (newLine)
				{
					TextField(_textFields[name]).appendText("\n" + value);	
				}
				else
				{
					TextField(_textFields[name]).appendText(value);
				}
			}
			else
			{
				addTextField(name, 0, 0, value);
			}
		}
		
		public function setSkeleton() : void
		{
			addTextField("LogList",0,200,"-- log --",true);
			addTextField("messageText",0, 0, "--");
			addTextField("idText",0, 50, "my ID (edit ME)", false, true);
			addTextField("groupStat",0, 100, "-- group --", true);
		}
		
		public function addButton(name : String, labelText: String, callback : Function, x : uint, y : uint) : void
		{
			var button : Sprite = new Sprite;
			var label : TextField = new TextField;
			label.text = labelText;
			button.addChild(label);

			button.x = x;
			button.y = y;
			
			button.addEventListener(MouseEvent.CLICK, function(event : MouseEvent):void{callback()});
			
			_buttons[name] = button;
			_root.addChild(button);
		}
		
	}
}

