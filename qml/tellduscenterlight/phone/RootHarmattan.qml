import QtQuick 1.1
import com.nokia.meego 1.0
import "../DeviceList.js" as DeviceList
import "../Sensors.js" as Sensors
import "../mainscripts.js" as MainScripts

PageStackWindow {
	showStatusBar: true
	showToolBar: true
	initialPage: mainPage

	Component.onCompleted: {
		DeviceList.list.setTelldusLive( telldusLive )
		Sensors.list.setTelldusLive( telldusLive )
	}

	ToolBarLayout {
		id: commonTools
		visible: false
		ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); } }
	}

	Component {
		id: mainPage
		Page {
			anchors.fill: parent

			tools: ToolBarLayout {
				ButtonRow {
					platformStyle: TabButtonStyle { }
					TabButton {
						text: MainScripts.getFriendlyText(MainScripts.FAVORITE)
						tab: tabFavorites
					}
					TabButton {
						text: MainScripts.getFriendlyText(MainScripts.DEVICE)
						tab: tabDevices
					}
					TabButton {
						text: MainScripts.getFriendlyText(MainScripts.SENSOR)
						tab: tabSensors
					}
				}
				ToolIcon { iconId: "toolbar-view-menu"; onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close() }
			}

			TabGroup {
				currentTab: tabDevices

				ContentFavorite {
					id: tabFavorites
				}
				ContentDevice {
					id: tabDevices
				}
				ContentSensor {
					id: tabSensors
				}
			}

			Menu {
				id: myMenu
				MenuLayout {
					MenuItem {
						text: "Settings"
						onClicked: {
							var item = Qt.createComponent("../ContentSetting.qml");
							if (item.status == Component.Ready) {
								pageStack.push(item);
							}
						}
					}
				}
			}
		}
	}
}
