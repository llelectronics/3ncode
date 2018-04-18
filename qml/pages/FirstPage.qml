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
import harbour.encode.Encode 1.0

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

    onSourceFileChanged: {
        targetFile = sourceFile.substr(0, sourceFile.lastIndexOf('.')) + "." + container.value || sourceFile;
    }

    onContainerChanged: {
        targetFile = sourceFile.substr(0, sourceFile.lastIndexOf('.')) + "." + container.value || sourceFile;
    }

    function createFFmpegCommand() {
        var cmd = " -i \"" + sourceFile + "\""

        // Audio conversions first
        // example ffmpeg cmd:
        // ffmpeg -i ''  -vn -ab 128k -ar 44100 -b 2000k -f wav -vcodec libxvid -ac 2 -acodec pcm_s16le '.wav'
        if (isAudioOnly) {
            cmd += " -vn"
        }
        cmd += " -ab " + abitrate + "k"
        cmd += " -ar " + samplerate
        cmd += " -ac " + channel
        cmd += " -acodec " + acodec
        if (lang != "not set") {
            cmd += " -map 0:" + audioLanguageChannel
        }

        //Video conversions second
        //example ffmpeg cmd:
        // ffmpeg -i ''  -ab 128k -ar 44100 -b 2000k -f avi -vcodec libxvid -ac 2 -acodec libmp3lame '.avi'
        if (!isAudioOnly) {
            cmd += " -b " + vbitrate + "k"
            cmd += " -vcodec " + vcodec
            if (resolution != "no change") {
                cmd += " -s " + resolution
            }
            if (aspect != "no change") {
                cmd += " -aspect " + aspect
            }
            // Always optimal thread usage
            cmd += " -threads 0"

        }

        // 2 Pass makes no sense on a mobile phone as the CPUs are usually painfully slow
//        if (video2pass.checked) {
//            cmdpass1 = cmd + " -y -pass 1"
//            cmdpass1 += " \"" + savefText.text + "\""
//            cmdpass2 = cmd + " -y -pass 2"
//            cmdpass2 += " \"" + savefText.text + "\""
//            // 2 Pass Output file
//            cmd = cmdpass1 + " && " + cmdpass2
//        }
//        else {
            // Output file
            cmd += " \"" + targetFile + "\""
//        }
        //console.log(cmd) //DEBUG
        return cmd
    }


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About ") + appname
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
                onClicked: pageStack.push(Qt.resolvedUrl("DetailsSettings.qml"), { dataContainer: page } )
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
                        text: qsTr("Bitrate: ") + vbitrate + "k"
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

                onClicked: pageStack.push(Qt.resolvedUrl("DetailsSettings.qml"), { dataContainer: page, isAudioDialog: true } )
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
                        text: qsTr("Bitrate: ") + abitrate + "k"
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
                enabled: (sourceFile != "" && targetFile != "" && container.value != "") ? true : false
                Image {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://theme/icon-m-shuffle"
                    height: parent.height - Theme.paddingSmall
                    width: height
                }
                onClicked: {
                    busy.running = true
                    busy.visible = true
                    statusText = qsTr("Encoding file.\nThis might take a while...")
                    console.debug("Encode ffmpeg command: " + createFFmpegCommand())
                    encodeProcess.cmd = createFFmpegCommand();
                    encodeProcess.runFFmpeg();
                }
            }
        }
    }
    Component {
        id: openFileComponent
        OpenDialog {
            path: StandardPaths.videos
            filter: mainWindow.videoFilter
            onOpenFile: {
                //console.debug("Try loading playlist " + path);
                sourceFile = path;
                pageStack.pop(page);
            }
        }
    }
    EncodeProcess {
        id: encodeProcess
    }

    Connections {
        target: encodeProcess
        onSuccess: {
            busy.running = false
            busy.visible = false
            isSuccess = true
            statusText = qsTr("Encoding successful.\nFile saved to ") + targetFile
        }

        onError: {
            busy.running = false
            isError = true
            if (encodeProcess.errorOutput != "") {
                statusText = encodeProcess.errorOutput
            }
        }
    }

    Rectangle {
        color: "black"
        opacity: 0.60
        anchors.fill: parent
        visible: {
            if (busy.running) return true;
            else if (isError) return true;
            else if (isSuccess) return true;
            else return false;
        }
        MouseArea {
            anchors.fill: parent
            // Just to catch all clicks
        }
    }
    BusyIndicator {
        id: busy
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
        running: false
        visible: false
    }
    Image {
        id: successImg
        source: "image://theme/icon-l-acknowledge"
        width: Theme.itemSizeLarge
        height: width
        anchors.centerIn: parent
        visible: isSuccess
    }
    TextArea {
        id: statusLbl
        background: null
        text: statusText
        anchors.top: {
            if (busy.running) busy.bottom
            else if (isSuccess) successImg.bottom
            else parent.top
        }
        anchors.bottomMargin: Theme.paddingLarge
        font.pixelSize: Theme.fontSizeMedium
        width: parent.width
        height: busy.running ? (parent.height / 3) : (parent.height - dismissBtn.height - Theme.paddingLarge * 2)
        visible: busy.running || isError || isSuccess
        wrapMode: TextEdit.WordWrap
        readOnly: true
    }
    Button {
        id: dismissBtn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Dismiss")
        onClicked: { isError = false; isSuccess = false; }
        visible: isError || isSuccess
    }
    IconButton {
        icon.source: "image://theme/icon-m-play"
        anchors.bottom: successImg.top
        anchors.bottomMargin: Theme.paddingMedium
        visible: isSuccess
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: Qt.openUrlExternally(targetFile)
    }
}


