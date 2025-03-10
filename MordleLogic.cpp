#include "MordleLogic.h"
#include <QFile>
#include <QTextStream>
#include <QRandomGenerator>

MordleLogic::MordleLogic(QObject *parent) : QObject(parent) {
    m_wordList = loadWordList();
    selectRandomWord();
}

// Loads 5-letter words from a resource file into a list
QStringList MordleLogic::loadWordList() {
    QStringList words;
    QFile file(":/WordList.txt");
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString word = in.readLine().trimmed().toUpper();
            if (word.length() == 5) words << word;
        }
        file.close();
    }
    return words;
}

// Selects a random word from the list as the target
void MordleLogic::selectRandomWord() {
    if (!m_wordList.isEmpty()) {
        m_targetWord = m_wordList[QRandomGenerator::global()->bounded(m_wordList.size())];
        emit targetWordChanged();
    }
}

// Evaluates a guess against the target word
// Returns 'G' (green) for correct position, 'Y' (yellow) for wrong position, 'X' (grey) for not in word
QString MordleLogic::checkGuess(const QString &guess) {
    QString upperGuess = guess.toUpper();
    QString result(5, 'X');
    QHash<QChar, int> letterCounts;

    // Count occurrences of each letter in the target word
    for (const QChar &c : m_targetWord) letterCounts[c]++;

    // First pass: Identify correct positions (green)
    for (int i = 0; i < 5; ++i) {
        if (upperGuess[i] == m_targetWord[i]) {
            result[i] = 'G';
            letterCounts[upperGuess[i]]--;
        }
    }

    // Second pass: Identify correct letters in wrong positions (yellow)
    for (int i = 0; i < 5; ++i) {
        if (result[i] != 'G' && letterCounts.value(upperGuess[i], 0) > 0) {
            result[i] = 'Y';
            letterCounts[upperGuess[i]]--;
        }
    }

    return result;
}

// Sets the current row, restricted to valid range (0-6)
void MordleLogic::setCurrentRow(int row) {
    if (row >= 0 && row <= 6) {
        m_currentRow = row;
        emit currentRowChanged();
    }
}

// Verifies if a word is in the valid word list
bool MordleLogic::isValidWord(const QString &word) {
    return m_wordList.contains(word.toUpper());
}
