/*
  ** 3encode version 3.0
  **
  ** by Leszek Lesner
  ** released under the terms of BSD
  **
  ** Copyright (c) 2013, Leszek Lesner
  ** All rights reserved.
  **
  ** Redistribution and use in source and binary forms, with or without modification,
  ** are permitted provided that the following conditions are met:
  **
  ** Redistributions of source code must retain the above copyright notice,
  ** this list of conditions and the following disclaimer.
  ** Redistributions in binary form must reproduce the above copyright notice,
  ** this list of conditions and the following disclaimer in the documentation
  ** and/or other materials provided with the distribution.
  ** Neither the name of the <ORGANIZATION> nor the names of its contributors
  ** may be used to endorse or promote products derived from this software without
  ** specific prior written permission.
  **
  ** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  ** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  ** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  ** INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  ** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  ** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  ** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  ** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  **/

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import "qml"

Rectangle {
    id: rootRectangle
    width: 480  // Fixed for now
    height: 575
    color: "#C4BDBB"

    function showAbout() {
        aboutView.opacity = 1
    }

    PlasmaComponents.Button {
        id: add2Queue
        text: qsTr("Queue")
        iconSource: "list-add"
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        width: 120
        height: 32
        // TODO: Add to queue
        onClicked: {
            console.log(text.length)
            queueView.queueList.model.append({"source": encodeItem.source,"target": encodeItem.target,"videoCodec": encodeItem.videoCodec,
                                                 "videoBitrate": encodeItem.videoBitrate, "videoResolution": encodeItem.videoResolution,
                                                 "videoAspect": encodeItem.videoAspect, "audioCodec": encodeItem.audioCodec,
                                                 "audioBitrate": encodeItem.audioBitrate, "audioSamplingFreq": encodeItem.audioSamplingFreq,
                                                 "audioChannel": encodeItem.audioChannel, "AudioLanguageChannel": encodeItem.audioLanguageChannel,
                                                 "cmd": encodeItem.cmd})
        }
    }

    EncodeItem {
        id: encodeItem
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.bottomMargin: 15
    }

    PlasmaComponents.Button {
        id: helpButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        width:40
        height:24
        onClicked: helpMenu.open()

        Image {
            anchors.centerIn: parent
            width: parent.width - 2
            //height: parent.height - 1
            source: "qml/img/configure.png"
            smooth: true
        }
    }

    PlasmaComponents.ContextMenu {
        id: helpMenu
        visualParent: helpButton
        PlasmaComponents.MenuItem {
            text: qsTr("Show Command")
            icon: QIcon("terminal")
            onClicked: {
                if (encodeItem.cmdbox.height == 0) {
                    encodeItem.cmdbox.height = 40
                }
                else {
                    encodeItem.cmdbox.height = 0
                }
                encodeItem.cmdbox.toggleShow()
            }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("Show Queue")
            icon: QIcon("evolution-tasks")
            // TODO show Queue here
            onClicked: { queueView.visible = true }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("Show History")
            icon: QIcon("documentation")
            // TODO show History here
            onClicked: {  }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("Show Log")
            icon: QIcon("text-x-changelog")
            // TODO show Log here
            onClicked: {  }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("About")
            icon: QIcon("gtk-about")
            onClicked: showAbout()
        }
    }

    Queue {
        id: queueView
        visible: false
    }

    AboutView {
        id: aboutView
        anchors.centerIn: parent
        opacity: 0
    }

}
