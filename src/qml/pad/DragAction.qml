import Qt 4.7
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList
import ".."

Item{
	id: dragAction
	property string action: ''
	property int dimvalue: 100
	height: dragActionStaticImage.height
	width: dragActionStaticImage.width
	property variant dragActionImage: undefined

	Image {
		id: dragActionStaticImage

		property string imagename: action == 'dim' ? 'on' : action //TODO change
		source: '../' +  imagename + '.png'
		opacity: dimvalue
		visible: MainScripts.methodContains(device.methods, action)

		width: MainScripts.methodContains(device.methods, action) ? sourceSize.width * SCALEFACTOR : 0
		height: sourceSize.height * SCALEFACTOR
		MouseArea{
			anchors.fill: parent

			drag.target: undefined
			drag.axis: Drag.XandYAxis
			property bool moved: false

			onPressed: {
				var comp = Qt.createComponent("DragActionImage.qml");
				dragActionImage = comp.createObject(favoriteLayout);
				dragActionImage.source = '../' +  dragActionStaticImage.imagename + '.png'
				drag.target = dragActionImage;
				drag.minimumX = MainScripts.TOOLBARWIDTH
				drag.maximumX = favoriteLayout.width - dragAction.width
				drag.minimumY = 0;
				drag.maximumY = favoriteLayout.height - dragAction.height;
				dragActionImage.x = mapToItem(favoriteLayout, mouseX, mouseY).x - dragAction.width/2;
				dragActionImage.y = mapToItem(favoriteLayout, mouseX, mouseY).y - dragAction.height/2;
				var moved = false;
			}

			onPositionChanged: {
				moved = true;
			}

			onReleased: {
				var newX = mapToItem(favoriteLayout, mouseX, mouseY).x - MainScripts.TOOLBARWIDTH - dragAction.width/2
				var newY = dragActionImage.y;

				var maxWidth = favoriteLayout.width - MainScripts.TOOLBARWIDTH - dragAction.width
				var maxHeight = favoriteLayout.height-MainScripts.VISUALDEVICEHEIGHT;
				if(newX > maxWidth){
					newX = maxWidth;
				}
				if(newY > maxHeight){
					newY = maxHeight;
				}
				if(newY < 0){
					newY = 0;
				}
				if(newX < 0){
					newX = 0;
				}

				if(moved){
					//do nothing if not moved
					VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, device.id, selectedTabId, MainScripts.DEVICE, action, dimvalue);
				}

				if(dragActionImage != undefined){
					dragActionImage.destroy();
				}
			}
		}
	}
}
