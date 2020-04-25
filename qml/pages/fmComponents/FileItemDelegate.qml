import QtQuick 2.0
import Sailfish.Silica 1.0
import "mimetypeIcons.js" as MimetypeIcons

BackgroundItem {
    id: bgdelegate
    width: parent.width
    height: menuOpen ? contextMenu.height + delegate.height : delegate.height
    property Item contextMenu
    property alias fileIcon: fileIcon
    property bool menuOpen: contextMenu != null && contextMenu.parent === bgdelegate

    function remove() {
        var removal = removalComponent.createObject(bgdelegate)
        var toDelPath = filePath
        removal.execute(delegate,qsTr("Deleting ") + fileName, function() {_fm.resetWatcher(); _fm.remove(toDelPath); busyInd.running = true; })
    }

    function copy() {
        clipboard.clear();
        _fm.moveMode = false;
        clipboard.add(filePath, fileName);
        console.debug("Copying " + filePath)
    }

    function move() {
        clipboard.clear();
        _fm.moveMode = true;
        clipboard.add(filePath, fileName);
        console.debug("Moving " + filePath)
    }

    ListItem {
        id: delegate

        contentHeight: fileLabel.height + fileInfo.height + Theme.paddingSmall
        showMenuOnPressAndHold: false
        menu: myMenu
        visible : {
            if (onlyFolders && fileIsDir) return true
            else if (onlyFolders) return false
            else return true
        }

        function showContextMenu() {
            if (!contextMenu)
                contextMenu = myMenu.createObject(view)
            contextMenu.show(bgdelegate)
        }

        Image
        {
            id: fileIcon
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter
            source: {
                if (fileIsDir) "image://theme/icon-m-folder"
                else MimetypeIcons.returnMimeTypeIcon(_fm,filePath)
            }
        }

        Label {
            id: fileLabel
            anchors.left: fileIcon.right
            anchors.leftMargin: Theme.paddingLarge
            anchors.top: fileInfo.text != "" ? parent.top : undefined
            anchors.verticalCenter: fileInfo.text == "" ? parent.verticalCenter : undefined
            text: fileName //+ (fileIsDir ? "/" : "")
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            width: mSelect.visible ? parent.width - (fileIcon.width + Theme.paddingLarge + Theme.paddingSmall + mSelect.width) : parent.width - (fileIcon.width + Theme.paddingLarge + Theme.paddingSmall)
            truncationMode: TruncationMode.Fade
        }
        Label {
            id: fileInfo
            anchors.left: fileIcon.right
            anchors.leftMargin: Theme.paddingLarge
            anchors.top: fileLabel.bottom
            text: fileIsDir ? fileModified.toLocaleString() : humanSize(fileSize) + ", " + fileModified.toLocaleString()
            color: Theme.secondaryColor
            width:  {
                if (mSelect.visible)
                    parent.width - fileIcon.width - (Theme.paddingLarge + Theme.paddingSmall + Theme.paddingLarge + mSelect.width)
                else
                    parent.width - fileIcon.width - (Theme.paddingLarge + Theme.paddingSmall + Theme.paddingLarge)
            }
            truncationMode: TruncationMode.Fade
            font.pixelSize: Theme.fontSizeTiny
        }
        Switch {
            id: mSelect
            visible: multiSelect
            enabled: visible
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            checked: clipboard.contains(filePath) ? true : false
            onCheckedChanged: {
                if (checked) {
                    clipboard.add(filePath,fileName)
                }
                else {
                    clipboard.rm(filePath)
                }
            }
        }

        onClicked: {
            if(multiSelect)
            {
                mSelect.checked = !mSelect.checked
                return;
            }

            if (fileIsDir) {
                var anotherFM = pageStack.push(Qt.resolvedUrl("../OpenDialog.qml"), {"path": filePath, "_sortField": _sortField, "dataContainer": dataContainer, "selectMode": selectMode, "multiSelect": multiSelect, "lastSavedDir": mainWindow.lastKnownDir});
                anotherFM.fileOpen.connect(fileOpen)
            } else {
                if (!selectMode) openFile(filePath)
                else {
                    fileOpen(filePath);
                    pageStack.pop(dataContainer);
                }
            }
        }
        onPressAndHold: showContextMenu()
    }

    Component {
        id: removalComponent
        RemorseItem {
            id: remorse
            onCanceled: destroy()
        }
    }

    Component {
        id: myMenu
        ContextMenu {
            MenuItem {
                text: qsTr("Select")
                onClicked: {
                    multiSelect = !multiSelect
                    mSelect.checked = !mSelect.checked
                }
            }
            MenuItem {
                text: qsTr("Cut")
                onClicked: {
                    bgdelegate.move();
                }
            }
            MenuItem {
                text: qsTr("Copy")
                onClicked: {
                    bgdelegate.copy();
                }
            }
            MenuItem {
                text: qsTr("Delete")
                onClicked: {
                    bgdelegate.remove();
                }
            }
            MenuItem {
                text: qsTr("Properties")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("FileProperties.qml"), {"path": filePath, dataContainer: dataContainer, "fileIcon": fileIcon.source, "fileSize": humanSize(fileSize), "fileModified": fileModified, "fileIsDir": fileIsDir, "father": page})
                }
            }
        }
    }

}

