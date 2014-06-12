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
    property string outFile
    property string homeDir

    signal encodeCmd(string cmd, string outputFile)
    signal openFile();
    signal saveFile(string filename);
    signal abortEncode();
    signal openLogClicked();

    function setBgColor(colorCode) {
	rootRectangle.color = colorCode
    }
    
    function showAbout() {
        aboutView.opacity = 1
    }
    function showError(errtxt) {
        animView.closeAnim()
	queueView.queueList.model.remove(0)  // Make sure to remove failed jobs
	queueView.finished=true // Make sure queueView can work
        errorView.opacity = 1.0
        errorView.txt = errorView.txt + "\n" + errtxt
    }
    function showEncodeAnimaton() {
        animView.opacity = 1
        animView.animationStart()
    }
    function successEncode() {
        animView.success()
        queueView.finishedEncode()
    }
    function hideEncodeAnimation() {
        animView.animationStop()
        animView.opacity = 0
    }
    function sourceFilename(filename) {
        encodeItem.sourceFilename = filename
    }
    function targetFilename(filename) {
        encodeItem.targetFilename = filename
    }
    function showQueueButton() {
        console.log("Show queue Button now")
        queueButton.opacity = 1
    }
    function setHomeDir(dir) {
        homeDir = dir
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
            //console.log(text.length)
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
        onEncodeClicked: {
            if (queueView.queueList.count == 0) {
                queueView.queueList.model.append({"source": encodeItem.source,"target": encodeItem.target,"videoCodec": encodeItem.videoCodec,
                                                     "videoBitrate": encodeItem.videoBitrate, "videoResolution": encodeItem.videoResolution,
                                                     "videoAspect": encodeItem.videoAspect, "audioCodec": encodeItem.audioCodec,
                                                     "audioBitrate": encodeItem.audioBitrate, "audioSamplingFreq": encodeItem.audioSamplingFreq,
                                                     "audioChannel": encodeItem.audioChannel, "AudioLanguageChannel": encodeItem.audioLanguageChannel,
                                                     "cmd": encodeItem.cmd});
                outFile = queueView.queueList.model.get(0).target
                queueView.encodeNext();
                //encodeCmd(ffmpegCmd,outputFile);
                //showEncodeAnimaton();
            }
            else add2Queue.clicked()

        }
        onOpenFileClicked: {
            openFile();
        }
        onSaveFileClicked: {
            saveFile(fileName);
        }
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
                    encodeItem.cmdbox.height = 80
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
            onClicked: {
                logViewer.readTxt(homeDir + "/encode_history.log")
                logViewer.visible = true
            }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("Show Log")
            icon: QIcon("text-x-changelog")
            // TODO show Log here
            onClicked: {
                logViewer.readTxt(homeDir + "/encode.log")
                logViewer.visible = true
            }
        }
        PlasmaComponents.MenuItem {
            text: qsTr("About")
            icon: QIcon("gtk-about")
            onClicked: showAbout()
        }
    }

    PlasmaComponents.Button {
        id: queueButton
        anchors.left: helpButton.right
        anchors.leftMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        width:40
        height:24
        opacity: 0
        Image {
            anchors.centerIn: parent
            width: parent.height
            height: parent.height
            smooth: true
            source: "qml/img/convert.png"
        }
        onClicked: {
            animView.opacity = 1
            queueButton.opacity = 0
        }
    }

    Queue {
        id: queueView
        visible: false
    }

    LogView {
        id : logViewer
        visible: false
    }   
    ConvertAnimView {
        id: animView
        opacity: 0
        outputfile: outFile
    }
    ErrorView {
        id: errorView
        opacity: 0
        width: parent.width -(parent.width/8)
        height: 250
        Behavior on opacity {
            NumberAnimation { target: errorView; property: "opacity"; duration: 250; easing.type: Easing.InOutQuad }
        }
        onOpenLogClicked: rootRectangle.openLogClicked()
    }

    AboutView {
        id: aboutView
        anchors.centerIn: parent
        opacity: 0
    }

}
