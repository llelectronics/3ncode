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
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: root
    property string videoCodec: "libxvid"
    property string videoBitrate: "777k"
    property string videoResolution: "no change"
    property string videoAspect: "no change"

    // Header to open file and choose container
    Grid {
        id: sourceGrid
        columns: 2
        rows:2
        anchors.top: parent.top
        anchors.topMargin: 15
        width: parent.width - 30
        height: 100
        anchors.left: parent.left
        anchors.leftMargin: 15

        PlasmaComponents.TextField {
            id: openfText
            placeholderText: qsTr("Open source file here")
            anchors.top: parent.top
            anchors.left: parent.left
            width: 350
            height: 32
        }
        PlasmaComponents.Button {
            id: openfBtn
            text: qsTr("Open")
            anchors.left: openfText.right
            anchors.leftMargin: 15
            anchors.verticalCenter: openfText.verticalCenter
            width: 80
            height: 32
            iconSource: "document-open"
        }
        Text {
            id: containerLabel
            text: qsTr("Choose container format:")
            anchors.left: parent.left
            anchors.top: openfText.bottom
            anchors.topMargin: 35
        }

        PlasmaComponents.Button {
            id: containerSelection
            width: 280
            height: 24
            anchors.left: containerLabel.right
            anchors.leftMargin: 25
            anchors.top: openfText.bottom
            anchors.topMargin: 30
            text: "avi"
            iconSource: "go-down"
            onClicked: contMenu.open()
            ContainerList {
                id: contMenu
                visualParent: containerSelection
                onFormatChanged: containerSelection.text = format
            }
        }
    }

    // Video Box
    Rectangle {
        id: summaryVideoRectangle
        color: "white"
        anchors.top: sourceGrid.bottom
        anchors.topMargin: 15
        width: parent.width - 30
        anchors.left: parent.left
        anchors.leftMargin: 15
        height: 50
        radius: 8

        Behavior on height {
            NumberAnimation { duration: 500 }
        }

        Image {
            source: if (summaryVideo.opacity == 1) { return "img/down.png" }
                    else { return "img/up.png" }

            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
        }

        Grid {
            id: summaryVideo
            rows: 2
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width - 15
            height: parent.height - 15
            anchors.verticalCenter: parent.verticalCenter
            Behavior on opacity {
                NumberAnimation { duration: 600 }
            }

            Text {
                id: summaryVideoHeader
                font.bold: true
                text: qsTr("     Video:")
            }
            Text { // codec, resolution, bitrate, aspect ratio
                anchors.left: parent.left
                anchors.leftMargin: 15
                text: "<b>Codec:</b> " + videoCodec + " <b>Bitrate:</b> " + videoBitrate + " <b>Resolution:</b> " +
                      videoResolution + " <b>Aspect:</b> " + videoAspect
            }
        } // Grid Summary Video
        Row {
            id: expandedVideo
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width - 15
            height: parent.height - 15
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0
            spacing: 25

            Behavior on opacity {
                NumberAnimation { duration: 600 }
            }

            Column {
                spacing: 10

                Text {
                    id: expandedVideoHeader
                    font.bold: true
                    text: qsTr("     Video:")
                }
                Image {
                    id: videoIcon
                    source: "img/video-x-generic.png"
                    anchors.top: expandedVideoHeader.bottom
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                Grid {   // Grid for checkboxes
                    id: videoCheckboxes
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    columns: 2
                    rows: 3
                    spacing: 5

                    PlasmaComponents.CheckBox {
                        id: videoDeactivate
                    }
                    Text {
                        text: "Deactivate"
                        anchors.verticalCenter: videoDeactivate.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (videoDeactivate.checked == false) { videoDeactivate.checked = true }
                                else {videoDeactivate.checked = false }
                            }
                        }
                    }
                    PlasmaComponents.CheckBox {
                        id: video2pass
                    }
                    Text {
                        text: "2 Pass"
                        anchors.verticalCenter: video2pass.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (video2pass.checked == false) { video2pass.checked = true }
                                else {video2pass.checked = false }
                            }
                        }
                    }
                    PlasmaComponents.CheckBox {
                        id: videoMultithreading
                    }
                    Text {
                        text: "Multithreading"
                        anchors.verticalCenter: videoMultithreading.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (videoMultithreading.checked == false) { videoMultithreading.checked = true }
                                else {videoMultithreading.checked = false }
                            }
                        }
                    }
                } // Grid for checkboxes
            } // Column for icon and checkboxes
            Column { // Column for Codec, Bitrate, Resolution & Aspect Ratio
                anchors.top: parent.top
                anchors.topMargin: 45
                spacing: 5

                Row {
                    Text {
                        id: videoCodecLabel
                        text: qsTr("Codec:")
                        anchors.verticalCenter: videoCodecSelection.verticalCenter
                        width: 55
                    }

                    PlasmaComponents.Button {
                        id: videoCodecSelection
                        width: 100
                        height: 24
                        text: "libxvid"
                        iconSource: "go-down"
                        anchors.left: videoCodecLabel.right
                        anchors.leftMargin: 15
                        onClicked: videoCodecMenu.open()
                        VideoCodecList {
                            id: videoCodecMenu
                            visualParent: videoCodecSelection
                            onCodecChanged: {
                                videoCodecSelection.text = codec
                                videoCodec = codec
                            }
                        }
                    }
                }
                Row {
                    Text {
                        id: videoBitrateLabel
                        text: qsTr("Bitrate:")
                        width: 55
                        anchors.verticalCenter: videoBitrateSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: videoBitrateSelection
                        width: 100
                        height: 24
                        text: "777k"
                        iconSource: "go-down"
                        anchors.left: videoBitrateLabel.right
                        anchors.leftMargin: 15
                        onClicked: videoBitrateMenu.open()
                        VideoBitrateList {
                            id: videoBitrateMenu
                            visualParent: videoBitrateSelection
                            onBitrateChanged: {
                                if (bitrate != "custom") {
                                    videoBitrateSelection.text = bitrate
                                    videoBitrate = bitrate
                                    videoBitrateCustom.width = 5
                                    videoBitrateCustomHint.opacity = 0
                                    videoBitrateCustom.opacity = 0

                                }
                                else {
                                    videoBitrateSelection.text = bitrate
                                    videoBitrateCustom.opacity = 1
                                    videoBitrateCustom.width = 100
                                    videoBitrateCustomHint.text =  qsTr("Set bitrate")
                                    videoBitrateCustomHint.opacity = 1
                                    videoBitrateCustom.forceActiveFocus()
                                    videoBitrateCustom.focus = true
                                }
                            }

                        } // VideoBitrateList

                    } // Button videoBitrateSelection
                }
                Row {

                    PlasmaComponents.TextField {
                        id: videoBitrateCustom
                        width: 5
                        opacity: 0
                        anchors.verticalCenter: videoBitrateCustomHint.verticalCenter
                        focus: true
                        onAccepted: {
                            videoBitrate = text
                            console.log(videoBitrate)
                            videoBitrateCustomHint.text = qsTr("Bitrate " +  videoBitrate + " set")
                        }
                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                        PlasmaComponents.Button {
                            id: videoBitrateCustomHint
                            anchors.left: videoBitrateCustom.right
                            anchors.leftMargin: 15
                            opacity: 0
                            Behavior on opacity {
                                NumberAnimation { duration : 1800 }
                            }
                            text: qsTr("Set bitrate")
                            onClicked: {
                                videoBitrate = videoBitrateCustom.text
                                text = qsTr("Bitrate " +  videoBitrate + " set")
                            }
                        }
                    } // TextField videoBitrateCustom
                }

                Row {
                    Text {
                        id: videoResolutionLabel
                        text: qsTr("Resolution:")
                        width: 55
                        anchors.verticalCenter: videoResolutionSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: videoResolutionSelection
                        width: 100
                        height: 24
                        text: "no change"
                        iconSource: "go-down"
                        anchors.left: videoResolutionLabel.right
                        anchors.leftMargin: 15
                        onClicked: videoResolutionMenu.open()
                        ResolutionList {
                            id: videoResolutionMenu
                            visualParent: videoResolutionSelection
                            onResolutionChanged: {
                                if (resolution != "custom") {
                                    videoResolutionSelection.text = resolution
                                    videoResolution = resolution
                                    videoResolutionCustom.width = 5
                                    videoResolutionCustomHint.opacity = 0
                                    videoResolutionCustom.opacity = 0

                                }
                                else {
                                    videoResolutionSelection.text = resolution
                                    videoResolutionCustom.opacity = 1
                                    videoResolutionCustom.width = 100
                                    videoResolutionCustomHint.text =  qsTr("Set resolution")
                                    videoResolutionCustomHint.opacity = 1
                                    videoResolutionCustom.forceActiveFocus()
                                    videoResolutionCustom.focus = true
                                }
                            }

                        } // VideoResolutionList

                    } // Button videoResolutionSelection
                }
                Row {
                    PlasmaComponents.TextField {
                        id: videoResolutionCustom
                        width: 5
                        opacity: 0
                        focus: true
                        anchors.verticalCenter: videoResolutionCustomHint.verticalCenter
                        onAccepted: {
                            videoResolution = videoResolutionCustom.text
                            console.log(videoResolution)
                            videoResolutionCustomHint.text = qsTr("Resolution " +  videoResolution + " set")
                        }
                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                        PlasmaComponents.Button {
                            id: videoResolutionCustomHint
                            anchors.left: videoResolutionCustom.right
                            anchors.leftMargin: 15
                            opacity: 0
                            Behavior on opacity {
                                NumberAnimation { duration : 1800 }
                            }
                            text: qsTr("Set resolution")
                            onClicked: {
                                videoResolution = videoResolutionCustom.text
                                text = qsTr("Resolution " +  videoResolution + " set")
                            }
                        }
                    } // TextField videoBitrateCustom
                }
                Row {
                    Text {
                        id: aspectLabel
                        text: qsTr("Aspect:")
                        width: 55
                        anchors.verticalCenter: aspectSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: aspectSelection
                        width: 100
                        height: 24
                        text: "no change"
                        iconSource: "go-down"
                        anchors.left: aspectLabel.right
                        anchors.leftMargin: 15
                        onClicked: aspectMenu.open()
                        AspectList {
                            id: aspectMenu
                            visualParent: aspectSelection
                            onAspectChanged: {
                                aspectSelection.text = aspect
                                videoAspect = aspect
                            }

                        } // aspectList

                    } // Button aspectSelection
                }


            } // Column for Codec, Bitrate, ...

        } // Row Expanded Video
        MouseArea {
            //            anchors.fill: parent  // This does not work as it blocks every mouseclick on the parent later on
            width: parent.width
            height: 50
            hoverEnabled: true

            onEntered: {
                parent.height = 250
                summaryVideo.opacity = 0
                expandedVideo.opacity = 1
            }
            onClicked: {
                if (parent.height == 50) {
                    parent.height = 250
                    summaryVideo.opacity = 0
                    expandedVideo.opacity = 1
                }
                else
                {
                    parent.height = 50
                    summaryVideo.opacity = 1
                    expandedVideo.opacity = 0
                }
            }
        } // MouseArea
    } // summaryVideoRectangle

}
