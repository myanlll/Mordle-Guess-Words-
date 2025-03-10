import QtQuick 2.12

Rectangle {
    id: keyboard
    width: 450
    height: 160
    color: "transparent"

    property var keyColors: ({})

    Column {
        id: keyboardColumn
        spacing: 8
        anchors.centerIn: parent

        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater { model: ["Q","W","E","R","T","Y","U","I","O","P"]
                Rectangle {
                    width: 38; height: 38;
                    color: keyboard.keyColors[modelData] || "#2F2F3A";
                    radius: 5;
                    Text { text: modelData; anchors.centerIn: parent; font.pixelSize: 22; color: "#E5E5EA" }
                    MouseArea { anchors.fill: parent; onClicked: parentColumn.addLetter(modelData) }
                }
            }
        }

        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater { model: ["A","S","D","F","G","H","J","K","L"]
                Rectangle {
                    width: 38; height: 38;
                    color: keyboard.keyColors[modelData] || "#2F2F3A";
                    radius: 5;
                    Text { text: modelData; anchors.centerIn: parent; font.pixelSize: 22; color: "#E5E5EA" }
                    MouseArea { anchors.fill: parent; onClicked: parentColumn.addLetter(modelData) }
                }
            }
        }

        Row {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater { model: ["Z","X","C","V","B","N","M"]
                        Rectangle {
                            width: 38; height: 38;
                            color: keyboard.keyColors[modelData] || "#2F2F3A";
                            radius: 5;
                            Text { text: modelData; anchors.centerIn: parent; font.pixelSize: 22; color: "#E5E5EA" }
                            MouseArea { anchors.fill: parent; onClicked: parentColumn.addLetter(modelData) }
                        }
                    }
                    Rectangle {
                        id: enterKey
                        width: 58; height: 38;
                        color: "#2A403D";
                        radius: 5;
                        Text { text: "↵"; anchors.centerIn: parent; font.pixelSize: 24; color: "#E5E5EA" }
                        MouseArea { anchors.fill: parent; onClicked: parentColumn.submitGuess() }
                    }
                    Rectangle {
                        id: backspaceKey
                        width: 58; height: 38;
                        color: "#2A403D";
                        radius: 5;
                        Text { text: "⌫"; anchors.centerIn: parent; font.pixelSize: 24; color: "#E5E5EA" }
                        MouseArea { anchors.fill: parent; onClicked: parentColumn.backspace() }
                    }
                }
            }

    // Updates key color with green priority
    function updateKeyColor(letter, color) {
        letter = letter.toUpperCase()
        if (color === "green" || !keyColors[letter] || keyColors[letter] === "grey") {
            keyColors[letter] = color
            for (let i = 0; i < keyboardColumn.children.length; i++) {
                let row = keyboardColumn.children[i]
                if (row instanceof Row) {
                    for (let j = 0; j < row.children.length; j++) {
                        let rect = row.children[j]
                        if (rect instanceof Rectangle && rect.children[0].text === letter) rect.color = color
                    }
                }
            }
        }
    }
    // Resets all keys to default color except enter and backspace
        function resetColors() {
            keyColors = {}
            for (let i = 0; i < keyboardColumn.children.length; i++) {
                let row = keyboardColumn.children[i]
                if (row instanceof Row) {
                    for (let j = 0; j < row.children.length; j++) {
                        let rect = row.children[j]
                        if (rect instanceof Rectangle && rect !== enterKey && rect !== backspaceKey) {
                            rect.color = "#2F2F3A"
                        }
                    }
                }
            }
        }
    }
