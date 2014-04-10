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
    property string source: openfText.text
    property string target: savefText.text
    property string videoCodec: "libxvid"
    property string videoBitrate: "777k"
    property string videoResolution: "no change"
    property string videoAspect: "no change"
    property string audioCodec: "libmp3lame"
    property string audioBitrate: "128k"
    property string audioSamplingFreq: "44100"
    property string audioChannel: "2"
    property string audioLanguageChannel: "not set"
    property alias cmdbox: cmdbox
    property string cmd: cmdText.text
    property alias sourceFilename: openfText.text
    property alias targetFilename: savefText.text

    signal encodeClicked(string ffmpegCmd, string outputFile);
    signal openFileClicked();
    signal saveFileClicked(string fileName);

    // Header to open file and choose container
    Grid {
        id: sourceGrid
        columns: 2
        rows:2
        //anchors.top: parent.top
        //anchors.topMargin: 15
        width: parent.width - 30
        height: 100
        //anchors.left: parent.left
        //anchors.leftMargin: 15

        // Check Container and set some audio and video default codecs here
        function checkFormatandSetCodecs(format) {
            if (format === "avi") {
                activateVideo()
                videoCodec = "libxvid"
                videoCodecSelection.text = "libxvid"
                audioCodec ="libmp3lame"
                audioCodecSelection.text = "libmp3lame"
            }
            else if (format === "mp4" || format === "mkv") {
                activateVideo()
                videoCodec = "libx264"
                videoCodecSelection.text = "libx264"
                audioCodec = "libfaac"
                audioCodecSelection.text = "libfaac"
            }
            else if (format === "ogv") {
                activateVideo()
                videoCodec = "libtheora"
                videoCodecSelection.text = "libtheora"
                audioCodec = "libvorbis"
                audioCodecSelection.text = "libvorbis"
            }
            else if (format === "webm") {
                activateVideo()
                videoCodec = "libvpx"
                videoCodecSelection.text = "libvpx"
                audioCodec = "libvorbis"  // Maybe someday opus but webm seems not support it right now
                audioCodecSelection.text = "libvorbis"
            }
            else if (format === "3gp") {
                activateVideo()
                videoCodec = "h263"
                videoCodecSelection.text = "h263"
                audioCodec = "amr_nb"
                audioCodecSelection.text = "libopencore_amrnb"
            }
            else if (format === "asf") {
                activateVideo()
                videoCodec = "wmv1"
                videoCodecSelection.text = "wmv1"
                audioCodec = "wmav1"
                audioCodecSelection.text = "wmav1"
            }
            else if (format === "wmv") {
                activateVideo()
                videoCodec = "wmv2"
                videoCodecSelection.text = "wmv2"
                audioCodec = "wmav2"
                audioCodecSelection.text = "wmav2"
            }
            else if (format === "mov") {
                activateVideo()
                videoCodec = "mpeg4"
                videoCodecSelection.text = "mpeg4"
                audioCodec = "libfaac"
                audioCodecSelection.text = "libfaac"
            }
            else if (format === "mpeg") {
                activateVideo()
                videoCodec = "mpeg1video"
                videoCodecSelection.text = "mpeg1video"
                audioCodec = "mp2"
                audioCodecSelection.text = "mp2"
            }
            else if (format === "flv") {
                activateVideo()
                videoCodec = "flv"
                videoCodecSelection.text = "flv"
                audioCodec = "libmp3lame"
                audioCodecSelection.text = "libmp3lame"
            }
            else if (format === "aac") {
                deactivateVideo()
                audioCodec = "libfaac"
                audioCodecSelection.text = "libfaac"
            }
            else if (format === "mp3") {
                deactivateVideo()
                audioCodec = "libmp3lame"
                audioCodecSelection.text = "libmp3lame"
            }
            else if (format === "ogg") {
                deactivateVideo()
                audioCodec = "libvorbis"
                audioCodecSelection.text = "libvorbis"
            }
            else if (format === "ac3") {
                deactivateVideo()
                audioCodec = "ac3"
                audioCodecSelection.text = "ac3"
            }
            else if (format === "mp2") {
                deactivateVideo()
                audioCodec = "mp2"
                audioCodecSelection.text = "mp2"
            }
            else if (format === "wav") {
                deactivateVideo()
                audioCodec = "pcm_s16le"
                audioCodecSelection.text = "pcm_s16le"
            }
            // Set output file location
            if (openfText.text != "") {
                savefText.text = openfText.text + "." + format
            }
        }

        function deactivateVideo() {
            if (summaryVideoRectangle.height == 250) {
                summaryVideoRectangle.height = 50
                summaryVideo.opacity = 1
                expandedVideo.opacity = 0
            }
            videoDeactivate.checked = true
            videoDeactivate.enabled = false
        }

        function activateVideo() {
            videoDeactivate.checked = false
            videoDeactivate.enabled = true
        }

        function createFFmpegCommand() {
            var cmd = "ffmpeg -i \"" + openfText.text + "\""

            // Format
            // For now we don't use format here as the detection for file extension works quite good
            //cmd += " -f " + containerSelection.text

            // Audio conversions first
            // example ffmpeg cmd:
            // ffmpeg -i ''  -vn -ab 128k -ar 44100 -b 2000k -f wav -vcodec libxvid -ac 2 -acodec pcm_s16le '.wav'
            if (videoDeactivate.checked == true) {
                video2pass.enabled = false
                cmd += " -vn"
            }
            else if (audioDeactivate.checked) {
                cmd += " -an"
            }
            cmd += " -ab " + audioBitrate
            cmd += " -ar " + audioSamplingFreq
            cmd += " -b " + audioBitrate
            cmd += " -ac " + audioChannel
            cmd += " -acodec " + audioCodec
            if (audioLanguageChannel != "not set") {
                cmd += " -map 0:" + audioLanguageChannel
            }

            //Video conversions second
            //example ffmpeg cmd:
            // ffmpeg -i ''  -ab 128k -ar 44100 -b 2000k -f avi -vcodec libxvid -ac 2 -acodec libmp3lame '.avi'
            cmd += " -b " + videoBitrate
            cmd += " -vcodec " + videoCodec
            if (videoResolution != "no change") {
                cmd += " -s " + videoResolution
            }
            if (videoAspect != "no change") {
                cmd += " -aspect " + videoAspect
            }
            if (videoMultithreading.checked) {
                cmd += " -threads 0"
            }

            if (video2pass.checked) {
                cmdpass1 = cmd + " -y -pass 1"
                cmdpass1 += " '" + savefText.text + "'"
                cmdpass2 = cmd + " -y -pass 2"
                cmdpass2 += " '" + savefText.text + "'"
                // 2 Pass Output file
                cmd = cmdpass1 + " && " + cmdpass2
            }
            else {
                // Output file
                cmd += " \"" + savefText.text + "\""
            }
            //console.log(cmd) //DEBUG
            return cmd
        }

        TextField {
            id: openfText
            placeholderText: qsTr("Open source file here")
            anchors.top: parent.top
            anchors.left: parent.left
            width: 350
            height: 32
            clearButtonShown: true
            onTextChanged: {
                sourceGrid.checkFormatandSetCodecs(containerSelection.text)
            }
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
            // Just for testing now // DEBUG
            onClicked: { openFileClicked() }
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
                onFormatChanged: {
                    sourceGrid.checkFormatandSetCodecs(format)
                    containerSelection.text = format
                }
            }
        }
    }

    // Video Box
    Rectangle {
        id: summaryVideoRectangle
        color: "white"
        anchors.top: sourceGrid.bottom
        anchors.topMargin: 5
        width: parent.width - 30
        //anchors.left: parent.left
        //anchors.leftMargin: 15
        height: 50
        radius: 8

        Behavior on height {
            NumberAnimation { duration: 250 }
        }

        Image {
            source: if (summaryVideo.opacity == 1 && videoDeactivate.enabled == true) { return "img/down.png" }
                    else if (summaryVideo.opacity == 0 && videoDeactivate.enabled == true) { return "img/up.png" }
                    else { return "" }

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
                NumberAnimation { duration: 300 }
            }

            Text {
                id: summaryVideoHeader
                font.bold: true
                text: videoDeactivate.checked ? qsTr("     Video: deactivated") : qsTr("     Video:")
            }
            Text { // codec, resolution, bitrate, aspect ratio
                anchors.left: parent.left
                anchors.leftMargin: 15
                width: summaryVideoRectangle.width
                text: videoDeactivate.checked ? "" : "<b>Codec:</b> " + videoCodec + " <b>Bitrate:</b> " + videoBitrate + " <b>Resolution:</b> " +
                                                videoResolution + "<br /><b>Aspect:</b> " + videoAspect
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
                NumberAnimation { duration: 300 }
            }

            Column {
                spacing: 10

                Text {
                    id: expandedVideoHeader
                    font.bold: true
                    text: videoDeactivate.checked ? qsTr("     Video: deactivated") : qsTr("     Video:")
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
                        text: "Deactivate Video"
                        anchors.verticalCenter: videoDeactivate.verticalCenter
                        enabled: videoDeactivate.enabled
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
                        enabled: videoDeactivate.checked ? false : true
                    }
                    Text {
                        text: "2 Pass"
                        anchors.verticalCenter: video2pass.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            enabled: videoDeactivate.checked ? false : true
                            onClicked: {
                                if (video2pass.checked == false) { video2pass.checked = true }
                                else {video2pass.checked = false }
                            }
                        }
                    }
                    PlasmaComponents.CheckBox {
                        id: videoMultithreading
                        enabled: videoDeactivate.checked ? false : true
                        checked: true // A sane default
                    }
                    Text {
                        text: "Multithreading"
                        anchors.verticalCenter: videoMultithreading.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            enabled: videoDeactivate.checked ? false : true
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
                        enabled: videoDeactivate.checked ? false : true
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
                        enabled: videoDeactivate.checked ? false : true
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

                    TextField {
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
                                NumberAnimation { duration : 800 }
                            }
                            text: qsTr("Set bitrate")
                            onClicked: {
                                if (videoBitrateCustom.text.substr(-1) === "k") {

                                }
                                else {
                                    videoBitrateCustom.text = videoBitrateCustom.text + "k"
                                }
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
                        enabled: videoDeactivate.checked ? false : true
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
                    TextField {
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
                                NumberAnimation { duration : 800 }
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
                        enabled: videoDeactivate.checked ? false : true
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

            //            onEntered: {                                              // Nice effect but might get in the way deactivated for now
            //                if (summaryAudioRectangle.height == 250) {
            //                    summaryAudioRectangle.height = 50
            //                    summaryAudio.opacity = 1
            //                    expandedAudio.opacity = 0
            //                }
            //                if (videoDeactivate.enabled == true) {
            //                    parent.height = 250
            //                    summaryVideo.opacity = 0
            //                    expandedVideo.opacity = 1
            //                }
            //            }
            onClicked: {
                if (parent.height == 50 && videoDeactivate.enabled == true) {
                    if (summaryAudioRectangle.height == 250) {
                        summaryAudioRectangle.height = 50
                        summaryAudio.opacity = 1
                        expandedAudio.opacity = 0
                    }
                    parent.height = 250
                    summaryVideo.opacity = 0
                    expandedVideo.opacity = 1
                }
                else if (videoDeactivate.enabled == true)
                {
                    parent.height = 50
                    summaryVideo.opacity = 1
                    expandedVideo.opacity = 0
                }
            }
        } // MouseArea
    } // summaryVideoRectangle

    // Audio Box
    Rectangle {
        id: summaryAudioRectangle
        color: "white"
        anchors.top: summaryVideoRectangle.bottom
        anchors.topMargin: 15
        width: parent.width - 30
        //anchors.left: parent.left
        //anchors.leftMargin: 15
        height: 50
        radius: 8

        Behavior on height {
            NumberAnimation { duration: 250 }
        }

        Image {
            source: if (summaryAudio.opacity == 1) { return "img/down.png" }
                    else { return "img/up.png" }

            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
        }

        Grid {
            id: summaryAudio
            rows: 2
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width - 15
            height: parent.height - 15
            anchors.verticalCenter: parent.verticalCenter
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            Text {
                id: summaryAudioHeader
                font.bold: true
                text: audioDeactivate.checked ? qsTr("     Audio: deactivated") : qsTr("     Audio:")
            }
            Text { // codec, resolution, bitrate, aspect ratio
                anchors.left: parent.left
                anchors.leftMargin: 15
                text: audioDeactivate.checked ? "" : "<b>Codec:</b> " + audioCodec + " <b>Bitrate:</b> " + audioBitrate + " <b>Sampling Freq:</b> " +
                                                audioSamplingFreq + " <b>Channel:</b> " + audioChannel + " <br /><b>Language Channel:</b> " + audioLanguageChannel
            }
        } // Grid Summary Audio
        Row {
            id: expandedAudio
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width - 15
            height: parent.height - 15
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0
            spacing: 25

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }

            Column {
                spacing: 10

                Text {
                    id: expandedAudioHeader
                    font.bold: true
                    text: audioDeactivate.checked ? qsTr("     Audio: deactivated") : qsTr("     Audio:")
                }
                Image {
                    id: audioIcon
                    source: "img/audio-x-generic.png"
                    anchors.top: expandedVideoHeader.bottom
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                Grid {   // Grid for checkboxes
                    id: audioCheckboxes
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    columns: 2
                    rows: 3
                    spacing: 5

                    PlasmaComponents.CheckBox {
                        id: audioDeactivate
                    }
                    Text {
                        text: "Deactivate Audio"
                        anchors.verticalCenter: audioDeactivate.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (audioDeactivate.checked == false) { audioDeactivate.checked = true }
                                else {audioDeactivate.checked = false }
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
                        id: audioCodecLabel
                        text: qsTr("Codec:")
                        anchors.verticalCenter: audioCodecSelection.verticalCenter
                        width: 55
                    }

                    PlasmaComponents.Button {
                        id: audioCodecSelection
                        width: 100
                        height: 24
                        text: "libmp3lame"
                        iconSource: "go-down"
                        anchors.left: audioCodecLabel.right
                        anchors.leftMargin: 15
                        onClicked: audioCodecMenu.open()
                        enabled: audioDeactivate.checked ? false : true
                        AudioCodecList {
                            id: audioCodecMenu
                            visualParent: audioCodecSelection
                            onCodecChanged: {
                                audioCodecSelection.text = codec
                                audioCodec = codec
                            }
                        }
                    }
                }
                Row {
                    Text {
                        id: audioBitrateLabel
                        text: qsTr("Bitrate:")
                        width: 55
                        anchors.verticalCenter: audioBitrateSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: audioBitrateSelection
                        width: 100
                        height: 24
                        text: "128k"
                        iconSource: "go-down"
                        anchors.left: audioBitrateLabel.right
                        anchors.leftMargin: 15
                        onClicked: audioBitrateMenu.open()
                        enabled: audioDeactivate.checked ? false : true
                        AudioBitrateList {
                            id: audioBitrateMenu
                            visualParent: audioBitrateSelection
                            onBitrateChanged: {
                                if (bitrate != "custom") {
                                    audioBitrateSelection.text = bitrate
                                    audioBitrate = bitrate
                                    audioBitrateCustom.width = 5
                                    audioBitrateCustomHint.opacity = 0
                                    audioBitrateCustom.opacity = 0

                                }
                                else {
                                    audioBitrateSelection.text = bitrate
                                    audioBitrateCustom.opacity = 1
                                    audioBitrateCustom.width = 100
                                    audioBitrateCustomHint.text =  qsTr("Set bitrate")
                                    audioBitrateCustomHint.opacity = 1
                                    audioBitrateCustom.forceActiveFocus()
                                    audioBitrateCustom.focus = true
                                }
                            }

                        } // AudioBitrateList

                    } // Button audioBitrateSelection
                }
                Row {

                    TextField {
                        id: audioBitrateCustom
                        width: 5
                        opacity: 0
                        anchors.verticalCenter: audioBitrateCustomHint.verticalCenter
                        focus: true
                        onAccepted: {
                            audioBitrate = text
                            console.log(audioBitrate)
                            audioBitrateCustomHint.text = qsTr("Bitrate " +  audioBitrate + " set")
                        }
                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                        PlasmaComponents.Button {
                            id: audioBitrateCustomHint
                            anchors.left: audioBitrateCustom.right
                            anchors.leftMargin: 15
                            opacity: 0
                            Behavior on opacity {
                                NumberAnimation { duration : 800 }
                            }
                            text: qsTr("Set bitrate")
                            onClicked: {
                                if (audioBitrateCustom.text.substr(-1) === "k") {

                                }
                                else {
                                    audioBitrateCustom.text = audioBitrateCustom.text + "k"
                                }
                                audioBitrate = audioBitrateCustom.text
                                text = qsTr("Bitrate " +  audioBitrate + " set")
                            }
                        }
                    } // TextField audioBitrateCustom
                }

                Row {
                    Text {
                        id: audioSamplingFreqLabel
                        text: qsTr("Sampl. Freq:")
                        width: 55
                        anchors.verticalCenter: audioSamplingFreqSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: audioSamplingFreqSelection
                        width: 100
                        height: 24
                        text: "44100"
                        iconSource: "go-down"
                        anchors.left: audioSamplingFreqLabel.right
                        anchors.leftMargin: 15
                        onClicked: audioSamplingFreqMenu.open()
                        enabled: audioDeactivate.checked ? false : true
                        SamplingList {
                            id: audioSamplingFreqMenu
                            visualParent: audioSamplingFreqSelection
                            onSamplingChanged: {
                                audioSamplingFreqSelection.text = sampling
                                audioSamplingFreq = sampling
                            }

                        } // audioSamplingFreqList

                    } // Button audioSamplingFreqSelection
                    Text {
                        anchors.left: audioSamplingFreqSelection.right
                        anchors.leftMargin: 15
                        anchors.verticalCenter: audioSamplingFreqSelection.verticalCenter
                        text : "Hz"
                    }
                }

                Row {
                    Text {
                        id: audioChannelLabel
                        text: qsTr("Channel:")
                        width: 55
                        anchors.verticalCenter: audioChannelSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: audioChannelSelection
                        width: 100
                        height: 24
                        text: "2"
                        iconSource: "go-down"
                        anchors.left: audioChannelLabel.right
                        anchors.leftMargin: 15
                        onClicked:audioChannelMenu.open()
                        enabled: audioDeactivate.checked ? false : true
                        AudioChannelList {
                            id: audioChannelMenu
                            visualParent: audioChannelSelection
                            onChannelChanged: {
                                if (channel !== qsTr("custom")) {
                                    audioChannelSelection.text = channel
                                    audioChannel = channel
                                    audioChannelCustom.width = 5
                                    audioChannelCustomHint.opacity = 0
                                    audioChannelCustom.opacity = 0

                                }
                                else {
                                    audioChannelSelection.text = channel
                                    audioChannelCustom.opacity = 1
                                    audioChannelCustom.width = 100
                                    audioChannelCustomHint.text =  qsTr("Set channel")
                                    audioChannelCustomHint.opacity = 1
                                    audioChannelCustom.forceActiveFocus()
                                    audioChannelCustom.focus = true
                                }
                            }

                        } // audioChannelList

                    } // Button audioChannelSelection
                }
                Row {
                    TextField {
                        id: audioChannelCustom
                        width: 5
                        opacity: 0
                        focus: true
                        anchors.verticalCenter: audioChannelCustomHint.verticalCenter
                        onAccepted: {
                            audioChannel = audioChannelCustom.text
                            console.log(audioChannel)
                            audioChannelCustomHint.text = qsTr("Channel " +  audioChannel + " set")
                        }
                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                        PlasmaComponents.Button {
                            id: audioChannelCustomHint
                            anchors.left: audioChannelCustom.right
                            anchors.leftMargin: 15
                            opacity: 0
                            Behavior on opacity {
                                NumberAnimation { duration : 800 }
                            }
                            text: qsTr("Set resolution")
                            onClicked: {
                                audioChannel = audioChannelCustom.text
                                text = qsTr("Channel " +  audioChannel + " set")
                            }
                        }
                    } // TextField audioChannelCustom
                }
                Row {
                    Text {
                        id: audioLanguageChannelLabel
                        text: qsTr("Language:")
                        width: 55
                        anchors.verticalCenter: audioLanguageChannelSelection.verticalCenter
                    }
                    PlasmaComponents.Button {
                        id: audioLanguageChannelSelection
                        width: 100
                        height: 24
                        text: "not set"
                        iconSource: "go-down"
                        anchors.left: audioLanguageChannelLabel.right
                        anchors.leftMargin: 15
                        onClicked:audioLanguageChannelMenu.open()
                        enabled: audioDeactivate.checked ? false : true
                        AudioLanguageChannelList {
                            id: audioLanguageChannelMenu
                            visualParent: audioLanguageChannelSelection
                            onChannelChanged: {
                                if (channel !== qsTr("custom")) {
                                    audioLanguageChannelSelection.text = channel
                                    audioLanguageChannel = channel
                                    audioLanguageChannelCustom.width = 5
                                    audioLanguageChannelCustomHint.opacity = 0
                                    audioLanguageChannelCustom.opacity = 0

                                }
                                else {
                                    audioLanguageChannelSelection.text = channel
                                    audioLanguageChannelCustom.opacity = 1
                                    audioLanguageChannelCustom.width = 100
                                    audioLanguageChannelCustomHint.text =  qsTr("Set channel")
                                    audioLanguageChannelCustomHint.opacity = 1
                                    audioLanguageChannelCustom.forceActiveFocus()
                                    audioLanguageChannelCustom.focus = true
                                }
                            }

                        } // audioChannelList

                    } // Button audioLanguageChannelSelection
                }
                Row {
                    TextField {
                        id: audioLanguageChannelCustom
                        width: 5
                        opacity: 0
                        focus: true
                        anchors.verticalCenter: audioLanguageChannelCustomHint.verticalCenter
                        onAccepted: {
                            audioLanguageChannel = audioLanguageChannelCustom.text
                            console.log(audioLanguageChannel)
                            audioLanguageChannelCustomHint.text = qsTr("Channel " +  audioLanguageChannel + " set")
                        }
                        Behavior on width {
                            NumberAnimation { duration: 400 }
                        }
                        PlasmaComponents.Button {
                            id: audioLanguageChannelCustomHint
                            anchors.left: audioLanguageChannelCustom.right
                            anchors.leftMargin: 15
                            opacity: 0
                            Behavior on opacity {
                                NumberAnimation { duration : 800 }
                            }
                            text: qsTr("Set resolution")
                            onClicked: {
                                audioLanguageChannel = audioLanguageChannelCustom.text
                                text = qsTr("Channel " +  audioLanguageChannel + " set")
                            }
                        }
                    } // TextField audioLanguageChannelCustom
                }

                //                    } // Button aspectSelection
                //                }


            } // Column for Codec, Bitrate, ...

        } // Row Expanded Audio
        MouseArea {
            //            anchors.fill: parent  // This does not work as it blocks every mouseclick on the parent later on
            width: parent.width
            height: 50
            hoverEnabled: true

            //            onEntered: {
            //                if (summaryVideoRectangle.height == 250) {
            //                    summaryVideoRectangle.height = 50
            //                    summaryVideo.opacity = 1
            //                    expandedVideo.opacity = 0
            //                }
            //                parent.height = 250
            //                summaryAudio.opacity = 0
            //                expandedAudio.opacity = 1
            //            }
            onClicked: {
                if (parent.height == 50) {
                    if (summaryVideoRectangle.height == 250) {
                        summaryVideoRectangle.height = 50
                        summaryVideo.opacity = 1
                        expandedVideo.opacity = 0
                    }
                    parent.height = 250
                    summaryAudio.opacity = 0
                    expandedAudio.opacity = 1
                }
                else
                {
                    parent.height = 50
                    summaryAudio.opacity = 1
                    expandedAudio.opacity = 0
                }
            }
        } // MouseArea
    } // summaryAudioRectangle

    Item {
        id: saveToBox
        anchors.top: summaryAudioRectangle.bottom
        anchors.topMargin: 15
        //anchors.left: parent.left
        //anchors.leftMargin: 15
        height: 40

        TextField {
            id: savefText
            placeholderText: qsTr("Save target file here")
            width: 350
            height: 32
            clearButtonShown: true
        }
        PlasmaComponents.Button {
            id: savefBtn
            text: qsTr("Save")
            anchors.left: savefText.right
            anchors.leftMargin: 15
            anchors.verticalCenter: savefText.verticalCenter
            width: 80
            height: 32
            iconSource: "document-save"
            // Just for testing now // DEBUG
            onClicked: { saveFileClicked(target);  }
        }
    }
    Item {
        id: cmdbox
        anchors.top: saveToBox.bottom
        anchors.topMargin: 15
        width: parent.width - 30
        //anchors.left: parent.left
        //anchors.leftMargin: 15
        height: 0
        Behavior on height {
            NumberAnimation { duration: 250 }
        }
        function toggleShow() {
            if (cmdboxRectangle.opacity == 0) {
                cmdboxRectangle.opacity = 1
                cmdLabel.opacity = 1
                cmdText.opacity = 1
                if (summaryVideoRectangle.height == 250) {
                    summaryVideoRectangle.height = 50
                    summaryVideo.opacity = 1
                    expandedVideo.opacity = 0
                }
                else if (summaryAudioRectangle.height == 250) {
                    summaryAudioRectangle.height = 50
                    summaryAudio.opacity = 1
                    expandedAudio.opacity = 0
                }
            }
            else {
                cmdboxRectangle.opacity = 0
                cmdLabel.opacity = 0
                cmdText.opacity = 0
            }
        }

        Rectangle {
            id:cmdboxRectangle
            color: "black"
            anchors.fill: parent
            radius: 8
            opacity: 0
        }
        Text {
            id: cmdLabel
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            color: "green"
            text: "<b>$</b> "
            opacity: 0
            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }
        TextArea {
            id: cmdText
            anchors.left: cmdLabel.right
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("FFmpeg command here")
            text: sourceGrid.createFFmpegCommand()
            width: parent.width - 32
            height: 64
            opacity: 0
            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }

    }

    Item {
        id:toolbox
        anchors.top: cmdbox.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: 60
        width: parent.width
        PlasmaComponents.Button {
            id: encodeBtn
            anchors.horizontalCenter: parent.horizontalCenter
            width:140
            height: 48
            iconSource: "file://img/encode-btn.png"
            onClicked: { encodeClicked(sourceGrid.createFFmpegCommand(),savefText.text) }
            Image {
                id: icon
                width: 48
                height: 48
                source: "img/encode-btn.png"
            }
            Text {
                anchors.left: icon.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("<b>Encode</b>")
            }
        }

    }


}
