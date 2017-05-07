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

Dialog {
    id: detailsSettingsPage

    property QtObject dataContainer
    property bool isAudioDialog: false

    onAccepted: {
        if (lang.text == "") lang.text = "not set"
        if (dataContainer) {
            if (isAudioDialog) {
                dataContainer.acodec = codec.value
                dataContainer.abitrate = bitrate.text
                dataContainer.channel = channel.text
                dataContainer.samplerate = sample.value
                dataContainer.lang = lang.text
            }
            else {
                dataContainer.vcodec = codec.value
                dataContainer.vbitrate = bitrate.text
                dataContainer.resolution = resolution.value
                dataContainer.aspect = aspect.value
            }
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
//        PullDownMenu {
//            MenuItem {
//                text: qsTr("About " + appname)
//                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
//            }
//            MenuItem {
//                text: qsTr("Open File")
//                onClicked: pageStack.push(openFileComponent);
//            }
//        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            anchors.fill: parent

            PageHeader {
                title: isAudioDialog ? qsTr("Audio Settings") : qsTr("Video Settings")
            }

            ComboBox {
                id: codec
                property string defaultValue: isAudioDialog ? dataContainer.acodec : dataContainer.vcodec
                label: qsTr("Codec:")
                labelMargin: Theme.paddingMedium
                menu: ContextMenu {
                    Repeater {
                        width: parent.width
                        model: isAudioDialog ? aCodecMenu : vCodecMenu
                        delegate: MenuItem { text: model.text }
                    }
                }
                onCurrentItemChanged: {
                    var selectedValue = isAudioDialog ? aCodecMenu.get(currentIndex).text : vCodecMenu.get(currentIndex).text
                }
                Component.onCompleted: {
                    for (var i = 0; i < (isAudioDialog ? aCodecMenu.count : vCodecMenu.count); i++) {
                        if (isAudioDialog ? aCodecMenu.get(i).text == defaultValue : vCodecMenu.get(i).text == defaultValue) {
                            currentIndex = i
                            break
                        }
                    }
                }

            }

            ACodecMenu { id: aCodecMenu }
            VCodecMenu { id: vCodecMenu }

            TextField {
                id: bitrate
                label: qsTr("Bitrate")
                anchors.leftMargin: Theme.paddingMedium
                placeholderText: qsTr("Set bitrate in kbps")
                text: isAudioDialog ? dataContainer.abitrate : dataContainer.vbitrate
                validator: IntValidator { }
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            TextField {
                id: channel
                label: qsTr("Channel")
                anchors.leftMargin: Theme.paddingMedium
                visible: isAudioDialog
                placeholderText: qsTr("Set number of available channels")
                text: dataContainer.channel
                validator: IntValidator { }
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ComboBox {
                id: sample
                label: qsTr("Sampling Frequency:")
                labelMargin: Theme.paddingMedium
                visible: isAudioDialog
                menu: ContextMenu {
                    MenuItem { text: "22050" }
                    MenuItem { text: "24000" }
                    MenuItem { text: "32000" }
                    MenuItem { text: "44100" }
                    MenuItem { text: "48000" }
                    MenuItem { text: "96000" }
                    MenuItem { text: "192000" }
                }
                currentIndex: {
                    if (dataContainer.samplerate == "22050") return 0
                    else if (dataContainer.samplerate == "24000") return 1
                    else if (dataContainer.samplerate == "32000") return 2
                    else if (dataContainer.samplerate == "44100") return 3
                    else if (dataContainer.samplerate == "48000") return 4
                    else if (dataContainer.samplerate == "96000") return 5
                    else if (dataContainer.samplerate == "192000") return 6
                }
                enabled: {
                    if (codec.value == "libopus") false  // Opus encoding only works with 48khz
                    else true
                }
            }
            TextField {
                id: lang
                label: qsTr("Language Channel")
                anchors.leftMargin: Theme.paddingMedium
                visible: isAudioDialog
                placeholderText: qsTr("Set language channel number")
                text: dataContainer.lang
                validator: IntValidator { }
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ComboBox {
                id: resolution
                label: qsTr("Resolution:")
                labelMargin: Theme.paddingMedium
                visible: !isAudioDialog
                menu: ContextMenu {
                    MenuItem { text: "no change" }
                    MenuItem { text: "320x240" }
                    MenuItem { text: "426x240" }
                    MenuItem { text: "640x360" }
                    MenuItem { text: "854x480" }
                    MenuItem { text: "1280x720" }
                    MenuItem { text: "1920x1080" }
                }
                currentIndex: {
                    if (dataContainer.resolution == "no change") return 0
                    else if (dataContainer.resolution == "320x240") return 1
                    else if (dataContainer.resolution == "426x240") return 2
                    else if (dataContainer.resolution == "640x360") return 3
                    else if (dataContainer.resolution == "854x480") return 4
                    else if (dataContainer.resolution == "1280x720") return 5
                    else if (dataContainer.resolution == "1920x1080") return 6
                }
            }
            ComboBox {
                id: aspect
                label: qsTr("Aspect:")
                labelMargin: Theme.paddingMedium
                visible: !isAudioDialog
                menu: ContextMenu {
                    MenuItem { text: "no change" }
                    MenuItem { text: "1:1" }
                    MenuItem { text: "3:2" }
                    MenuItem { text: "4:3" }
                    MenuItem { text: "16:9" }
                    MenuItem { text: "16:10" }
                }
                currentIndex: {
                    if (dataContainer.aspect == "no change") return 0
                    else if (dataContainer.aspect == "1:1") return 1
                    else if (dataContainer.aspect == "3:2") return 2
                    else if (dataContainer.aspect == "4:3") return 3
                    else if (dataContainer.aspect == "16:9") return 4
                    else if (dataContainer.aspect == "16:10") return 5
                }
            }
        }
    }
}


