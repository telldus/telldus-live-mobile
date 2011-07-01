import Qt 4.7
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList

Item{
	id: deviceElement
	height: setElementHeight()
	width: parent == undefined ? 0 : parent.width
	property bool hideFavorites: false
	visible: !hideFavorites || deviceItem.favorite

	Device {
		id: deviceItem
		deviceId:  device
	}

	Item{
		anchors.fill: parent

		/*
		Image{
			id: status
			source: "/bla/bla"
		}
		*/
		Text{
			id: status
			text: deviceItem.state==1 ? "\u263C" : "\u263D" //deviceItem.state + " " + parseInt(deviceItem.statevalue, 10)
			font.pointSize: 25
		}

		Text{
			text: deviceItem.name
			anchors.left: status.right
			color: "red"
		}

		Text{
			id: favoriteicon
			anchors.right: parent.right
			text: deviceItem.favorite==true ? "\u2605" : "\u2606"
			font.pointSize: 30
			MouseArea{
				anchors.fill: parent
				onClicked: {
					deviceItem.favorite = !deviceItem.favorite
				}
			}
			visible: !hideFavorites
		}

		Row{
			id: buttonrow
			Button{
				text: "ON"
				visible: MainScripts.methodContains(deviceItem.methods, "on")
				onClicked: {
					console.log("CLICKED on");
					deviceItem.turnOn();
				}
			}

			Button{
				text: "OFF"
				visible: MainScripts.methodContains(deviceItem.methods, "off")
				onClicked: {
					console.log("CLICKED off");
					deviceItem.turnOff();
				}
			}

			Button{
				text: "BELL"
				visible: MainScripts.methodContains(deviceItem.methods, "bell")
				onClicked: {
					console.log("CLICKED BELL");
					deviceItem.bell();
				}
			}
			anchors.right: favoriteicon.left
		}

		Slider{
			id: slider
			width: parent.width
			anchors.top: buttonrow.bottom
			height: MainScripts.SLIDERHEIGHT
			visible: MainScripts.methodContains(deviceItem.methods, "dim")
			value: parseInt(deviceItem.statevalue, 10)
			onSlided: {
				console.log("DIMMED to " + dimvalue);
				deviceItem.dim(dimvalue);
			}
		}
	}

	function setElementHeight(){
		var height = (!hideFavorites || deviceItem.favorite) ? MainScripts.DEVICEROWHEIGHT : 0;  //must set height to 0 to avoid space when hidden
		if(slider.visible){
			height = height + MainScripts.SLIDERHEIGHT;
		}
		return height;
	}
}
