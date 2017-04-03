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

    signal resolutionChanged(string resolution);

    id: resolutionMenu
    PlasmaComponents.MenuItem {
        text: qsTr("320x240")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("352x240")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("352x288")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("384x288")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("480x480")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("480x576")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("640x368")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("704x408")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("704x576")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("720x576")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("640x480")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("720x480")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("1280x720")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("1920x1080")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("4096×3112")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("no change")
        onClicked: resolutionChanged(text)
    }
    PlasmaComponents.MenuItem {
        text: qsTr("custom")
        onClicked: resolutionChanged(text)
    }

}
