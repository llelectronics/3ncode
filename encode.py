#!/usr/bin/python
# ################################
# MAGI 2 - QMLViewer for N9
# by Leszek Lesner
# released under the terms of GPLv3
# ################################ 
import sys
global use_pyside

try:
  # Try importing PyQt4 if available (i.e. on Desktop)
  from PyQt4.QtCore import QTimer, QObject, QUrl, QCoreApplication, SIGNAL,QTranslator, QProcess, SLOT, pyqtSlot
  from PyQt4.QtGui import QApplication, QDesktopWidget, QFileDialog
  from PyQt4.QtDeclarative import QDeclarativeView
  use_pyside = False
except:
  print "PyQt4 failed to load, trying to use PySide instead..."
  try:
    # If PyQt4 could not be loaded use PySide (i.e. very useful for N900 and Maemo)
    from PySide.QtCore import QTimer, QObject, QUrl, QCoreApplication, SIGNAL,QTranslator, QProcess, SLOT, pyqtSlot
    from PySide.QtGui import QApplication, QDesktopWidget, QFileDialog
    from PySide.QtDeclarative import QDeclarativeView
    print "success."
    use_pyside = True
  except:
    print "failed."
    print "Please install either PyQt4 or PySide for this application to run successfully."
    sys.exit(1) 
    
    
#class MyQProcess(QProcess):     
  #def __init__(self):    
   ##Call base class method 
   #QProcess.__init__(self)
   
  #@pyqtSlot()
  #def finishEncode(self):
   #rootObject.hideEncodeAnimation()
   #self.close()
   
  #@pyqtSlot()
  #def readStdOutput(self):
   ##print self.readAllStandardOutput()
   ##open(home + "/encode.log","w").write(self.readAllStandardOutput()) 
   #open(home + "/encode.log", "w").write(self.readAllStrandardError())
    
    
def quit():
  sys.exit(0)
  
def openFile():
  transObj = QObject()
  fName = QFileDialog.getOpenFileName(None, transObj.tr("Open media file"), transObj.tr("Media file"), transObj.tr("Media Files (*.mp4 *.avi *.mp3 *.wav *.ogg *.flv *.ogv *.m4v *.m4a *.aac *.flac *.webm *.mpg *.mpeg *.wmv *.wma *.mp2 *.mov *.oga *.aif *.aiff *.aifc *.ape *.mka *.asf *.3gp *.dv *.m2t *.mts *.ts *.divx *.nsv *.ogm)"))
  if fName.isEmpty() == False:
    rootObject.sourceFilename(fName)
    
def openF(filename):
    rootObject.sourceFilename(filename)
    
def saveFile(filename):
  transObj = QObject()
  fName = QFileDialog.getSaveFileName(None, transObj.tr("Save media file"), filename, "")
  if fName.isEmpty() == False:
    rootObject.targetFilename(fName)  
    
def encodeCmd(cmd):
  # Write command to history file
  popen("echo \"" + str(cmd) + "\" >> ~/encode_history.log") 
  # Execute command
  popen("xterm -T \"Encoding...\" -b 5 -e \"" + str(cmd) +  " 2>&1 | tee ~/encode.log\" &")
  # If I ever figure out how to do this I tell you
  #cmdProcess = MyQProcess()
  #cmdProcess.setProcessChannelMode(QProcess.MergedChannels)
  #cmdProcess.start(cmd) # + " | tee -a ~/encode.log")
  #QObject.connect(cmdProcess,SIGNAL("finished()"),cmdProcess,SLOT("finishEncode()"))
  #QObject.connect(cmdProcess,SIGNAL("readyReadStandardOutput()"),cmdProcess,SLOT("readStdOutput()"))
  #cmdProcess.waitForFinished(-1)
  


# Import popen to execute shell commands, 
# path for working with standard paths 
# ConfigParser for config handling
# and time for time and date handling
from os import popen, path
#import ConfigParser, time
home = path.expanduser("~")

app = QApplication(sys.argv)
app.setGraphicsSystem("raster")

# Create the QML user interface.
view = QDeclarativeView()
# Use PlasmaComponents
engine = view.engine()
engine.addImportPath("/usr/lib/kde4/imports")
# Set main qml here
view.setSource(QUrl("3ncode.qml"))
view.setResizeMode(QDeclarativeView.SizeRootObjectToView)

# Get the root object of the user interface.
rootObject = view.rootObject()

# Check for parameters
if len(sys.argv) > 1:
  openF(sys.argv[1])

# Connect QML signals with Python functions
rootObject.openFile.connect(openFile)
rootObject.saveFile.connect(saveFile)
rootObject.encodeCmd.connect(encodeCmd)

# Display the user interface and allow the user to interact with it.
view.setGeometry(0, 0, 480, 575)
view.setWindowTitle(QCoreApplication.translate(None, 'Encode'))
screen = QDesktopWidget().screenGeometry()
size =  view.geometry()
view.move((screen.width()-size.width())/2, (screen.height()-size.height())/2)
view.show()
#view.showFullScreen()

app.exec_()

