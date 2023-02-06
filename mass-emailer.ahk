#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ./util/csv.ahk
; ============================== VARIABLES ==============================
; Sets the CSV filename
filename := "./" readSettings("filename")

; Generates the CSV matrix
dataMatrix := csvLoad(filename)

; Stores the current row number, and the row itself as an array for easy use
currentRow := readSettings("currentRow") || 1
row := dataMatrix[currentRow]

; Whether or not testing mode is active
testingMode := readSettings("testingMode") || 1

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

    emailBody :=
    (
        "Dear " name ",
        
        I hope all is well. I am writing this email to test this program. 

        Sincerely, 
        John Doe
        "
    )
}

; Shorthand for the ini reader function
readSettings(keyName){
    Return IniRead("./settings.ini", "Settings", KeyName)
}

; Tooltip Updater
tooltipUpdater(){
    tooltipText := "Current Row: " currentRow
    ; Notify users if testing mode is enabled
    if(testingMode = 1){
        tooltipText .= "`nTESTING MOD"
    }
    ToolTip(tooltipText, 0, 0)
}

; Toggling testing mode
toggleTestingMode(){
    testingMode := testingMode ? 0 : 1
}

; Function to run on Exit, saving our current location
saveCurrentRow(exitReason, exitCode){
    IniWrite(currentRow, "./settings.ini", "Settings", "currentRow")
}

; ============================== FUNCTION CALLS ==============================
; Call these functions when the script starts
tooltipUpdater()
OnExit(saveCurrentRow)

; ============================== HOTKEYS ==============================
; Generates new email

; Sends email if not in testing mode

; Deletes email

; Toggle testing mode

; Custom increment or decrement current row

; Suspend and Quit hotkeys
