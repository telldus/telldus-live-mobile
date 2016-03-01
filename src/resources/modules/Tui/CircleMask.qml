import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
	id: item

	property alias source: mask.source

	Rectangle {
		id: circleMask
		anchors.fill: parent

		smooth: true
		visible: false

		radius: Math.max(width/2, height/2)
	}

	OpacityMask {
		id: mask

		anchors.fill: parent
		maskSource: circleMask
	}
}
