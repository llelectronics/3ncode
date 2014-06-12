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
    id: errorPage
    width: parent.width -(parent.width/8)
    height: {
        if (errorText.paintedHeight > 250) return errorText.paintedHeight
        else return 250
    }
    
    signal openLogClicked()

    anchors.centerIn: parent
    color: parent.color
    border.color: "blue"
    border.width: 1
    radius: 8
    property alias txt: errorText.text

    MouseArea {
        enabled: errorPage.opacity === 1
        anchors.fill: errorPage
        onClicked: { errorPage.opacity = 0 }
    }

    PlasmaComponents.Button {
            anchors.right: parent.right
            anchors.top: parent.top
            text: "X"
            onClicked: parent.opacity = 0
        }

    Image {
        id: errorLogo
        source: "img/error.png"
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 25
        height: 64
        width: 64
    }
    Flickable {
        id: flick
        width: parent.width - (15 + 25 + errorLogo.width)
        height: parent.height - (25*3)
        anchors.left: errorLogo.right
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 25
        contentHeight: errorText.paintedHeight
        PlasmaComponents.TextArea {
            id: errorText
            anchors { right: parent.right; rightMargin: 8; left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
            anchors.fill: parent
            focus: true
            wrapMode: TextEdit.WordWrap
            font.bold: true
            readOnly: true
            text: "Error occured"
        }
    }
    PlasmaComponents.Button {
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.top: flick.bottom
            anchors.topMargin: 15
            text: qsTr("Open Log")
            onClicked: openLogClicked()
        }
}
