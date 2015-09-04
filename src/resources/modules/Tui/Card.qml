import QtQuick 2.0
import Tui 0.1

View {
	property bool flat: false
	width: Units.dp(300)
	height: Units.dp(250)
	elevation: flat ? 0 : 1
	border.color: flat ? Qt.rgba(0,0,0,0.2) : "transparent"
	radius: fullWidth || fullHeight ? 0 : Units.dp(4)
}
