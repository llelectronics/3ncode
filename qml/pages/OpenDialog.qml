import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.encode.Encode 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    signal openFile(string path);

    property var path
    property var filter

    FolderListModel {
        id: fileModel
        folder: path
        showDirsFirst: true
        showDotAndDotDot: false
        showOnlyReadable: true
        nameFilters: filter
    }

    function getReadableFileSizeString(fileSizeInBytes) {
        var i = -1;
        var byteUnits = [' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
        do {
            fileSizeInBytes = fileSizeInBytes / 1024;
            i++;
        } while (fileSizeInBytes > 1024);

        return Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i];
    }

    function findBaseName(url) {
        url = url.toString();
        var fileName = url.substring(url.lastIndexOf('/') + 1);
        return fileName;
    }

    function findFullPath(url) {
        url = url.toString();
        var fullPath = url.substring(url.lastIndexOf('://') + 3);
        return fullPath;
    }

    SilicaListView {
        id: view
        model: fileModel
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Open file")
            description: path.toString()
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Show Filesystem Root")
                onClicked: fileModel.folder = "/";
            }
            MenuItem {
                text: qsTr("Show Home")
                onClicked: fileModel.folder = "/home/nemo";
            }
            MenuItem {
                text: qsTr("Show Android SDCard")
                onClicked: fileModel.folder = "/data/sdcard";
            }
            MenuItem {
                text: qsTr("Show SDCard")
                onClicked: fileModel.folder = "/media/sdcard";
                //visible: Util.existsPath("/media/sdcard")
                //Component.onCompleted: console.debug("[DirList] SD Card status: " + Util.existsPath("/media/sdcard"))
            }
            MenuItem {
                id: pasteMenuEntry
                visible: { if (_fm.sourceUrl != "" && _fm.sourceUrl != undefined) return true;
                    else return false
                }
                text: qsTr("Paste") + "(" + findBaseName(_fm.sourceUrl) + ")"
                onClicked: {
                    busyInd.running = true
                    if (_fm.moveMode) {
                        //console.debug("Moving " + _fm.sourceUrl + " to " + findFullPath(fileModel.folder)+ "/" + findBaseName(_fm.sourceUrl));
                        //if (!_fm.moveFile(_fm.sourceUrl,findFullPath(fileModel.folder) + "/" + findBaseName(_fm.sourceUrl))) err = true;
                        _fm.moveFile(_fm.sourceUrl,findFullPath(fileModel.folder) + "/" + findBaseName(_fm.sourceUrl))
                    }
                    else {
                        //console.debug("Copy " + _fm.sourceUrl + " to " + findFullPath(fileModel.folder)+ "/" + findBaseName(_fm.sourceUrl));
                        //if (!_fm.copyFile(_fm.sourceUrl,findFullPath(fileModel.folder) + "/" + findBaseName(_fm.sourceUrl))) err = true;
                        _fm.copyFile(_fm.sourceUrl,findFullPath(fileModel.folder) + "/" + findBaseName(_fm.sourceUrl))
                    }
                }
            }
        }

        delegate: BackgroundItem {
            id: delegate
            width: parent.width
            //height: fileDetailsLbl.visible ? fileNameLbl.height + fileDetailsLbl.height : Theme.itemSizeSmall
            property var dHeight: fileDetailsLbl.visible ? fileNameLbl.height + fileDetailsLbl.height : Theme.itemSizeSmall
            height: menuOpen ? contextMenu.height + dHeight : dHeight
            property Item contextMenu
            property bool menuOpen: contextMenu != null && contextMenu.parent === delegate

            function showContextMenu() {
                if (!contextMenu)
                    contextMenu = myMenu.createObject(view)
                contextMenu.show(delegate)
            }

            function remove() {
                var removal = removalComponent.createObject(delegate)
                if (fileIsDir) removal.execute(dItem,qsTr("Deleting ") + fileName, function() { _fm.removeDir(filePath); })
                else removal.execute(dItem,qsTr("Deleting ") + fileName, function() { _fm.remove(filePath); })
            }

            function copy() {
                _fm.sourceUrl = filePath
                //console.debug(_fm.sourceUrl)
            }

            function move() {
                _fm.moveMode = true;
                copy();
            }

            Item {
                id: dItem
                anchors.fill: parent

                Image
                {
                    id: fileIcon
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingSmall
                    y: fileDetailsLbl.visible ? ((fileNameLbl.height + fileNameLbl.y + fileDetailsLbl.height) / 2) - height / 2  : ((fileNameLbl.height + fileNameLbl.y) / 2) - height / 2
                    source: {
                        if (fileIsDir) "image://theme/icon-m-folder"
                        else if (_fm.getMime(filePath).indexOf("video") !== -1) "image://theme/icon-m-file-video"
                        else if (_fm.getMime(filePath).indexOf("audio") !== -1) "image://theme/icon-m-file-audio"
                        else if (_fm.getMime(filePath).indexOf("image") !== -1) "image://theme/icon-m-file-image"
                        else if (_fm.getMime(filePath).indexOf("text") !== -1) "image://theme/icon-m-file-document"
                        else if (_fm.getMime(filePath).indexOf("pdf") !== -1) "image://theme/icon-m-file-pdf"
                        else if (_fm.getMime(filePath).indexOf("android") !== -1) "image://theme/icon-m-file-apk"
                        else if (_fm.getMime(filePath).indexOf("rpm") !== -1) "image://theme/icon-m-file-rpm"
                        else "image://theme/icon-m-document"
                    }
                    //                    Component.onCompleted: {
                    //                        console.debug("File " + fileName + " has mimetype: " + _fm.getMime(filePath))
                    //                    }
                }

                Label {
                    id: fileNameLbl
                    text: fileName
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.WordWrap
                    width: parent.width - (fileIcon.width + Theme.paddingMedium * 2)
                    anchors.left: fileIcon.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    id: fileDetailsLbl
                    anchors.top: fileNameLbl.bottom
                    text:  fileIsDir ? qsTr("directory") : getReadableFileSizeString(fileSize) + ", " + fileModified
                    color: Theme.secondaryColor
                    truncationMode: TruncationMode.Fade
                    width: parent.width - (fileIcon.width + Theme.paddingMedium * 2)
                    anchors.left: fileIcon.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingMedium
                }
                Component.onCompleted: {
                    if (!fileDetailsLbl.visible) fileNameLbl.anchors.verticalCenter = fileIcon.verticalCenter
                    else fileNameLbl.anchors.top = dItem.top
                }
            }

            onClicked: {
                if (fileIsDir) {
                    var anotherFM = pageStack.push(Qt.resolvedUrl("OpenDialog.qml"), {"path": filePath, "filter": filter});
                    anotherFM.openFile.connect(openFile)
                } else {
                    openFile(filePath)
                }
            }
            onPressAndHold: showContextMenu()
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
                        text: qsTr("Cut")
                        onClicked: {
                            delegate.move();
                        }
                    }
                    MenuItem {
                        text: qsTr("Copy")
                        onClicked: {
                            delegate.copy();
                        }
                    }
                    MenuItem {
                        text: qsTr("Delete")
                        onClicked: {
                            delegate.remove();
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator { flickable: view }
    }
    Connections {
        target: _fm
        onSourceUrlChanged: {
            if (_fm.sourceUrl != "" && _fm.sourceUrl != undefined) {
                pasteMenuEntry.visible = true;
            }
            else pasteMenuEntry.visible = false;
        }
        onCpResultChanged: {
            if (!_fm.cpResult) {
                var message = qsTr("Error pasting file ") + _fm.sourceUrl
                console.debug(message);
                mainWindow.infoBanner.parent = parent
                mainWindow.infoBanner.anchors.top = parent.top
                infoBanner.showText(message)
            }
            else {
                _fm.sourceUrl = "";
                var message = qsTr("File operation succeeded")
                console.debug(message);
//                mainWindow.infoBanner.parent = parent
//                mainWindow.infoBanner.anchors.top = parent.top
                infoBanner.showText(message)
            }
            busyInd.running = false;
        }
    }

    BusyIndicator {
        id: busyInd
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
    }
}
