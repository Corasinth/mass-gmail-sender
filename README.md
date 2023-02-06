# Mass Emailer

## Description 

This is a simple program for sending multiple emails with custom text via a CSV file. It's designed for Gmail, however with some familiarity with AHK you can tweak it to work with other clients pretty simply. 

As an AHK program it unfortunately only works with Windows operating systems.

## Table of Contents


* [Installation](#installation)
    * [Configuration](#configuration)
* [Usage](#usage)
    * [Spreadsheet](#spreadsheet)
    * [Constructing the Template](#constructing-the-template)
    * [Controls](#controls)
* [Features](#features)
* [Contributing](#contributing)
* [License](#license)


## Installation

To use this program, you must first install AutoHotKey V2, which [you can do here](https://www.autohotkey.com/v2/). You also need to turn on the keyboard shortcuts in Gmail. You can do this via Settings>General Settings>Keyboard Shortcuts.

Finally, simply download this repo directly and run the `mass-emailer.ahk` file.

### Configuration

The `settings.ini` file contains several useful settings. 

Firstly, the `filename` setting contains the name of the CSV file with the email data you wish to use. An example name sits there; do not neglect the double quotes.

Secondly, the `currentRow` setting contains the row the program will start from. This will automatically be updated if you quit the program before finishing a file, but you can also set it manually if you want to skip the first few lines, or start in the middle for some reason.

Thirdly, `testingMode` can be enabled by setting it to `1`. This disables the ability to send an email via the hotkey, and is meant for testing that an email template or CSV file is working correctly.

Fourthly, `delimiter` is used if you set a custom delimeter in the CSV file. You might want to do this if you have custom text that includes commas, as that might cause the script to incorrectly detect that some piece of text is in a different cell.

Lastly, `autoRun`, which can also be activated by setting it to `1` before starting the program, will send all emails as soon as you send the first email. Usually, the program opens an email, then lets you send it manually. Autorun will loop the process without requiring your involvement.

## Usage 

To use this mass emailer you must first set up a spreadsheet with your email data and a template. 

### Spreadsheet 

Each row of the spreadsheet should contain the details for one email.

By default, the first column contains the email address, the second the recepient's first name, next the recepient's last name, then the subject line, and all further columns custom text which will be inserted into the email template as you desire. You can leave a column blank, but you cannot omit it entirely without editing the variables directly.

You must save the CSV file inside the CSV folder, and add the file name to the `settings.ini` file as the example in the file indicates

### Constructing The Template 

The template itself can be simply written out and pasted in the appropriate location near the top of `mass-emailer.ahk`. A placeholder email exists to point the way, and the just a few lines above the parantheses that contain the email body is the label 'email body'.

To insert custom text you'll need to do the following. 

First, identify which column the custom text you want to insert belongs to. Custom text columns usually start at 5 and up. Once you have that number you can use it to creat a pointer to your custom text. Here is an example of two pieces of custom text in the fourth and fifth columns being pointed to:
```
dataMatrix[5]
dataMatrix[6]
```

When inserting these pointers into your email template, you need to surround them with double quotes and empty spaces, like so: `" dataMatrix[5] "`. Adjacent pieces of custom text need a space between them as shown below. 
```
This sentence is part on an email body, prefacing two pieces of custom text: " dataMatrix[5] " " dataMatrix[6] ". 
```
At this time the program does not support custom images or HTML. 

### Controls

These are the controls for this program.

`a`:: Opens a new email and auto-populates it.  
`s`:: Sends the open email.   
`d`:: Discards the draft of the current email.  
`Up Arrow Key`:: Increments the current row by one. Loops around if you reach the last row.  
`Down Arrow Key`:: Decrements the current row by one. Loops around if you reach the first row.   
`F1`:: Toggles testing mode.  
`F2`:: Suspends program and all hot keys except F2 and F3.    
`F3`:: Quits the program.  

## Features

In addition to the features mentioned previously, the script also runs a tooltip in the top right corner of the screen displaying the current row and the name of the current email recepient.

## Contributing

If you have suggestions, feel free to fork/open a pull request. Future areas of work include the ability to add custom HTML and images, and making the script more user-friendly, perhaps with a GUI.

## [License](./LICENSE)
This website uses the open-source MIT License.

--- 