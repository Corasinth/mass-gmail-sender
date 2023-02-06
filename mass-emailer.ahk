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

; Start tooltip
tooltipUpdater()
; ============================== UTILITY FUNCTIONS ==============================
; Function for handling the email template and updating the variables 


; row[1] = Email Address
; row[2] = Name
; row[3] = Subject
; row[4+] = Custom Text

; var1 := "text1"
; var2 := "text2"
; var3 :=
; ( LTrim
;     "line1: " var1 "
 
; 	line2: " var2 ""
; )
; MsgBox(var3)

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

; Function to run on Exit, saving our current location

; ============================== HOTKEYS ==============================
; Generates new email

; Sends email if not in testing mode

; Deletes email

; Toggle testing mode

; Custom increment or decrement current row

; Suspend and Quit hotkeys