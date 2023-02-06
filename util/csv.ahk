#Requires AutoHotkey v2.0
#SingleInstance Force

csvLoad(filename,  theDelimiter:=","){
    matrix := []

    fileText := FileRead(filename)

    Loop Parse fileText, "`n" {
        rowArr := []
        Loop Parse A_LoopField, theDelimiter, A_Space A_Tab {
            rowArr.Push(A_LoopField)
        }
        matrix.Push(rowArr)
    }
    return matrix
}