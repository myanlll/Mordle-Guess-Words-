#ifndef MORDLELOGIC_H
#define MORDLELOGIC_H
#include <QObject>
#include <QStringList>

class MordleLogic : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString targetWord READ targetWord NOTIFY targetWordChanged)
    Q_PROPERTY(int currentRow READ currentRow WRITE setCurrentRow NOTIFY currentRowChanged)

public:
    explicit MordleLogic(QObject *parent = nullptr);
    QString targetWord() const { return m_targetWord; }
    int currentRow() const { return m_currentRow; }
    Q_INVOKABLE void setCurrentRow(int row);

    Q_INVOKABLE QStringList loadWordList();          // Load words from file
    Q_INVOKABLE void selectRandomWord();             // Pick a random target word
    Q_INVOKABLE QString checkGuess(const QString &guess); // Evaluate the guess
    Q_INVOKABLE bool isValidWord(const QString &word);    // Check if word is valid

signals:
    void targetWordChanged();
    void currentRowChanged();

private:
    QString m_targetWord;
    int m_currentRow = 0;
    QStringList m_wordList;
};
#endif // MORDLELOGIC_H
