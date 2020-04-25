import QtQuick 2.0
import Sailfish.Silica 1.0

DockedPanel {

    property QtObject viewer

    width: (viewer.photo.width > imgControls.childrenRect.width) ? viewer.photo.width : imgControls.childrenRect.width
    height: imgControls.height + Theme.paddingLarge
    contentHeight: height
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        anchors.fill: parent
        color: Theme.overlayBackgroundColor
        opacity: 0.6
    }

    Row {
        id: imgControls
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge
        //visible: !viewer.scaled
        IconButton {
            id: prevImg
            icon.source: "image://theme/icon-m-back"
            onClicked: {
                viewer.resetScale();
                viewer.active = false;
                viewer.source = fileModel.get(blocker.getCurIdx() - 1, "fileURL")
                viewer.active = true;
            }
        }
        Button {
            id: openImgExternally
            text: qsTr("Open externally")
            onClicked: {
                mainWindow.infoBanner.parent = page
                mainWindow.infoBanner.anchors.top = page.top
                mainWindow.infoBanner.showText(qsTr("Opening..."));
                Qt.openUrlExternally(viewer.source)
            }
        }
        IconButton {
            id: nextImg
            icon.source: "image://theme/icon-m-forward"
            onClicked: {
                viewer.resetScale();
                viewer.active = false;
                viewer.source = fileModel.get(blocker.getCurIdx() + 1, "fileURL")
                viewer.active = true;
            }
        }
    }
}
