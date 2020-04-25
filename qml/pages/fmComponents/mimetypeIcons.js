.pragma library

function returnMimeTypeIcon(_fm, filePath) {
    if (_fm.getMime(filePath).indexOf("video") !== -1) return "image://theme/icon-m-file-video"
    else if (_fm.getMime(filePath).indexOf("audio") !== -1) return "image://theme/icon-m-file-audio"
    else if (_fm.getMime(filePath).indexOf("image") !== -1) return "image://theme/icon-m-file-image"
    else if (_fm.getMime(filePath).indexOf("text") !== -1) return "image://theme/icon-m-file-document"
    else if (_fm.getMime(filePath).indexOf("pdf") !== -1) return "image://theme/icon-m-file-pdf"
    else if (_fm.getMime(filePath).indexOf("android") !== -1) return "image://theme/icon-m-file-apk"
    else if (_fm.getMime(filePath).indexOf("rpm") !== -1) return "image://theme/icon-m-file-rpm"
    else if (_fm.getMime(filePath).indexOf("zip") !== -1 ||
             _fm.getMime(filePath).indexOf("x-compress") !== -1 ||
             _fm.getMime(filePath).indexOf("x-compress") !== -1 ||
             _fm.getMime(filePath).indexOf("x-tar") !== -1 ||
             _fm.getMime(filePath).indexOf("x-gzip") !== -1 ||
             _fm.getMime(filePath).indexOf("x-bzip2") !== -1 ||
             _fm.getMime(filePath).indexOf("x-rar-compressed") !== -1)
        return "image://theme/icon-m-file-archive-folder"
    else if (_fm.getMime(filePath).indexOf("doc") !== -1 ||
             _fm.getMime(filePath).indexOf("msword") !== -1 ||
             _fm.getMime(filePath).indexOf("vnd.openxmlformats-officedocument.wordprocessingml.document") !== -1 ||
             _fm.getMime(filePath).indexOf("vnd.oasis.opendocument.text") !== -1 ||
             _fm.getMime(filePath).indexOf("ms-doc") !== -1)
        return "image://theme/icon-m-file-formatted"
    else if (_fm.getMime(filePath).indexOf("x-vcard") !== -1) return "image://theme/icon-m-file-vcard"
    else if (_fm.getMime(filePath).indexOf("calendar") !== -1) return "image://theme/icon-m-event"
    else if (_fm.getMime(filePath).indexOf("html") !== -1) return "image://theme/icon-m-website"
    else if (_fm.getMime(filePath).indexOf("x-shellscript") !== -1 ||
             _fm.getMime(filePath).indexOf("x-executable") !== -1)
        return "image://theme/icon-m-developer-mode"
    else if (_fm.getMime(filePath).indexOf("x-sharedlib") !== -1) return "image://theme/icon-m-levels"
    else return "image://theme/icon-m-file-other"
}
