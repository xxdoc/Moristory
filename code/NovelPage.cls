VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NovelPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim BG As String, FG As String, BGCOLOR As Long
    Dim CuLine As Long, NLines() As String
    Dim Mode As String, PART As String
    Dim LLineTime As Long
    Dim DisplayText As String
    Dim Title As String
    Private Type Role
        name As String
        Love As Long
        Face As String
    End Type
    Private Type Answer
        Caption As String
        LoveIncrase As Long
        JTimeLine As Long
    End Type
    Private Type Question
        Title As String
        Answers() As Answer
    End Type
    Dim Roles() As Role
    Dim Speaker As String
    Dim SpeakerName As String
    Dim TimeLine As Long
    Dim QuesTime As Long, Ques As Question, BlurDC As Long
'======================================
Public Function GetSpeakerName(Speaker As String) As String
    GetSpeakerName = "������"
    Select Case Speaker
        Case "aside": GetSpeakerName = "�԰�"
        Case "bm": GetSpeakerName = "����"
        Case "me": GetSpeakerName = "��"
        Case "xx": GetSpeakerName = "����"
        Case "fj": GetSpeakerName = "����"
        Case "s": GetSpeakerName = "��"
        Case "kx1": GetSpeakerName = "����"
        Case "kx2": GetSpeakerName = "����"
        Case "km1": GetSpeakerName = "����"
        Case "km2": GetSpeakerName = "����"
        Case "jy": GetSpeakerName = "����"
        Case "xl": GetSpeakerName = "ѩ��"
        Case "ssr": GetSpeakerName = "ɯɪ��"
        Case "tk": GetSpeakerName = "����"
        Case "dn": GetSpeakerName = "����"
        Case "yz": GetSpeakerName = "ѿ��"
        Case "bg": GetSpeakerName = "����"
        Case "yy1": GetSpeakerName = "����"
        Case "yy2": GetSpeakerName = "����"
        Case Else
            If InStr(Speaker, "dark") = 1 Then SpeakerName = "������"
    End Select
