import QtQuick 2.0
import Telldus 1.0

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
				height: 50 * SCALEFACTOR
				color: "#ffffff"
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				Text {
					id: nextRunTime
					anchors.left: parent.left
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.verticalCenter: parent.verticalCenter
					color: properties.theme.colors.telldusOrange
					font.pixelSize: 20 * SCALEFACTOR
					font.weight: Font.Bold
					text: Qt.formatTime(job.nextRunTime, "HH:mm")
					width: 60 * SCALEFACTOR
				}
				Text {
					id: deviceId
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: nextRunTime.right
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.right: stateBox.left
					anchors.rightMargin: 10 * SCALEFACTOR
					color: properties.theme.colors.telldusBlue
					font.weight: Font.Bold
					text: job.device.name
					font.pixelSize: 16 * SCALEFACTOR
					width: parent.width
					wrapMode: Text.Wrap
					elide: Text.ElideRight
					maximumLineCount: 2
				}
				Item {
					id: stateBox
					anchors.right: parent.right
					width: 70 * SCALEFACTOR
					height: 50 * SCALEFACTOR
					Rectangle {
						anchors.fill: parent
						anchors.margins: 10 * SCALEFACTOR
						radius: width * 0.1
						color: properties.theme.colors.telldusBlue
//						Rectangle {
//							anchors.fill: parent
//							anchors.margins: 1 * SCALEFACTOR
//							radius: width * 0.1
//							color: "#ffffff"
							Text {
								anchors.centerIn: parent
								text: getMethodText(job.method, job.value)
								font.pixelSize: 10 * SCALEFACTOR
								font.weight: Font.Bold
								color: "#ffffff"
							}
//						}
					}
				}
			}
		}
	}
	Component {
		id: sectionHeading
		Rectangle {
			width: parent.width
			height: childrenRect.height + (10 * SCALEFACTOR)
			color: properties.theme.colors.telldusOrange

			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				text: getSectionHeading(section)
				font.bold: true
				font.pixelSize: 20 * SCALEFACTOR
				color: "#ffffff"
			}
		}
	}
	ListView {
		id: list
		anchors.fill: parent
		anchors.topMargin: screen.showHeaderAtTop ? header.height : 0
		anchors.leftMargin: screen.showHeaderAtTop ? 0 : header.width
		model: schedulerDaySortFilterModel
		delegate: schedulerDelegate
		section.property: "job.nextRunDate"
		section.criteria: ViewSection.FullString
		section.delegate: sectionHeading
		maximumFlickVelocity: 1500 * SCALEFACTOR
		spacing: 1 * SCALEFACTOR
	}
	Header {
		id: header
		anchors.topMargin: 0
		title: "Scheduler"
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
}
