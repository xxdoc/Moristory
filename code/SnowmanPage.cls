VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SnowmanPage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim Balls() As Single
    Dim StartTime As Long, BallTime As Long, DrawY As Long
    Dim DeathText As String
'======================================

Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    
    Page.Clear '��ջ���
    
    Dim High As Long, Y As Long
    For i = 1 To UBound(Balls)
        High = High + Balls(i)
    Next
    Y = High - GH / 2
    If Y < 0 Then Y = 0
    If Y > 4040 Then Y = 4040
    DrawY = DrawY + (Y - DrawY) / 10
    
    If High >= 4040 + GH / 2 + 50 Then
        SE.Play "Applause1.mp3"
        NovelPage.RunNovel
        ECore.NewTransform transHighLight, 3000, "NovelPage"
    End If
    
    Page.DrawImage "Snowfield.png", 0, DrawY, Alpha:=1
    Page.DrawImage "Sky.png", 0, DrawY - 4040, Alpha:=1
    
    Page.Writes format(High / 100 * (1 + Cubic(Y / 4040, 0, 0, 0, 1) * 10), "0.00") & " m", GW / 2, 20, 24, argb(200, 27, 27, 27), align:=StringAlignmentCenter
    Dim LeftTime As Long
    LeftTime = 60 - Int((GetTickCount - StartTime) / 1000)
    If LeftTime < 0 Then LeftTime = 0
    
    Page.Writes LeftTime & " s", GW / 2, 60, 24, argb(IIf((LeftTime <= 10) And (GetTickCount Mod 300 < 150), 0, 200), IIf((LeftTime <= 10), 255, 27), 27, 27), align:=StringAlignmentCenter
    
    If LeftTime = 0 Then
        SE.Play "Collapse4.mp3"
        StartTime = GetTickCount + 2000
        BGM.Stops
        BGM.Play
        ReDim Balls(1)
        Balls(1) = 400
        DeathText = "��ʱ��"
        'ECore.NewTransform transFallDark, 2000
    End If
    
    Dim High2 As Long
    For i = 1 To UBound(Balls)
        If GH - 40 + DrawY - High2 <= GH + GW Then
            Page.Paint 1, GW / 2 - Int(Balls(i)) / 2, GH - 40 + DrawY - High2, Int(Balls(i)), Int(Balls(i)), argb(255, 242, 242, 255), Pos:=posOnBottom
            Page.Paint 1, GW / 2 - Int(Balls(i)) / 2, GH - 40 + DrawY - High2, Int(Balls(i)), Int(Balls(i)), argb(255, 212, 212, 225), Size:=2, style:=1, Pos:=posOnBottom
        End If
        High2 = High2 + Balls(i)
    Next
    
    Dim m As Integer
    m = CheckMouse(0, 0, GW, GH)
    If m = MButtonState.mMouseDown And BallTime = 0 And GetTickCount - StartTime <= 60000 Then BallTime = GetTickCount
    If BallTime <> 0 Then
        Dim Size As Single
        Size = (GetTickCount - BallTime) / 700 * 100
        If Size > GW Then Size = GW
        Page.Paint 1, GW / 2 - Int(Size) / 2, GH - 40 + DrawY - High2, Int(Size), Int(Size), argb(255, 242, 242, 255), Pos:=posOnBottom
        Page.Paint 1, GW / 2 - Int(Size) / 2, GH - 40 + DrawY - High2, Int(Size), Int(Size), argb(255, 212, 212, 225), Size:=2, style:=1, Pos:=posOnBottom
        If m = MButtonState.mMouseUp Then
            BallTime = 0
            ReDim Preserve Balls(UBound(Balls) + 1)
            Balls(UBound(Balls)) = Size
            SE.Play "Ice4.mp3"
            If Size > Balls(UBound(Balls) - 1) * 1.1 Then
                SE.Play "Collapse4.mp3"
                StartTime = GetTickCount + 2000
                BGM.Stops
                BGM.Play
                ReDim Balls(1)
                Balls(1) = 400
                DeathText = "�ͷŵ�ѩ��̫��ѩ�˵����ˣ�"
                'ECore.NewTransform transFallDark, 2000
            End If
        End If
    End If
    
    If UBound(Balls) <= 1 Then
        If GetTickCount Mod 300 < 150 Then Page.Writes DeathText, GW / 2, GH / 2 - 18, 36, argb(150, 0, 0, 0), align:=StringAlignmentCenter
    End If
    
    If BGM.PlayState = musStopped And BGM.length <> 0 Then BGM.Play
    If BGS.PlayState = musStopped And BGS.length <> 0 Then BGS.Play
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
    BGM.Create App.Path & "\music\bgm\OST 14 - Snowy.mp3"
    BGM.Play
    StartTime = GetTickCount
    DeathText = "��ס���Ȼ���ͷ�ѩ��"
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
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.newImage App.Path & "\assets\bg\Snowfield.png", GW, GH
    Page.Res.newImage App.Path & "\assets\fg\Sky.png", GW, GH
    '����ҳ��
    ECore.Add Page, "SnowmanPage"
    ReDim Balls(1)
    Balls(1) = 400
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub