import QtQuick 1.0

Content{
	id: contentFavorite

	ListView {
		id: favoritelist
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: parent.width
		spacing: 10

		model: favoriteModel

		delegate: DeviceElement {
			hideFavoriteToggle: true
		}
	}
}
