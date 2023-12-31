import QtQuick
import QtMultimedia
import QtQuick.Window
import QtQuick.Dialogs

Window {
    id: window_id
    width: 768
    height: 432
    color: "maroon"
    title: "QML Video Player"
    visible: true

    Rectangle {
        id: rectangle_id
        width: parent.width
        height: parent.height
        color: "white"

        Video {
            id: video_id
            width: parent.width
            height: parent.height
            source: fileDialog_id.currentFile
        }

        Rectangle {
            id: selectfilebutton_id
            width: 150
            height: 40
            color: "maroon"
            anchors.centerIn: parent

            Text {
                text: "Select your File"
                font.pointSize: 12
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    fileDialog_id.open()
                }
            }
        }

        Rectangle {
            id: seekLine_id
            height: 10
            color: "white"
            radius: 16
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 40

            Rectangle {
                height: parent.height
                color: "red"
                radius: 16
                anchors.left: parent.left
                anchors.right: seekHandle_id.right
            }

            MouseArea {
                width: parent.width - seekHandle_id.width
                height: parent.height + 10
                anchors.centerIn: parent

                onPressed: {
                    video_id.position = mouseX / (seekLine_id.width - seekHandle_id.width) * video_id.duration
                }
            }

            Rectangle {
                id: seekHandle_id
                width: 20
                height: 20
                color: "white"
                radius: 32
                anchors.verticalCenter: parent.verticalCenter
                x: ((video_id.position / video_id.duration) * (seekLine_id.width - seekHandle_id.width))

                MouseArea {
                    width: parent.width + 5
                    height: parent.height + 5
                    anchors.centerIn: parent
                    drag.target: seekHandle_id
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0.1
                    drag.maximumX: seekLine_id.width - seekHandle_id.width

                    onPressed: {
                        video_id.pause()
                    }

                    onReleased: {
                        video_id.position = seekHandle_id.x / (seekLine_id.width - seekHandle_id.width) * video_id.duration
                        video_id.play()
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 40
            anchors.bottom: parent.bottom

            Rectangle {
                id: playButton_id
                width: 20
                height: 20
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "▶"
                    color: "maroon"
                    font.pointSize: 24
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (video_id.state === MediaPlayer.PlayingState) {
                            video_id.pause()
                        } else {
                            video_id.play()
                        }
                    }
                }
            }

            Rectangle {
                id: pauseButton_id
                width: 20
                height: 20
                color: "transparent"
                anchors.left: playButton_id.right

                Text {
                    text: "||"
                    color: "maroon"
                    font.pointSize: 18
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video_id.pause()
                    }
                }
            }
        }

        FileDialog {
            id: fileDialog_id
            title: "Please choose a file"
            nameFilters: ["Video Files (*.mp4 *.mov *.wmv *mkv)"]

            onAccepted: {
                selectfilebutton_id.visible = false
                video_id.play()
                console.log("Loaded File: " + fileDialog_id.currentFile)
            }

            onRejected: {
                console.log("Error! No file was selected to play")
            }
        }
    }
}
