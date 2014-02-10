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

Rectangle {
    id: queueRectangle
    anchors.fill: parent
    color: parent.color
    property alias queueList: queueList
    property bool finished: true

    QueueList { id: queueList }

    function encodeNext() {
        if (queueList.model.count > 0 && finished != false) {
            rootRectangle.encodeCmd(queueList.model.get(0).cmd,queueList.model.get(0).target);
            rootRectangle.outFile = queueList.model.get(0).target;
            finished = false;
        }
    }

    function finishedEncode() {
        // Assume item 0 is finished
        queueList.model.remove(0)
        finished = true
        encodeNext()
    }


    PlasmaComponents.Button {
        id: helpButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        width:32
        height:32
        onClicked: queueRectangle.visible = false

        Image {
            anchors.centerIn: parent
            source: "img/left.png"
            smooth: true
        }
    }

    Item {
        id:toolbox
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 60
        width: parent.width
        PlasmaComponents.Button {
            id: encodeBtn
            anchors.horizontalCenter: parent.horizontalCenter
            width:140
            height: 48
            enabled: finished
            iconSource: "file://img/encode-btn.png"
            Image {
                id: icon
                width: 48
                height: 48
                source: "img/encode-btn.png"
            }
            Text {
                anchors.left: icon.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("<b>Encode</b>")
            }
            onClicked: {
                //console.log(queueList.model.count) //DEBUG
                for (var i = 0; i < queueList.model.count; i++) {
                    console.log(queueList.model.get(i).cmd)  // Run all at once
                }
            } // Might be better to run encoding process one by one and delete every entry one by one ?
        }

    }


    AboutView {
        id: aboutView
        anchors.centerIn: parent
        opacity: 0
    }

}
