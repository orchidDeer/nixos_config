import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#f4ecdf"

    property real uiScale: Math.min(width / 1920, height / 1080)

    // soft sage/cream gradient wash over the wallpaper
    Image {
        id: bg
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3d3626"; }
            GradientStop { position: 1.0; color: "#2a2e22"; }
        }
        opacity: 0.35
    }

    // clock, top center
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 4
        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#f4ecdf"
            font.family: "Lora, Georgia, serif"
            font.italic: true
            font.pixelSize: 46 * root.uiScale
            text: Qt.formatTime(new Date(), "hh:mm")
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#e3d9c4"
            font.family: "Lora, Georgia, serif"
            font.pixelSize: 20 * root.uiScale
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
        }
    }
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: clockText.text = Qt.formatTime(new Date(), "hh:mm")
    }

    // login card
    Rectangle {
        id: card
        width: 380
        height: 220
        radius: 24
        color: "#f4ecdf"
        opacity: 0.94
        border.color: "#8a9a6b"
        border.width: 2
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 18
            width: parent.width - 60

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "🪷 welcome back 🪷"
                font.family: "Lora, Georgia, serif"
                font.pixelSize: 22
                color: "#4a5233"
            }

            ComboBox {
                id: userCombo
                width: parent.width
                height: 22
                font.pixelSize: 15
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex

                contentItem: Text {
                    text: userCombo.displayText
                    font: userCombo.font
                    color: "#000000" // Hier können Sie die gewünschte Textfarbe definieren
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }


                background: Rectangle {
                    radius: 12
                    color: "#eee4d3"
                    border.color: "#c2b49a"
                }
            }

            TextField {
                id: passwordField
                width: parent.width
                height: 22
                font.pixelSize: 15
                echoMode: TextInput.Password
                placeholderText: "password"
                font.family: "Lora, Georgia, serif"
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                background: Rectangle {
                    radius: 12
                    color: "#eee4d3"
                    border.color: "#c2b49a"
                }
                onAccepted: sddm.login(userCombo.currentText, passwordField.text, sessionCombo.currentIndex)
            }

            ComboBox {
                id: sessionCombo
                width: parent.width
                height: 22
                font.pixelSize: 15
                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex

                contentItem: Text {
                    text: sessionCombo.displayText
                    font: sessionCombo.font
                    color: "#000000" // Hier können Sie die gewünschte Textfarbe definieren
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }


                background: Rectangle {
                    radius: 12
                    color: "#eee4d3"
                    border.color: "#c2b49a"
                }
            }

            Button {
                width: parent.width
                text: "log in"
                font.family: "Lora, Georgia, serif"
                background: Rectangle {
                    radius: 12
                    color: "#8a9a6b"
                }
                contentItem: Text {
                    text: parent.text
                    color: "#f4ecdf"
                    horizontalAlignment: Text.AlignHCenter
                    font: parent.font
                }
                onClicked: sddm.login(userCombo.currentText, passwordField.text, sessionCombo.currentIndex)
            }
        }
    }

    // power buttons, bottom right, minimal
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 20
        Text {
            text: "shutdown"
            color: "#8a9a6b"
            font.family: "Lora, Georgia, serif"
            font.pixelSize: 16 * root.uiScale
            MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }
        }
        Text {
            text: "restart"
            color: "#8a9a6b"
            font.family: "Lora, Georgia, serif"
            font.pixelSize: 16 * root.uiScale
            MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordField.text = ""
            passwordField.placeholderText = "wrong password, try again"
        }
    }
}
