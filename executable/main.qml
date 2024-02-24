import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 500
    height: 500
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    ColumnLayout {
       anchors.fill: parent

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.verticalStretchFactor: 2

            TextField {
                id: textField
                placeholderText: ""
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.horizontalStretchFactor: 3
            }

            Button {
                text: "Add"
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.horizontalStretchFactor: 1

                onClicked: {
                    CustomListModel.appendEntry(textField.text)
                }
            }
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.verticalStretchFactor: 8

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
