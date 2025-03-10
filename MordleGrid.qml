import QtQuick 2.12

Grid {
    id: mordleGrid
    columns: 5
    rows: 6
    spacing: 6
    width: 450
    height: 400

    property var letters: Array(30).fill("")
    property var colors: Array(30).fill("#979ba1") // Soft lavender-grey

    Repeater {
        model: 30
        Item {
            width: 60
            height: 60

            Rectangle {
                id: cell
                anchors.fill: parent
                radius: 8
                color: mordleGrid.colors[index]
                border.color: "#D4D4DC"
                border.width: 1

                Text {
                    id: letterText
                    anchors.centerIn: parent
                    text: mordleGrid.letters[index] || ""
                    font.pixelSize: 34
                    font.weight: Font.Medium
                    color: "#2A2A33"
                }

                // Fade-in and subtle scale for letter entry
                states: State {
                    name: "entered"; when: letters[index] !== ""
                    PropertyChanges { target: letterText; opacity: 1 }
                }
                transitions: Transition {
                    PropertyAnimation { target: letterText; property: "opacity"; from: 0; to: 1; duration: 150 }
                    PropertyAnimation { target: cell; property: "scale"; from: 0.9; to: 1; duration: 150; easing.type: Easing.OutQuad }
                }

                // Smooth color change
                Behavior on color {
                    PropertyAnimation { duration: 200 }
                }
            }
        }
    }

    function updateLetter(index, letter) {
        if (index >= 0 && index < 30) {
            letters[index] = letter
            colors[index] = "#979ba1"
            lettersChanged()
            colorsChanged()
        }
    }

    function clearRow() {
        for (let i = 0; i < 30; i++) {
            letters[i] = ""
            colors[i] = "#979ba1"
        }
        lettersChanged()
        colorsChanged()
    }

    function checkRow(guessResult) {
        for (let i = 0; i < 5; i++) {
            let idx = 5 * game.currentRow + i
            colors[idx] = guessResult[i] === "G" ? "#36C759" : guessResult[i] === "Y" ? "#F7C948" : "#73738C"
        }
        colorsChanged()
        game.setCurrentRow(game.currentRow + 1)
    }
}
