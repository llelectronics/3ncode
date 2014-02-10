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
    id: convertAnimPage
    width: parent.width -(parent.width/8)
    height: 250
    anchors.centerIn: parent
    color: "#C4BDBB"
    border.color: "blue"
    border.width: 1
    radius: 8
    z:100  // Above all
    property string outputfile

    Behavior on opacity {
        NumberAnimation { target: convertAnimPage; property: "opacity"; duration: 250; easing.type: Easing.InOutQuad }
    }

    function animationStart() {
        animate.start()
        if (successImg != 0) successImg = 0
    }
    function animationStop() {
        animate.stop()
    }

    function success() {
        animationStop()
        successImg.opacity = 1
        animText.text = "Encoding " + outputfile + " finished !"
    }

    function minimize() {
        console.log("Minimize clicked")
        rootRectangle.showQueueButton();
        convertAnimPage.opacity = 0;
    }

//    MouseArea {
//        anchors.fill: parent
//        onClicked: convertAnimPage.opacity = 0
//    }

    PlasmaComponents.Button {
        id: closeAnimBtn
        anchors.right: parent.right
        anchors.top: parent.top
        text: "X"
        onClicked: parent.opacity = 0
        visible: {
            if (successImg.opacity != 0) return true
            else return false
        }
    }
    PlasmaComponents.Button {
        anchors.right: parent.right
        anchors.top: parent.top
        text: " "
        onClicked: minimize()
        visible: !closeAnimBtn.visible
    }

    Image {
        id: animLogo
        source: "img/convert.png"
        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
        height: 128
        width: 128
    }
    Image {
        id: successImg
        anchors.right: animLogo.right
        anchors.bottom: animLogo.bottom
        height: 64
        width: 64
        source: "img/success.png"
        opacity: 0
        Behavior on opacity {
            NumberAnimation { target: successImg; property: "opacity"; duration: 500; easing.type: Easing.InOutBounce }
        }
    }
    Text {
        id: animText
        anchors.top: animLogo.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        //width: parent.width - 25
        elide: Text.ElideMiddle
        font.bold: true
        text: outputfile ? "Encoding " + outputfile : "Encoding "
    }
//    Text {
//        id: animText
//        anchors.left: encText.right
//        anchors.verticalCenter: encText.verticalCenter
//        font.bold: true
//    }



    PlasmaComponents.Button {
        id: openBtn
        anchors.top: animText.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Open File")
        opacity: successImg.opacity
        onClicked: Qt.openUrlExternally(outputfile)
    }

    PlasmaComponents.Button {
        id: abortBtn
        anchors.top: animText.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Abort Encoding")
        opacity: !openBtn.opacity
        onClicked: rootRectangle.abortEncode()
    }

    ParallelAnimation {
        id: animate
        NumberAnimation {
            target: animLogo
            properties: "rotation"
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1500
            //easing {type: Easing.OutBack; overshoot: 500}
        }
        SequentialAnimation {
            PropertyAction { target: animText; property: "text"; value: animText.text }
            // Just a useless numberanimation for duration pause in text animation
            NumberAnimation { target: animText; property: "anchors.topMargin"; to: 15; duration: 1500 }
            PropertyAction { target: animText; property: "text"; value: animText.text + " ." }
            NumberAnimation { target: animText; property: "anchors.topMargin"; to: 15; duration: 1500 }
            PropertyAction { target: animText; property: "text"; value: animText.text + " .." }
            NumberAnimation { target: animText; property: "anchors.topMargin"; to: 15; duration: 1500 }
            PropertyAction { target: animText; property: "text"; value: animText.text + " ..." }
            NumberAnimation { target: animText; property: "anchors.topMargin"; to: 15; duration: 1500 }
            loops: Animation.Infinite
        }
    }

}
