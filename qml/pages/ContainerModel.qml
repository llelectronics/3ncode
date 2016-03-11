import QtQuick 2.0

ListModel {
    id: containerModel
    ListElement {
        title: "---Video---"
    }
    ListElement {
        title: "mp4"
        type: "video"
        vcodec: "libx264"
        vbitrate: "777k"
        resolution: "no change"
        aspect: "no change"
        acodec: "libfaac"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "avi"
        type: "video"
        vcodec: "libxvid"
        vbitrate: "900k"
        resolution: "no change"
        aspect: "no change"
        acodec: "libmp3lame"
        abitrate: "196k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "mpeg"
        type: "video"
        vcodec: "mpeg1video"
        vbitrate: "1115k"
        resolution: "no change"
        aspect: "no change"
        acodec: "mp2"
        abitrate: "256k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "mkv"
        type: "video"
        vcodec: "libx264"
        vbitrate: "777k"
        resolution: "no change"
        aspect: "no change"
        acodec: "libfaac"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "ogv"
        type: "video"
        vcodec: "libtheora"
        vbitrate: "900k"
        resolution: "no change"
        aspect: "no change"
        acodec: "libvorbis"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "webm"
        type: "video"
        vcodec: "libvpx"
        vbitrate: "777k"
        resolution: "no change"
        aspect: "no change"
        acodec: "libvorbis"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "---Audio---"
    }
    ListElement {
        title: "mp3"
        type: "audio"
        acodec: "libmp3lame"
        abitrate: "196k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "wav"
        type: "audio"
        acodec: "pcm_s16le"
        abitrate: "1411k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "flac"
        type: "audio"
        acodec: "flac"
        abitrate: "700k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "ogg"
        type: "audio"
        acodec: "libvorbis"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "opus"
        type: "audio"
        acodec: "libopus"
        abitrate: "96k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "m4a"
        type: "audio"
        acodec: "libaac"
        abitrate: "128k"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
}

