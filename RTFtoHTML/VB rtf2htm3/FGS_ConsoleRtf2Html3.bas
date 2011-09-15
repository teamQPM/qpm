Attribute VB_Name = "Module1"
Private Sub Main()
    Dim cParm As String
    Dim cFileRtf As String
    Dim cFileHtml As String
    Dim cAux
    Dim cMemoRtf As String
    Dim cMemoHtml As String
    Dim nBuffer As Long
    Dim nLenRtf As Long
    Dim nAcum As Long
    Dim nSalir As Integer
    nBuffer = 1024
    nSalir = 0
    cParm = Command()
    'cParm = "D:\Temp\hlp_15"
    'MsgBox cParm, vbOK, "Command Line params"
    cFileRtf = cParm & ".rtf"
    cFileHtml = cParm & ".htm"
    cMemoRtf = ""
    'Open cFileRtf For Input As #1
    Open cFileRtf For Binary As #1
    nLenRtf = LOF(1)
    Do While nSalir = 0
       cAux = Input(nBuffer, #1)
       cMemoRtf = cMemoRtf & cAux
       nAcum = nAcum + nBuffer
       If nAcum >= nLenRtf Then
          nSalir = 1
       End If
    Loop
    Close #1
    'MsgBox (">>>" & cMemoRtf & "<<<")
    cMemoHtml = rtf2html3(cMemoRtf, "+CR+H+G+F=3+T=""RTF2HTML Test""")
    'MsgBox (">>>" & cMemoHtml & "<<<")
    Open cFileHtml For Output As #2
    Print #2, cMemoHtml
    Close #2
End Sub

