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
  from PyQt4.QtCore import QTimer, QObject, QUrl, QCoreApplication, SIGNAL,QTranslator
  from PyQt4.QtGui import QApplication, QDesktopWidget, QFileDialog
  from PyQt4.QtDeclarative import QDeclarativeView
  use_pyside = False
except:
  print "PyQt4 failed to load, trying to use PySide instead..."
  try:
    # If PyQt4 could not be loaded use PySide (i.e. very useful for N900 and Maemo)
    from PySide.QtCore import QTimer, QObject, QUrl, QCoreApplication, SIGNAL,QTranslator
    from PySide.QtGui import QApplication, QDesktopWidget, QFileDialog
    from PySide.QtDeclarative import QDeclarativeView
    print "success."
    use_pyside = True
  except:
    print "failed."
    print "Please install either PyQt4 or PySide for this application to run successfully."
    sys.exit(1) 
    
def quit():
  sys.exit(0)
  
def openFile():
  transObj = QObject()
  fName = QFileDialog.getOpenFileName(None, transObj.tr("Open media file"), transObj.tr("Media file"), transObj.tr("Media Files (*.mp4)"))
  if fName.isEmpty() == False:
    rootObject.sourceFilename(fName)
    
def openFile(filename):
    rootObject.sourceFilename(filename)
    
def saveFile(filename):
  transObj = QObject()
  fName = QFileDialog.getSaveFileName(None, transObj.tr("Save media file"), filename, "")
  if fName.isEmpty() == False:
    rootObject.targetFilename(fName)

# Import popen to execute shell commands, 
# path for working with standard paths 
# ConfigParser for config handling
# and time for time and date handling
from os import popen, path
#import ConfigParser, time

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
if len(sys.argv) != 0:
  openFile(sys.argv[1])

# Connect QML signals with Python functions
rootObject.openFile.connect(openFile)
rootObject.saveFile.connect(saveFile)

# Display the user interface and allow the user to interact with it.
view.setGeometry(0, 0, 480, 575)
view.setWindowTitle(QCoreApplication.translate(None, 'Encode'))
screen = QDesktopWidget().screenGeometry()
size =  view.geometry()
view.move((screen.width()-size.width())/2, (screen.height()-size.height())/2)
view.show()
#view.showFullScreen()

app.exec_()

