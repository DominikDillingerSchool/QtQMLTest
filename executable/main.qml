import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 500
    height: 500
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    
    Shortcut {
        sequence: "Ctrl+Shift+Q"
        onActivated: {
            textEdit.text = Benchmark.benchmarks(listView.model);
        }
    }
    
    ColumnLayout {
       anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: mainWindow.height * 0.2

            TextArea  {
                id: textEdit
                wrapMode: TextEdit.WrapAnywhere
                Layout.fillHeight: true
                Layout.preferredWidth: mainWindow.width * 0.75
            }

            Button {
                text: "Add"
                Layout.fillHeight: true
                Layout.preferredWidth: mainWindow.width * 0.25
                onClicked: {
                    CustomListModel.appendEntry(textEdit.text)
                }
            }
        }
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.preferredHeight: mainWindow.height * 0.8
            model: CustomListModel

            delegate: Rectangle {
                height: 40
                width: listView.width

                Text {
                    text: name
                    height: parent.height
                    width: (parent.width * 0.8)
                    anchors.left: parent.left
                }

                Button {
                    text: "Delete"
                    height: parent.height
                    width: (parent.width * 0.2)
                    anchors.right: parent.right
                    onClicked: {
                        CustomListModel.deleteEntry(entryId)
                    }
                }
            }
        }
    }
}
