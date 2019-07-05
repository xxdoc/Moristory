VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MazePage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim Map() As Integer
    Dim PX As Single, PY As Single
    Dim StartX As Long, StartY As Long, EndX As Long, EndY As Long
    Dim MapDC As Long, CoverDC As Long
'======================================
Public Sub LoadMap()
    Dim w As Long, h As Long, Image As Long, Color As Long

    Page.Res.newImage App.path & "\assets\ui\maze.png"
    Image = Page.Res.ResourceImageHandle(Page.Res.GetImage("maze.png"))
    GdipGetImageWidth Image, w: GdipGetImageHeight Image, h
    
    MapDC = CreateCDC(w * 90, h * 90 + 90)
    CoverDC = CreateCDC(w * 90, h * 90 + 90)
    
    ReDim Map(w + 1, h + 2)
    For Y = 0 To h
        For X = 0 To w
            GdipBitmapGetPixel Image, X, Y, Color
            If Color = 0 Then Map(X, Y + 1) = Page.Res.GetImage("alpha.png")
            If Color = argb(255, 255, 255, 255) Then Map(X, Y + 1) = Page.Res.GetImage("white.png")
            If Color = argb(255, 153, 204, 255) Then Map(X, Y + 1) = Page.Res.GetImage("blue.png")
            If Color = argb(255, 255, 153, 51) Then Map(X, Y + 1) = Page.Res.GetImage("orange.png")
            If Color = argb(255, 0, 255, 0) Then Map(X, Y + 1) = Page.Res.GetImage("green.png")
            If Color = argb(255, 0, 0, 0) Then Map(X, Y + 1) = Page.Res.GetImage("black.png")
            If Color = argb(255, 0, 255, 255) Then Map(X, Y + 1) = Page.Res.GetImage("alpha.png"): StartX = X: StartY = Y + 1
            If Color = argb(255, 255, 0, 0) Then Map(X, Y + 1) = Page.Res.GetImage("alpha.png"): EndX = X: EndY = Y + 1
        Next
    Next
    PX = StartX: PY = StartY
    
    Dim ODC As Long
    ODC = Page.CDC
    Page.CDC = MapDC
    For X = 0 To w
        For Y = 1 To h + 1
            Page.DrawImage Map(2, 2), (X - 0) * 90, (Y - 0) * 90, Alpha:=1
            If Page.Res.ImgSize(Map(X, Y), imgGetHeight) = 180 Then
                Page.DrawImage Map(X, Y), (X - 0) * 90, (Y - 0) * 90, cy:=90, ch:=90, Alpha:=1
                Page.CDC = CoverDC
                Page.DrawImage Map(X, Y), (X - 0) * 90, (Y - 0) * 90 - 90, cy:=0, ch:=90, Alpha:=1
                Page.CDC = MapDC
            Else
                Page.DrawImage Map(X, Y), (X - 0) * 90, (Y - 0) * 90, Alpha:=1
            End If
        Next
    Next
    Page.CDC = ODC
End Sub
Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    
    Page.Clear '��ջ���

    Dim w As Long, h As Long, cx As Long, cy As Long
    cx = (PX - 0) * 90 - GW / 2 + 45
    cy = (PY - 0) * 90 - GH / 2 + 45
    
    w = 90 * (UBound(Map, 1) - 1) - IIf(cx >= 0, cx, 0)
    h = 90 * (UBound(Map, 2) - 1) - IIf(cy >= 0, cy, 0)
    
    If w > GW Then w = GW
    If h > GH Then h = GH
    
    PaintDC MapDC, Page.CDC, IIf(cx < 0, -cx, 0), IIf(cy < 0, -cy, 0), IIf(cx >= 0, cx, 0), IIf(cy >= 0, cy, 0), w, h, 1
    Page.Paint 1, GW / 2 - 45, GH / 2 - 45, 90, 90, argb(255, 255, 255, 255)
    PaintDC CoverDC, Page.CDC, IIf(cx < 0, -cx, 0), IIf(cy < 0, -cy, 0), IIf(cx >= 0, cx, 0), IIf(cy >= 0, cy, 0), w, h, 1
    
    Dim HuaIndex As Integer
    HuaIndex = Page.Res.GetImage("black.png")
    
    If IsKeyPress(VK_UP) And Map(Int(PX), Int(PY - 0.05)) <> HuaIndex Then PY = PY - 0.05
    If IsKeyPress(VK_DOWN) And Map(Int(PX), Int(PY + 0.05 + IIf(PY - Int(PY) < 0.5, 1, 0))) <> HuaIndex Then PY = PY + 0.05
    If IsKeyPress(VK_LEFT) And Map(Int(PX - 0.05), Int(PY)) <> HuaIndex Then PX = PX - 0.05
    If IsKeyPress(VK_RIGHT) And Map(Int(PX + 0.05 + 1), Int(PY)) <> HuaIndex Then PX = PX + 0.05
    
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
    Page.Res.NewImages App.path & "\assets\maze"
    '����ҳ��
    ECore.Add Page, "MazePage"
    
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub