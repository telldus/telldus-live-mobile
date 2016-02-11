import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Item {
	id: schedulerPage

	Component {
		id: schedulerDelegate
		Rectangle {
			color: "#eeeeee"
			height: wrapper.height + 1
			width: list.width
			Rectangle {
				id: wrapper
				width: list.width
				z: model.index
				height: Units.dp(50)
				color: "#ffffff"
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				Text {
					id: nextRunTime
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(10)
					anchors.verticalCenter: parent.verticalCenter
					color: properties.theme.colors.telldusOrange
					font.pixelSize: Units.dp(16)
					text: Qt.formatTime(job.runTimeToday, "HH:mm")
					width: Units.dp(60)
				}
				Text {
					id: deviceId
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: nextRunTime.right
					anchors.leftMargin: Units.dp(10)
					anchors.right: stateBox.left
					anchors.rightMargin: Units.dp(10)
					color: properties.theme.colors.telldusBlue
					text: job.device.name
					font.pixelSize: Units.dp(16)
					width: parent.width
					wrapMode: Text.Wrap
					elide: Text.ElideRight
					maximumLineCount: 2
				}
				Item {
					id: stateBox
					anchors.right: parent.right
					width: Units.dp(70)
					height: Units.dp(50)
					Item {
						anchors.fill: parent
						anchors.margins: Units.dp(10)
						Text {
							anchors.centerIn: parent
							text: getMethodText(job.method, job.value)
							font.pixelSize: Units.dp(16)
							color: properties.theme.colors.telldusBlue
						}
					}
				}
			}
		}
	}
	Component {
		id: schedulerListHeader
		Item {
			height: Units.dp(60)
			width: parent.width
			y: -list.contentY - height

			property bool refresh: state == "pulled" ? true : false

			Item {
				id: arrow
				anchors.fill: parent
				Image {
					id: arrowImage
					visible: !refreshTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refreshArrow/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
				Image {
					id: arrowImageRunning
					visible: closeTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refresh/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
					transformOrigin: Item.Center
					RotationAnimation on rotation {
						loops: Animation.Infinite
						from: 0
						to: 360
						duration: 1000
						running: closeTimer.running
					}
				}
				transformOrigin: Item.Center
				Behavior on rotation { NumberAnimation { duration: 200 } }
			}
			Text {
				anchors.centerIn: parent
				visible: refreshTimer.running && !closeTimer.running
				color: properties.theme.colors.telldusBlue
				font.pixelSize: Units.dp(12)
				text: "You can refresh once every 10 seconds."
				elide: Text.ElideRight
			}
			states: [
				State {
					name: "base"; when: list.contentY >= -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 180 }
				},
				State {
					name: "pulled"; when: list.contentY < -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 0 }
				}
			]
		}
	}
	Component {
		id: schedulerListSectionHeader
		Rectangle {
			width: parent.width
			height: Units.dp(28)
			color: "#dddddd"

			Rectangle {
				anchors.fill: parent
				anchors.topMargin: Units.dp(1)
				anchors.bottomMargin: Units.dp(1)
				color: "#f5f5f5"

				Text {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(20)
					//anchors.left: parent.left
					//anchors.leftMargin: Units.dp(10)
					text: getSectionHeading(section)
					font.bold: true
					font.pixelSize: Units.dp(14)
					color: "#999999"
				}

			}
		}
	}
	Rectangle {
		id: listEmptyView
		anchors.fill: parent
		visible : schedulerDaySortFilterModel.count == 0
		color: "#F5F5F5"
		onVisibleChanged: {
			if (schedulerDaySortFilterModel.count == 0) {
				refreshTimer.stop()
				closeTimer.stop()
			}
		}

		Text {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			anchors.leftMargin: Units.dp(20)
			anchors.rightMargin:Units.dp(20)
			color: properties.theme.colors.telldusBlue
			font.pixelSize: Units.dp(16)
			wrapMode: Text.Wrap
			horizontalAlignment: Text.AlignHCenter
			text: refreshTimer.running ? "Refreshing...\n\nyou can only refresh once every 10 seconds!" : "No schedules have been added yet, please go to http://live.telldus.com to add them. Then tap here to refresh!"
		}
		MouseArea {
			anchors.fill: parent
			enabled: listEmptyView.visible && !refreshTimer.running
			onReleased: {
				refreshTimer.start();
				schedulerModel.authorizationChanged();
			}
		}
	}
	ListView {
		id: list
		visible : schedulerDaySortFilterModel.count > 0
		anchors.fill: parent
		anchors.topMargin: closeTimer.running ? 0 : -headerItem.height
		anchors.leftMargin: screen.showHeaderAtTop ? 0 : header.width
		model: schedulerDaySortFilterModel
		delegate: schedulerDelegate
		section.property: "job.nextRunDate"
		section.criteria: ViewSection.FullString
		section.delegate: schedulerListSectionHeader
		maximumFlickVelocity: Units.dp(1500)
		spacing: Units.dp(1)
		header: schedulerListHeader
		pressDelay: 100
		onDragEnded: {
			if (headerItem.refresh && !refreshTimer.running) {
				console.log("Refreshing SchedulerModel")
				schedulerModel.authorizationChanged()
				refreshTimer.start()
				closeTimer.start()
			}
		}
	}
	Timer {
		id: closeTimer
		interval: 1000
		running: false
		repeat: false
	}
	Timer {
		id: refreshTimer
		interval: 10000
		running: false
		repeat: false
	}

	function  getSectionHeading(nextRunDate) {
		var weekdays = new Array(7);
		weekdays[0]=  "Sunday";
		weekdays[1] = "Monday";
		weekdays[2] = "Tuesday";
		weekdays[3] = "Wednesday";
		weekdays[4] = "Thursday";
		weekdays[5] = "Friday";
		weekdays[6] = "Saturday";

		nextRunDate = new Date(nextRunDate);
		var today = new Date();
		var tomorrow = new Date();
		tomorrow.setDate(tomorrow.getDate() + 1);
		var inAWeek = new Date();
		inAWeek.setDate(inAWeek.getDate() + 7);

		var weekday = nextRunDate.getDay();

		if (nextRunDate.toDateString() == today.toDateString()) {
			return "Today";
		} else if (nextRunDate.toDateString() == tomorrow.toDateString()) {
			return "Tomorrow";
		} else if (nextRunDate.toDateString() == inAWeek.toDateString()) {
			return "Next " + weekdays[weekday];
		} else {
			return weekdays[weekday];
		}
	}

	function getMethodText(method, methodValue) {
		if (method == 1) {
			return "On"
		} else if (method == 2) {
			return "Off"
		} else if (method == 4) {
			return "Bell"
		} else if (method == 16) {
			return "Dim"
		} else if (method == 128) {
			return "Up"
		} else if (method == 256) {
			return "Down"
		} else if (method == 512) {
			return "Stop"
		} else {
			return ""
		}
	}

	function primarySet() {
		if (methods & (128+256)) {
			return 1; // Up and Down
		}
		if (methods & 4) {
			return 2;
		}

		return 0;
	}

	function onBackClicked() {
		mainInterface.setActivePage(0);
	}

	function updateHeader() {
		header.title = "Upcoming schedule";
	}
}
