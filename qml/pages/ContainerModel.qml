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
        vbitrate: "777"
        resolution: "no change"
        aspect: "no change"
        acodec: "libfaac"
        abitrate: "128"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "avi"
        type: "video"
        vcodec: "libxvid"
        vbitrate: "900"
        resolution: "no change"
        aspect: "no change"
        acodec: "libmp3lame"
        abitrate: "196"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "mpeg"
        type: "video"
        vcodec: "mpeg1video"
        vbitrate: "1115"
        resolution: "no change"
        aspect: "no change"
        acodec: "mp2"
        abitrate: "256"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "mkv"
        type: "video"
        vcodec: "libx264"
        vbitrate: "777"
        resolution: "no change"
        aspect: "no change"
        acodec: "libfaac"
        abitrate: "128"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "ogv"
        type: "video"
        vcodec: "libtheora"
        vbitrate: "900"
        resolution: "no change"
        aspect: "no change"
        acodec: "libvorbis"
        abitrate: "128"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "webm"
        type: "video"
        vcodec: "libvpx"
        vbitrate: "777"
        resolution: "no change"
        aspect: "no change"
        acodec: "libvorbis"
        abitrate: "128"
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
        abitrate: "196"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "wav"
        type: "audio"
        acodec: "pcm_s16le"
        abitrate: "1411"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "flac"
        type: "audio"
        acodec: "flac"
        abitrate: "700"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "ogg"
        type: "audio"
        acodec: "libvorbis"
        abitrate: "128"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "opus"
        type: "audio"
        acodec: "libopus"
        abitrate: "96"
        sample: "48000"
        channel: "2"
        lang: "not set"
    }
    ListElement {
        title: "m4a"
        type: "audio"
        acodec: "libfaac"
        abitrate: "128"
        sample: "44100"
        channel: "2"
        lang: "not set"
    }
}

