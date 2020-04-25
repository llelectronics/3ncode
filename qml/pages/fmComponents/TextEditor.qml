import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: texteditPage

    allowedOrientations: mainWindow.allowedOrientations

    property string fileName

    property bool loaded: false

    onStatusChanged: {
        if (status === PageStatus.Active) {
            _fileio.read(fileName)
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + dataPanel.height + Theme.paddingMedium

        PullDownMenu {
            MenuItem {
                text: qsTr("Save")
                onClicked: {
                    _fileio.write(fileName, textData.text)
                }
            }
        }

        PageHeader {
            id: header
            title: findBaseName(fileName)
            width: parent.width
        }

        BusyIndicator {
            size: BusyIndicatorSize.Small
            anchors.verticalCenter: header.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            visible: !loaded
            running: visible
        }

        Column {
            id: dataPanel
            width: parent.width
            anchors.top: header.bottom
            clip: true

            TextArea {
                id: textData
                anchors.left: parent.left
                width: parent.width
                font.family: "monospace"
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                labelVisible: false
                background: Item { visible: false }
            }

        }

    }

    Connections {
        target: _fileio
        onTxtDataChanged: {
            textData.text = _fileio.txtData();
            if (textData.text !== "") loaded = true
        }
    }

}
