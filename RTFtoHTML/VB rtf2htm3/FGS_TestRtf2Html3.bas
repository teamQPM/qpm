Attribute VB_Name = "Module2"
Option Explicit

Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Function ShowCodes(strWordTmp As String)
    'for debugging the codes arrays
    Dim strTmp As String
    Dim l As Long
    
    If Len(Codes(UBound(Codes)).Code & CodesBeg(UBound(CodesBeg)).Code & NextCodes(UBound(NextCodes)) & NextCodesBeg(UBound(NextCodesBeg)) & strCurPhrase) > 0 Then
        strTmp = GetCodes(strWordTmp)
        rtf2htmlTest.tbHTML.Text = strCurPhrase
        rtf2htmlTest.tbDebug.Text = strTmp
        While Not gStep
            DoEvents
        Wend
        gStep = False
    End If
End Function

Function OpenFile(strRepPath As String) As Long
    Open strRepPath For Output As #1
End Function

Function GetHeader() As String
    Dim strTmp As String
    
    strTmp = "<!doctype html public '-//W3C//DTD HTML Experimental 19960712//EN'>" & vbCrLf
    strTmp = strTmp & "<HTML>" & vbCrLf
    strTmp = strTmp & "<HEAD>" & vbCrLf
    strTmp = strTmp & "<TITLE>RTF2HTML Test</TITLE>" & vbCrLf
    
    GetHeader = strTmp
End Function

Function PrintHTML(ByVal strTmp As String, Optional strNewLine As Boolean = False) As Long
    If strNewLine Then strTmp = strTmp & "<br>" & vbCrLf
    
    Print #1, strTmp
End Function

Function GetDir(ByVal strPath As String, ByVal iAttr As Integer) As String
    On Error GoTo herr
    
    GetDir = Dir(strPath, iAttr)
    Exit Function
herr:
    GetDir = "error"
End Function

Function FileExist(Filename As String) As Boolean
    On Error GoTo herr
    FileExist = (Dir(Filename) <> "")
    Exit Function
    
herr:
    FileExist = False
End Function

Function CloseFile() As Long
    Close #1
End Function

Function GetFooter() As String
    Dim strTmp As String
    
    strTmp = "</BODY>" & vbCrLf
    strTmp = strTmp & vbCrLf
    strTmp = strTmp & "</html>"

    GetFooter = strTmp
End Function

