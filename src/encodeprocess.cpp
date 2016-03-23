#include "encodeprocess.h"

encodeProcess::encodeProcess(QObject *parent) : QObject(parent)
{

}

bool encodeProcess::setCmd(const QString &cmd)
{
    mCmd = cmd;
    return true;
}

void encodeProcess::runFFmpeg()
{
    QString appPath("/usr/share/harbour-encode/");
    QString appName("ffmpeg_static");
    ffmpegProc.start(appPath+appName + " " + mCmd);
    connect(&ffmpegProc, SIGNAL(finished(int)), this, SLOT(getffmpegOutput(int)));
}

void encodeProcess::getffmpegOutput(int exitCode)
{
    if (exitCode == 0) {
        Q_EMIT success();
    }
    else {
        QByteArray errorOut = ffmpegProc.readAllStandardError();
        mErrorOutput = errorOut.simplified();
        Q_EMIT error();
    }
}

