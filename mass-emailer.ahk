#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ./util/csv.ahk
CoordMode("ToolTip", "Screen")
; ============================== VARIABLES ==============================
; Sets the CSV filename
filename := "./CSV/" readSettings("filename")

; Sets the CSV delimiter, since you might want to include commas in the text
theDelimeter :=  readSettings("delimiter") || ","

; Generates the CSV matrix
dataMatrix := csvLoad(filename, theDelimeter)

; Stores the current row number, and the row itself as an array for easy use
currentRow := readSettings("currentRow") || 1
row := dataMatrix[currentRow]

; Stores email info on start for the tooltip
emailAdress := row[1]
name := row[2]
subject := row[3]

; Whether or not testing mode is active
testingMode := readSettings("testingMode") || 0

; Whether or not autorun is enabled
autorunMode := readSettings("autorun") || 0

; ============================== UTILITY FUNCTIONS ==============================
; Function for handling the email template and updating the variables
setEmailVariables(){
    global
    ; The numbers in each row correspond to the columns in the loaded spreadsheet
    ; Additional columns holding custom text can be added in the same format as you see here, and added to the email body by surrounding it with quotations and a space, as demonstrated via the replacement of 'name' and this example:
    ; " customText "
    emailAdress := row[1]
    name := row[2]
    subject := row[3]

    ; Generally, all text can be entered without issue. However, '`n' represents a new line, '`r' represents a carrige return, and '`b' represents a backspace.
    emailBody :=
    (
        "Dear " name ",

        I hope all is well. I am writing this email to test this program.

        Sincerely,
        John Doe
        "
    )
}

; Create a new email pasting variables and running the correct functions
writeEmail(){
    ; Not strictly necessary, but I'm including it here for potential edge cases where the variables might not have been updated
    ; Also ensures emailBody is set the first time thes script runs
    setEmailVariables()

    ; Opens compose 
    SendInput("c")

    A_Clipboard := emailAdress
    SendInput("^v")
    SendInput("{Tab}")

    A_Clipboard := subject
    SendInput("^v")
    SendInput("{Tab}")

    A_Clipboard := emailBody
    SendInput("^v")

    changeRowNumber(1)
    tooltipUpdater()
}


; Increment or decrement the row count by the passed amount
changeRowNumber(num){
    global
    currentRow += num
    if(currentRow = dataMatrix.Length + 1){
        currentRow := 1
    } 
    if(currentRow = 0){
        currentRow := dataMatrix.Length
    }
    row := dataMatrix[currentRow]
    setEmailVariables()
    tooltipUpdater()
}

; Shorthand for the ini reader function
readSettings(keyName){
    Return IniRead("./settings.ini", "Settings", KeyName)
}

; Tooltip Updater
tooltipUpdater(){
    global
    tooltipText := "Current Row: " currentRow "`nCurrent Name: " name
    ; Notify users if testing mode is enabled
    if(testingMode = 1){
        tooltipText .= "`nTESTING MODE"
    }
    ToolTip(tooltipText, 0, 0)
}

; Toggling testing mode
toggleTestingMode(){
    global
    testingMode := testingMode ? 0 : 1
    tooltipUpdater()
}

; Function to run on Exit, saving our current location
saveCurrentRow(exitReason, exitCode){
    IniWrite(currentRow, "./settings.ini", "Settings", "currentRow")
}

; Auto run function
autorun(){
    writeEmail()
    SendInput("^{Enter}")
    if(currentRow = dataMatrix.Length){
        currentRow := 1
        MsgBox("Reached end of data. Program will now quit")
        ExitApp
    }
    Sleep(500)
    autorun()
}

; ============================== FUNCTION CALLS ==============================
; Call these functions when the script starts
tooltipUpdater()
OnExit(saveCurrentRow)

; ============================== HOTKEYS ==============================
; Generates new email
a::writeEmail()

; Sends email if not in testing mode
#HotIf testingMode = 0
s::{
    SendInput("^{Enter}")
    if(autorunMode){
        autorun()
        Return
    }
    if(currentRow = dataMatrix.Length){
        currentRow := 1
        MsgBox("Reached end of data. Program will now quit")
        ExitApp
    }
}
#HotIf 

; Deletes email
d::^+d

; Toggle testing mode
F1::toggleTestingMode()

; Custom increment or decrement current row
Up::changeRowNumber(1)
Down::changeRowNumber(-1)

; Suspend and Quit hotkeys
#SuspendExempt True
; The suspend shortcut also disables the tooltip
F2::Suspend(-1)
F3::ExitApp
#SuspendExempt False

; ============================== HANDLES SUSPENDING TOOLTIP ON SUSPEND ==============================
SuspendC := Suspend.GetMethod("Call")
Suspend.DefineProp("Call", {
Call:(this, mode:=-1) => (SuspendC(this, mode), OnSuspend(A_IsSuspended))
})
OnMessage(0x111, OnSuspendMsg)
OnSuspendMsg(wp, *) {
    if ((wp = 65305) || (wp = 65404)){
        OnSuspend(!A_IsSuspended)
    }
}

; wp numbers grabbed via this bit of code
; OnMessage(0x111, WM_COMMAND)

; WM_COMMAND(wparam, lparam, msg, hwnd) {
;     OutputDebug "wp: " wparam " | lp: " lparam "`n"
; }
OnSuspend(mode) {
    global
    if (mode = 1){
        ToolTip()
    } else if (mode = 0){
        tooltipUpdater()
    }
}