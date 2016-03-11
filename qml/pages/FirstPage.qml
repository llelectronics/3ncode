/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    property alias container: container.value
    property bool isAudioOnly: false

    // Video settings ///
    property string vcodec
    property string vbitrate
    property string resolution
    property string aspect
    // Audio settings ///
    property string acodec
    property string abitrate
    property string channel
    property string samplerate
    property string lang

    property string sourceFile
    property string targetFile


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About " + appname)
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Open File")
                onClicked: pageStack.push(openFileComponent);
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge * 2
            PageHeader {
                title: qsTr("Encode")
            }
            Label {
                id: sourceFileLbl
                text: sourceFile
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                truncationMode: TruncationMode.Fade
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingLarge
                wrapMode: Text.WordWrap
            }
            ValueButton {
                id: container
                label: qsTr("Target Container:")
                labelMargin: Theme.paddingLarge
                onClicked: pageStack.push(Qt.resolvedUrl("ContainerPage.qml"), {dataContainer: page});
            }
            BackgroundItem {
                id: videoItem
                visible: !isAudioOnly

                width: parent.width
                height: vColumn.height + vLbl.height
                Label {
                    id: vLbl
                    text: qsTr("Video")
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    color: Theme.highlightColor
                    x: Theme.paddingLarge
                }
                Column {
                    id: vColumn
                    anchors.top: vLbl.bottom
                    x: Theme.paddingLarge
                    Label {
                        id: vCodecLbl
                        text: qsTr("Codec: ") + vcodec
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: vBitrateLbl
                        text: qsTr("Bitrate: ") + vbitrate
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: vResolutionLbl
                        text: qsTr("Resolution: ") + resolution
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        text: qsTr("Aspect Ratio: ") + aspect
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                }
                Image {
                    id: vIcon
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-video"
                    width: Theme.iconSizeLarge
                    height: width
                }
            }

            BackgroundItem {
                id: audioItem
                height: aColumn.height + aLbl.height

                Label {
                    id: aLbl
                    text: qsTr("Audio")
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    color: Theme.highlightColor
                }
                Column {
                    id: aColumn
                    anchors.top: aLbl.bottom
                    x: Theme.paddingLarge
                    Label {
                        id: aCodecLbl
                        text: qsTr("Codec: ") + acodec
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: aBitrateLbl
                        text: qsTr("Bitrate: ") + abitrate
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: aChannelLbl
                        text: qsTr("Channel(s): ") + channel
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: aSampleRateLbl
                        text: qsTr("Samplerate: ") + samplerate
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                    Label {
                        text: qsTr("Language: ") + lang
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                }
                Image {
                    id: aIcon
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-music"
                    width: Theme.iconSizeLarge
                    height: width
                }
            }
            Button {
                text: qsTr("Encode")
                preferredWidth: parent.width - (Theme.paddingLarge * 2)
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-shuffle"
                    height: parent.height - Theme.paddingSmall
                    width: height
                }
            }
        }
    }
    Component {
        id: openFileComponent
        OpenDialog {
            path: StandardPaths.videos
            filter: ["*.mp4", "*.mp3", "*.mkv", "*.ogg", "*.ogv", "*.flac", "*.wav", "*.m4a", "*.flv", "*.webm", "*.oga", "*.avi", "*.mov", "*.3gp", "*.mpg", "*.mpeg", "*.wmv", "*.wma", "*.dv", "*.m2v", "*.asf", "*.nsv"]
            onOpenFile: {
                //console.debug("Try loading playlist " + path);
                sourceFile = path;
                pageStack.pop();
            }
        }
    }
}


