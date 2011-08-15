import Qt 4.7
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList
import ".."

Item{
	id: dragAction
	property string action: ''
	property int dimvalue: 100
	property int initialX: 0
	property int initialY: 0
	property variant mappedCoord: favoriteLayout.mapToItem(availableFavoriteList, 0, 0); //TODO doesn't work for first list element for some reason...

	Image {
		id: dragActionImage

		property string imagename: action == 'dim' ? 'on' : action //TODO change
		source: '../' +  imagename + '.png'
		opacity: dimvalue
		visible: MainScripts.methodContains(device.methods, action)

		width: sourceSize.width * SCALEFACTOR
		height: sourceSize.height * SCALEFACTOR
		MouseArea{
			anchors.fill: parent

			drag.target: dragActionImage
			drag.axis: Drag.XandYAxis
			drag.minimumX: mappedCoord.x
			drag.maximumX: mappedCoord.x + favoriteLayout.width - dragActionImage.width
			drag.minimumY: mappedCoord.y
			drag.maximumY: mappedCoord.y + favoriteLayout.height - dragActionImage.height

			onPressed: {
				initialX = dragActionImage.x;
				initialY = dragActionImage.y;
			}

			onReleased: {
				var newX = dragActionImage.x - dragActionImage.width/2;
				var newY = dragActionImage.y - dragActionImage.height/2;
				var mapped = availableFavoriteList.mapToItem(favoriteLayout, newX, newY);
				newX = mapped.x;
				newY = mapped.y;

				var maxWidth = favoriteLayout.width - 100; //TODO constants!
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

				if(newX >= 0){
					//do nothing if dropped on list again
					VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, device.id, selectedTabId, MainScripts.DEVICE, action, dimvalue);
				}
				dragActionImage.x = initialX; //reset item location
				dragActionImage.y = initialY;
			}
		}
	}
}
