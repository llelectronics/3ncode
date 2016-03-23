#ifndef ENCODEPROCESS_H
#define ENCODEPROCESS_H

#include <QObject>
#include <QFile>
#include <QProcess>
#include <QString>
#include <QDebug>

class encodeProcess : public QObject
{
    Q_OBJECT
public:
    explicit encodeProcess(QObject *parent = 0);
    Q_PROPERTY(QString cmd READ cmd WRITE setCmd)
    QString cmd() { return mCmd; }
    Q_INVOKABLE bool setCmd(const QString &cmd);

signals:
    void error();
    void success();

public slots:
    void runFFmpeg();

private:
    QString mCmd;
    QProcess ffmpegProc;
};

#endif // ENCODEPROCESS_H
