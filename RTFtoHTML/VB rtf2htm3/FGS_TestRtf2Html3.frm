VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form rtf2htmlTest 
   Caption         =   "rtf2html"
   ClientHeight    =   7065
   ClientLeft      =   420
   ClientTop       =   525
   ClientWidth     =   14760
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   7065
   ScaleWidth      =   14760
   Begin RichTextLib.RichTextBox tbRTF 
      Height          =   6015
      Left            =   120
      TabIndex        =   15
      Top             =   360
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   10610
      _Version        =   393217
      TextRTF         =   $"FGS_TestRtf2Html3.frx":0000
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   255
      Left            =   3600
      TabIndex        =   14
      Top             =   6720
      Width           =   855
   End
   Begin VB.CommandButton cmdRTF2 
      Caption         =   "->"
      Height          =   255
      Left            =   4080
      TabIndex        =   13
      Top             =   6480
      Width           =   375
   End
   Begin VB.OptionButton rbDebug 
      Caption         =   "Debug Mode"
      Height          =   255
      Left            =   12600
      TabIndex        =   12
      Top             =   6480
      Width           =   1575
   End
   Begin VB.CommandButton cmdRunToEnd 
      Caption         =   ">|"
      Height          =   255
      Left            =   11640
      TabIndex        =   11
      Top             =   6480
      Width           =   375
   End
   Begin VB.CommandButton cmdStep 
      Caption         =   ">"
      Height          =   255
      Left            =   11160
      TabIndex        =   10
      Top             =   6480
      Width           =   375
   End
   Begin VB.TextBox tbDebug 
      Height          =   6015
      Left            =   11040
      MultiLine       =   -1  'True
      TabIndex        =   8
      Top             =   360
      Width           =   3615
   End
   Begin VB.CommandButton cmdHTML2 
      Caption         =   "Browse HTML"
      Height          =   375
      Left            =   8640
      TabIndex        =   7
      Top             =   6480
      Width           =   1335
   End
   Begin VB.CommandButton cmdRTF3 
      Caption         =   "rtf2html"
      Height          =   375
      Left            =   7440
      TabIndex        =   6
      Top             =   6480
      Width           =   1095
   End
   Begin VB.CommandButton cmdRTF 
      Caption         =   "<-"
      Height          =   255
      Left            =   3600
      TabIndex        =   5
      Top             =   6480
      Width           =   375
   End
   Begin VB.TextBox tbRTFCodes 
      Height          =   6015
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   3
      Top             =   360
      Width           =   3135
   End
   Begin VB.TextBox tbHTML 
      Height          =   6015
      Left            =   7320
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   360
      Width           =   3615
   End
   Begin VB.Label Label3 
      Caption         =   "Debug"
      Height          =   255
      Left            =   11040
      TabIndex        =   9
      Top             =   120
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "RTF codes"
      Height          =   255
      Left            =   4080
      TabIndex        =   4
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "HTML"
      Height          =   255
      Left            =   7320
      TabIndex        =   2
      Top             =   120
      Width           =   615
   End
   Begin VB.Label RTF 
      Caption         =   "RTF"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   615
   End
End
Attribute VB_Name = "rtf2htmlTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit








Private Sub cmdClear_Click()
    tbRTFCodes.Text = ""
    tbRTF.TextRTF = ""
End Sub

Private Sub cmdHTML2_Click()
    'view the html code in a browser
    Dim lRetVal As Long
    Dim strRepPath As String
    Dim ret&
    
    strRepPath = "d:\temp\borrar\rtftest.html"
    If GetDir("d:\temp\borrar\", vbDirectory) = "" Then
        MsgBox ("You're going to have to set the path to the directory where you want to store the temporary HTML file.")
    End If
    lRetVal = OpenFile(strRepPath)
    lRetVal = PrintHTML(rtf2html3(tbRTFCodes.Text, "+H+G+F=3+T=""RTF2HTML Test"""))
'    lRetVal = PrintHTML(GetHeader)
'    lRetVal = PrintHTML(tbHTML.Text)
'    lRetVal = PrintHTML(GetFooter)
    lRetVal = CloseFile
    
    ret& = ShellExecute(Me.hWnd, "Open", strRepPath, "", App.Path, 1)
End Sub

Private Sub cmdRTF_Click()
    tbRTF.TextRTF = tbRTFCodes.Text
End Sub

Private Sub cmdRTF2_Click()
    tbRTFCodes.Text = tbRTF.TextRTF
End Sub


Private Sub cmdRTF3_Click()
    If Len(tbRTFCodes.Text) = 0 Then tbRTFCodes.Text = tbRTF.TextRTF
    If Len(tbRTF.TextRTF) = 0 Then tbRTF.TextRTF = tbRTFCodes.Text
    gDebug = rbDebug.Value
    tbHTML.Text = (rtf2html3(tbRTFCodes.Text, "+CR+F=3"))
End Sub




Private Sub cmdRunToEnd_Click()
    rbDebug.Value = False
    gDebug = False
    gStep = True
End Sub

Private Sub cmdStep_Click()
    gStep = True
End Sub


Private Sub Form_Load()
    CenterForm Me
End Sub


Sub CenterForm(TempForm As Form)
    TempForm.Move ((Screen.Width - TempForm.Width) / 2), ((Screen.Height - TempForm.Height) / 2)
End Sub

