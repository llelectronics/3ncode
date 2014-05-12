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
        id: aboutPage
        width: parent.width -(parent.width/8)
        height: 250
        anchors.centerIn: parent
        color: "#C4BDBB"
        border.color: "blue"
        border.width: 1
        radius: 8
        z:100  // Above all
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 450 }
        }

        PlasmaComponents.Button {
            anchors.right: parent.right
            anchors.top: parent.top
            text: "X"
            onClicked: parent.opacity = 0
        }

        Image {
            id: aboutLogo
            source: "img/encode.png"
            x: 25
            y: 40
        }
        Text {
            id: aboutTxt
            text: qsTr("<b>Encode 3.0</b><br />released under the terms of <br /><b>BSD (3-clause)</b><br /> by Leszek Lesner \
<br /><br />This application allows you<br>to encode audio and video files.<br /><br />\
It uses the <b>ffmpeg</b><br />commandline tool as its backend.")
            anchors.left: aboutLogo.right
            anchors.leftMargin: 20
            anchors.top: aboutLogo.top
        }
        MouseArea {
            anchors.fill: aboutPage
            onClicked: {
                aboutPage.opacity = 0
            }
        }
    }
