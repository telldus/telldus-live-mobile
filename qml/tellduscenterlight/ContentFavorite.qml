import Qt 4.7

Content{
	id: contentFavorite

	ListView {
		id: favoritelist
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: parent.width

		model: DeviceListModel {}

		delegate: DeviceElement {
			hideFavorites: true
		}
	}
}