End Function
Public Sub RunNovel()
Exec:
    If CuLine > UBound(NLines) Then Exit Sub

    Dim IsCmd As Boolean, Params() As String
    Dim JumpTimeline As Boolean, AnswerStep As Long
    IsCmd = (InStr(NLines(CuLine), "\") <> 0)
    If IsCmd Then
        Params = Split(NLines(CuLine), "\")
        '��ȡ����
        If AnswerStep > 0 Then
            With Ques.Answers(UBound(Ques.Answers) - AnswerStep)
                .Caption = Params(0)
                .JTimeLine = Val(Params(1))
                .LoveIncrase = Val(Params(2))
            End With
            AnswerStep = AnswerStep - 1
            CuLine = CuLine + 1
            QuesTime = GetTickCount
            If AnswerStep = 0 Then Exit Sub
            GoTo Exec
        End If
        '�ⲻ�����ʱ���ߵľ��顣����
        If JumpTimeline Then
            If UBound(Params) = 2 Then
                If Params(0) <> "timeline" And Params(2) <> "end" And JumpTimeline Then
                    CuLine = CuLine + 1: GoTo Exec
                Else
                    JumpTimeline = False
                    CuLine = CuLine + 1: GoTo Exec
                End If
            Else
                CuLine = CuLine + 1: GoTo Exec
            End If
        End If
        
        Select Case Params(0)
            Case "question"
                AnswerStep = Val(Params(2))
                Ques.Title = Params(1)
                ReDim Ques.Answers(AnswerStep)
                BlurTo BlurDC, GDC, GameWindow
                Mode = "question"
            Case "timeline"
                If Params(2) = "head" Then
                    If TimeLine <> Val(Params(1)) Then JumpTimeline = True: GoTo Exec
                ElseIf Params(2) = "end" And JumpTimeline = True Then
                    JumpTimeline = False: GoTo Exec
                End If
            Case "face"
                For i = 1 To UBound(Roles)
                    If Roles(i).name = Params(1) Then
                        Roles(i).Face = Params(2): Exit For
                    End If
                Next
                ECore.NewTransform
            Case "role"
                If Params(2) = "add" Then
                    ReDim Preserve Roles(UBound(Roles) + 1)
                    With Roles(UBound(Roles))
                        .name = Params(1)
                        .Face = "normal"
                        .Love = Val(ESave.GetData(.name & "'s love"))
                    End With
                ElseIf Params(2) = "remove" Then
                    For i = 1 To UBound(Roles)
                        If Roles(i).name = Params(1) Then
                            Roles(i) = Roles(UBound(Roles)): Exit For
                        End If
                    Next
                    ReDim Preserve Roles(UBound(Roles) - 1)
                End If
                ECore.NewTransform
            Case "say"
                DisplayText = ""
                Speaker = Params(1)
                SpeakerName = GetSpeakerName(Speaker)
            Case "clear"
                DisplayText = ""
                ECore.NewTransform
            Case "*bgm"
                BGM.Create App.path & "\music\bgm\" & Params(1)
                BGM.Play
            Case "*bgs"
                BGS.Create App.path & "\music\bgs\" & Params(1)
                BGS.Play
            Case "*play"
                SE.Play Params(1)
            Case "*title"
                Title = Params(1)
                GameWindow.Caption = "Moristory DEMO - PART " & PART & " , " & Title
            Case "*bg"
                BGCOLOR = argb(255, 0, 0, 0)
                BG = Params(1)
                ECore.NewTransform
            Case "*fg"
                BGCOLOR = argb(255, 0, 0, 0)
                FG = Params(1)
                ECore.NewTransform
            Case "*mode"
                Mode = Params(1)
            Case "effect"
                Select Case Params(1)
                    Case "light"
                        ECore.NewTransform transHighLight, 600
                    Case "dark"
                        ECore.NewTransform transFallDark, 600
                End Select
            Case "bg"
                Dim temp() As String
                temp = Split(Params(1), ",")
                BGCOLOR = argb(255, temp(0), temp(1), temp(2))
                BG = "": FG = ""
                ECore.NewTransform
            Case "window"
                If Params(1) = "Moristory" Then
                    GameWindow.Caption = "Moristory DEMO - PART " & PART & " , " & Title
                Else
                    GameWindow.Caption = Params(1)
                End If
            Case "*turn"
                ESave.PutData "PART", Params(1)
                ECore.NewTransform transFallDark, 1000
                Call ReadNovel
                Exit Sub
        End Select
    ElseIf Left(NLines(CuLine), 1) <> "#" Then
        If JumpTimeline Then CuLine = CuLine + 1: GoTo Exec
        If NLines(CuLine) = "++" Then
            DisplayText = ""
            If UBound(Roles) = 0 Then
                Speaker = IIf(Speaker = "me", "", "me")
            Else
                Speaker = IIf(Speaker = "me", Roles(1).name, "me")
            End If
            SpeakerName = GetSpeakerName(Speaker)
        Else
            DisplayText = DisplayText & NLines(CuLine) & vbCrLf
            If Mode <> "scroll" Then ECore.NewTransform
            If Mode = "scroll" Then LLineTime = GetTickCount
            CuLine = CuLine + 1
            Exit Sub
        End If
    End If
    
    If Mode = "scroll" Then LLineTime = GetTickCount
    
    CuLine = CuLine + 1
    
    GoTo Exec
End Sub
Public Sub ReadNovel()
    PART = ESave.GetData("PART")
    If PART = "" Then PART = "0"
    TimeLine = Val(ESave.GetData("TIMELINE"))
    If TimeLine = 0 Then TimeLine = 1
    
    Dim temp As String, text As String
    
    Open App.path & "\article\PART " & PART & ".mss" For Input As #1
    Do While Not EOF(1)
        Line Input #1, temp
        text = text & temp & vbCrLf
    Loop
    Close #1
    NLines = Split(text, vbCrLf)
    
    CuLine = 0
    DisplayText = ""
    BG = "": FG = "": BGCOLOR = argb(255, 0, 0, 0)
    ReDim Roles(0)
    BGM.Dispose
    BGS.Dispose
    
    Call RunNovel
    
End Sub
Public Sub DrawQues()
    Dim pro As Single
    pro = (GetTickCount - QuesTime) / 1000
    pro = 1 - pro
    If pro < 0 Then pro = 0
    pro = Cubic(pro, 0, 0, 0, 1)

    PaintDC BlurDC, Page.CDC, 0, 0, Alpha:=1 - pro * 1
    Page.Paint 0, 0, 0, GW + 1, GH + 1, argb(130 - pro * 130, 0, 0, 0)
    
    Page.DrawImage "questionpad.png", GW / 2, GH / 2 + 200 + pro * 500, Alpha:=1, pos:=posOnCenter
    Page.Writes SpeakerName, GW / 2 - 208, GH / 2 - 59 + pro * 500, 24, argb(255, 255, 255, 255), align:=StringAlignmentCenter
    Page.Writes Ques.Title, GW / 2 + 15, GH / 2 - 53 + pro * 500, 18, argb(255, 27, 27, 27), align:=StringAlignmentCenter
    
    Dim m As Long, aw As Long, ah As Long
    aw = Page.Res.ImgSize("answerpad.png", imgGetWidth)
    ah = Page.Res.ImgSize("answerpad.png", imgGetHeight)
    
    For i = 0 To UBound(Ques.Answers) - 1
        m = CheckMouse(GW / 2, GH / 2 - 59 + 170 + i * 70 + pro * 500, aw, ah)
        Page.DrawImage "answerpad.png", GW / 2, GH / 2 - 59 + 170 + i * 70 + pro * 500, Alpha:=IIf(m <> 0, 1, 0.5), pos:=posOnCenter
        Page.Writes (i + 1) & ". " & Ques.Answers(i).Caption, GW / 2 - 200, GH / 2 - 59 + 170 + i * 70 - 12 + pro * 500, 16, argb(200, 27, 27, 27)
        If m = 3 Then
            Mode = "msg"
            ECore.NewTransform
            If Ques.Answers(i).JTimeLine <> 0 Then TimeLine = Ques.Answers(i).JTimeLine
            For s = 1 To UBound(Roles)
                If Roles(s).name = Speaker Then
                    Roles(s).Love = Roles(s).Love + Ques.Answers(i).LoveIncrase
                    ESave.PutData Roles(s).name & "'s love", Roles(s).Love
                    Exit For
                End If
            Next
            Call RunNovel
        End If
    Next
End Sub
Public Sub DrawMsg()
    Page.Paint 0, 0, 0, GW + 1, GH + 1, argb(130, 0, 0, 0)
    
    For i = 1 To UBound(Roles)
        Page.DrawImage Roles(i).name & ".png", GW / 2 - 120 * UBound(Roles) / 2 + (i - 1) * 120 - 120 / 2, GH + 80, Alpha:=IIf(Speaker <> Roles(i).name And Speaker <> "aside", 0.7, 1), pos:=posOnBottom
    Next
    
    Page.DrawImage "dialog.png", GW / 2, GH - 130, Alpha:=1, pos:=posOnCenter
    If CheckMouse2 = mMouseUp Then Call RunNovel
    
    Page.Writes DisplayText, GW / 2 - 300, GH - 190, 18, argb(200, 27, 27, 27)
    Page.Writes SpeakerName, GW / 2 - 5, GH - 78, 24, argb(255, 255, 255, 255), align:=StringAlignmentCenter
    
End Sub
Public Sub DrawScroll()
    Page.Paint 0, 0, 0, GW + 1, GH + 1, argb(170, 0, 0, 0)
    If CheckMouse(0, 0, GW, GH) = mMouseUp Then
        Call RunNovel: SE.Play "Cursor.mp3"
    End If
    
    Dim Lines() As String, pro As Single
    Lines = Split(DisplayText, vbCrLf)
    pro = (GetTickCount - LLineTime) / 1500
    If pro > 1 Then pro = 1
    pro = Cubic(pro, 0, 1, 1, 1)
    
    Dim Y As Long
    Y = GH / 2 - (UBound(Lines) - 2) * 50 - 50 * pro
    For i = 0 To UBound(Lines) - 1
        Page.Writes Lines(i), GW / 2, Y, 20, argb(IIf(i = UBound(Lines) - 1, pro, 1) * 255, 255, 255, 255), align:=StringAlignmentCenter
        Y = Y + 50
    Next
    
    If GetTickCount - LLineTime >= 5000 Then Call RunNovel
End Sub
Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    
    Page.Clear BGCOLOR  '��ջ���
    If BG <> "" Then Page.DrawImage BG, 0, 0, Alpha:=1
    If FG <> "" Then Page.DrawImage FG, 0, 0, Alpha:=1
    
    
    If Mode = "msg" Then
        Call DrawMsg
    ElseIf Mode = "scroll" Then
        Call DrawScroll
    ElseIf Mode = "question" Then
        Call DrawQues
    End If
    
    If BGM.PlayState = musStopped And BGM.length <> 0 Then BGM.Play
    If BGS.PlayState = musStopped And BGS.length <> 0 Then BGS.Play
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(ID As String, Msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(ID As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.NewImages App.path & "\assets\bg", 1000, 740
    Page.Res.NewImages App.path & "\assets\fg", 1000, 740
    Page.Res.NewImages App.path & "\assets\ui", 0.68
    Page.Res.NewImages App.path & "\assets\face", 1
    '����ҳ��
    ECore.Add Page, "NovelPage"
    ReDim NLines(0)
    BlurDC = CreateCDC(GW, GH)
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub
