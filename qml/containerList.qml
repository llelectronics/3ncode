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

    signal formatChanged(string format);

    id: containerMenu
    PlasmaComponents.MenuItem {
        text: qsTr("== Video ==")
    }
    PlasmaComponents.MenuItem {
        text: qsTr("3gp")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("asf")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("avi")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mov")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mp4")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mkv")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mpeg")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("ogv")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("flv")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("webm")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("wmv")
        onClicked: formatChanged(text)
    }
    // Audio Codecs here //
    PlasmaComponents.MenuItem {
        text: qsTr("== Audio ==")
    }
    PlasmaComponents.MenuItem {
        text: qsTr("aac")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("ac3")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("flac")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mp2")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("mp3")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("ogg")
        onClicked: formatChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("wav")
        onClicked: formatChanged(text)
    }

}
