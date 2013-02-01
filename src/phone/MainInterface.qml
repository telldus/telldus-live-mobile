import QtQuick 1.0
import Telldus 1.0

Item {
	id: mainInterface
	Item {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: footer.top

		TabPage {
			component: "DevicePage.qml"
			pageId: 0
			currentPage: footer.activePage
		}
		TabPage {
			component: "SensorPage.qml"
			pageId: 1
			currentPage: footer.activePage
		}
		TabPage {
			component: "SettingsPage.qml"
			pageId: 2
			currentPage: footer.activePage
		}
	}

	function swipeLeft() {
		footer.activePage = Math.min(2, footer.activePage+1)
	}
	function swipeRight() {
		footer.activePage = Math.max(0, footer.activePage-1)
	}

	Footer {
		id: footer
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}
}
