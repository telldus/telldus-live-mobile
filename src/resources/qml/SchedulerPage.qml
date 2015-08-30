import QtQuick 2.0
import Telldus 1.0

Item {
	id: schedulerPage
	Component {
		id: schedulerDelegate
		Text {
			color: properties.theme.colors.telldusBlue
			width: list.width
			font.pixelSize: 16 * SCALEFACTOR
			font.weight: Font.Bold
			text: job.deviceId + " (" + job.nextRunTime + ")"
			elide: Text.ElideRight
		}
	}
	Component {
		id: sectionHeading
		Rectangle {
			width: parent.width
			height: childrenRect.height
			color: "lightsteelblue"

			Text {
				text: getSectionHeading(section)
				font.bold: true
				font.pixelSize: 20
			}
		}
	}
	ListView {
		id: list
		anchors.fill: parent
		anchors.topMargin: screen.isPortrait ? header.height : 0
		anchors.leftMargin: screen.isPortrait ? 0 : header.width
		model: schedulerDaySortFilterModel
		delegate: schedulerDelegate

		section.property: "job.weekday"
		section.criteria: ViewSection.FullString
		section.delegate: sectionHeading

		spacing: 0
		maximumFlickVelocity: 1500 * SCALEFACTOR
	}
	Header {
		id: header
		anchors.topMargin: 0
		title: "Scheduler"
	}

	function  getSectionHeading(weekday) {
		var weekdays = new Array(7);
		weekdays[0] = "Monday";
		weekdays[1] = "Tuesday";
		weekdays[2] = "Wednesday";
		weekdays[3] = "Thursday";
		weekdays[4] = "Friday";
		weekdays[5] = "Saturday";
		weekdays[6]=  "Sunday";
		var d = new Date();
		var m2fDay = d.getDay() - 1;
		if (m2fDay < 0) {
			m2fDay = 6;
		}
		if (weekday == m2fDay) {
			return "Today" + " (" + weekdays[weekday] + ")";
		} else if (weekday == (m2fDay + 1) % 7) {
			return "Tomorrow" + " (" + weekdays[weekday] + ")";
		} else {
			return weekdays[weekday];
		}
	}
}
