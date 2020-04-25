import QtQuick 2.0
import Sailfish.Silica 1.0

DockedPanel {
       id: multiSelectBar

       width: parent.width
       height: Theme.itemSizeSmall + Theme.paddingSmall

       dock: Dock.Bottom
       open: (!ytView.atYEnd) && (!searchHistoryDrawer.open)

       Rectangle {
           anchors.fill: parent
           color: Theme.overlayBackgroundColor
           opacity: 0.8
       }

       Row {
           anchors.centerIn: parent
           spacing: (parent.width - 4*cutBtn.width) / 5
           IconButton {
               id: cutBtn
               icon.source: "image://theme/icon-m-flip"
               onClicked: {
                   console.log("Cut")
                   _fm.moveMode = true;
                   multiSelect = false
               }
           }
           IconButton {
               id: cpBtn
               icon.source: "image://theme/icon-m-clipboard";
               onClicked: {
                   console.log("Copy")
                   _fm.moveMode = false;
                   multiSelect = false
               }
           }
           IconButton {
               id: rmBtn
               icon.source: "image://theme/icon-m-delete"
               onClicked: {
                   console.log("Delete")
                   remorseRemove.execute(qsTr("Deleting %1 files").arg(clipboard.count) ,
                                         function() {
                                             _fm.resetWatcher();
                                             for (var i=0; i<clipboard.count; i++) {
                                                 var curPath = clipboard.get(i).source
                                                 console.log("Deleting " + curPath + " with name " + clipboard.get(i).name);
                                                 busyInd.running = true;
                                                 _fm.remove(curPath);
                                             }
                                             multiSelect = false
                                             clipboard.clear();
                                             refresh();
                                         } )
               }
           }
           IconButton {
               id: cancelBtn
               icon.source: "image://theme/icon-m-cancel"
               onClicked: {
                   console.log("Cancel")
                   multiSelect = false
                   clipboard.clear();
                   refresh()
               }
           }
       }
   }
