import QtQuick 2.0
import QtQuick.Controls 1.0

ApplicationWindow {
    visible: true

    //title of the application
    title: qsTr("Hello World")
    width: 640
    height: 480

    //menu containing two menu items
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    //Content Area

    Button {
        id: helloButton
        text: qsTr("Hello World")
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked: {
            console.log("Hello World!")
            this.text = "Hello, indeed."
        }
    }

    Text {
        id: helloText
        text: "Hello world!"
        y: 30
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 24; font.bold: true

        MouseArea { id: mouseArea; anchors.fill: parent }

        states: State {
            name: "down"; when: mouseArea.pressed == true
            PropertyChanges {
                target: helloText
                y: 160
                rotation: 180
                color: "red"
            }
        }

        transitions: Transition {
            from: ""; to: "down"; reversible: true
            ParallelAnimation {
                NumberAnimation { properties: "y,rotation"; duration: 500; easing.type: Easing.InOutQuad }
                ColorAnimation { duration: 500 }
            }
        }
    }

    Grid {
        id: colorPicker
        x: 4; anchors.bottom: parent.bottom; anchors.bottomMargin: 4
        rows: 2; columns: 3; spacing: 3

        Cell { cellColor: "red"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "green"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "blue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "yellow"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "steelblue"; onClicked: helloText.color = cellColor }
        Cell { cellColor: "black"; onClicked: helloText.color = cellColor }
    }

    property int displayValue: 12

    Text {
        id: displayTextId
        anchors.left: addOneButtonId.right

        text: displayValue.toString() //more clear if you explicit the parent rootWindow.displayValue.toString()
    }

    Button {
        id: addOneButtonId
        anchors.left: helloButton.right

        text: "Increment"
        onClicked: {
            displayValue++
            console.log("Increment by one.")
        }
    }
}
