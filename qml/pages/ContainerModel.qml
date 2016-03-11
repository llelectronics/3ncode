import QtQuick 2.0

ListModel {
    id: containerModel
    ListElement {
        title: "---Video---"
    }
    ListElement {
        title: "mp4"
        type: "video"
    }
    ListElement {
        title: "avi"
        type: "video"
    }
    ListElement {
        title: "flv"
        type: "video"
    }
    ListElement {
        title: "mkv"
        type: "video"
    }
    ListElement {
        title: "ogv"
        type: "video"
    }
    ListElement {
        title: "---Audio---"
    }
    ListElement {
        title: "mp3"
        type: "audio"
    }
    ListElement {
        title: "wav"
        type: "audio"
    }
    ListElement {
        title: "flac"
        type: "audio"
    }
    ListElement {
        title: "ogg"
        type: "audio"
    }
}

