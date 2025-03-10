import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Mordle 1.0
import QtGraphicalEffects 1.0
import "./"


Window {
    visible: true
    width: 1200
    height: 650
    title: qsTr("Mordle")


    MordleLogic { id: game }

    Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.8; color: "#181e1e" }
                GradientStop { position: 0.2; color: "#300033" }
            }
        }




    Column {
        id: parentColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        MordleGrid {
            id: grid
            anchors.left: parent.left
            anchors.leftMargin: 60
        }

        MordleKeyboard { id: keyboard }

        // Add a letter to the current row if it's not full
        function addLetter(letter) {
            let rowStart = 5 * game.currentRow;
            let filledCount = grid.letters.slice(rowStart, rowStart + 5).filter(l => l !== "").length;
            if (filledCount < 5) {
                grid.updateLetter(rowStart + filledCount, letter.toUpperCase());
            }
            errorMessage.text = ""; // Clear any previous error message
        }

        // Remove the last letter from the current row if there’s one
        function backspace() {
            let rowStart = 5 * game.currentRow;
            let filledCount = grid.letters.slice(rowStart, rowStart + 5).filter(l => l !== "").length;
            if (filledCount > 0) {
                grid.updateLetter(rowStart + filledCount - 1, "");
            }
            errorMessage.text = ""; // Clear any previous error message
        }

        // Submit the guessed word and handle validation
        function submitGuess() {
            let guess = grid.letters.slice(5 * game.currentRow, 5 * game.currentRow + 5).join("").toUpperCase();
            if (guess.length < 5) {
                errorMessage.text = "Word must be 5 letters!";
                return;
            }
            if (!game.isValidWord(guess)) {
                errorMessage.text = "This word is not in the list!";
                return;
            }
            let result = game.checkGuess(guess);
            grid.checkRow(result);
            checkWinOrLose();
            updateKeyboardColors(result, guess);
        }

        // Check if the player won or lost
        function checkWinOrLose() {
            let row = grid.letters.slice(5 * (game.currentRow - 1), 5 * game.currentRow).join("").toUpperCase();
            if (row === game.targetWord && game.currentRow > 0) {
                winPanel.visible = true;
            } else if (game.currentRow === 6) {
                losePanel.visible = true;
            }
        }

        // Update keyboard key colors based on the guess result
        function updateKeyboardColors(result, guess) {
            for (let i = 0; i < 5; i++) {
                let letter = guess[i];
                let color = result[i] === "G" ? "green" : result[i] === "Y" ? "yellow" : "grey";
                keyboard.updateKeyColor(letter, color);
            }
        }
    }

    // Error message display below the grid
    Text {
        id: errorMessage
        anchors.top: parentColumn.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "red"
        font.pixelSize: 24
        visible: text !== ""
    }

    // Win panel with a "New Game" button
    Rectangle {
        id: winPanel
        anchors.fill: parent
        color: "black"
        opacity: 0.7
        visible: false

        Rectangle {
            id: winContent
            anchors.centerIn: parent
            width: 400
            height: 200
            color: "#ffffff"
            radius: 10  // Yuvarlak kenarlar
            border.color: "#333333"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "Congratulations, You Won!\nFound in " + game.currentRow + " guesses!"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                color: "black"  // Kontrast için
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                text: "New Game"
                onClicked: resetGame()
                background: Rectangle {
                    radius: 5  // Butonun yuvarlak kenarları
                    color: parent.hovered ? "#228B22" : "#32CD32"  // Hover efekti
                }
            }

            // Gölge efekti (radius ile uyumlu)
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8
                samples: 16
                color: "#40000000"  // Hafif siyah gölge
            }
        }
    }

    // Lose panel with the target word and a "New Game" button
    Rectangle {
        id: losePanel
        anchors.fill: parent
        color: "black"
        opacity: 0.7
        visible: false

        Rectangle {
            id: loseContent
            anchors.centerIn: parent
            width: 400
            height: 200
            color: "#ffffff"
            radius: 10  // Yuvarlak kenarlar
            border.color: "#333333"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "You Lost!\nTarget word was: " + game.targetWord
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                color: "black"  // Kontrast için
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                text: "New Game"
                onClicked: resetGame()
                background: Rectangle {
                    radius: 5  // Butonun yuvarlak kenarları
                    color: parent.hovered ? "#C71585" : "#FF69B4"  // Hover efekti
                }
            }

            // Gölge efekti (radius ile uyumlu)
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8
                samples: 16
                color: "#40000000"  // Hafif siyah gölge
            }
        }
    }

    // Debug panel to show game state
    Rectangle {
        id: debugPanel
        width: 300
        height: 150
        color: "#555555"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        visible: false // Initially not visible, will triggered by shift+v inputs.

        Text {
            id: debugText
            anchors.fill: parent
            anchors.margins: 5
            color: "white"
            font.pixelSize: 14
            wrapMode: Text.Wrap
            text: "Target: " + game.targetWord + "\nRow: " + game.currentRow
        }
    }

    // Shortcut to toggle debug panel visibility with Shift+V
    Shortcut {
        sequence: "Shift+V"
        onActivated: debugPanel.visible = !debugPanel.visible
    }

    // Reset the game state for a new round
    function resetGame() {
        game.selectRandomWord();
        grid.clearRow();
        game.setCurrentRow(0); // Reset current row to 0
        winPanel.visible = false;
        losePanel.visible = false;
        errorMessage.text = "";
        keyboard.resetColors();
    }
}
