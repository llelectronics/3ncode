/*
  ** Part of 3encode version 3.0
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

PlasmaComponents.ContextMenu {

    signal codecChanged(string codec);

    id: videoCodecMenu
    PlasmaComponents.MenuItem {
        text: qsTr("flv")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("h263")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("libx264")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("huffyuv")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mjpeg")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mpeg1video")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mpeg2video")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mpeg4")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("msmpeg4v1")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("msmpeg4v2")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("svq1")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("libdirac")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("libtheora")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("wmv1")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("wmv2")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("libxvid")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("libvpx")
        onClicked: codecChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("--")
    }
    PlasmaComponents.MenuItem {
        text: qsTr("copy")
        onClicked: codecChanged(text)
    }

}
