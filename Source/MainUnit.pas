unit MainUnit;

{$mode objfpc}{$H+}
{$WARN 5024 off : Parameter "$1" not used}
interface

uses
 Classes,SysUtils,Forms,Controls,Graphics,Dialogs,ExtCtrls,ComCtrls,StdCtrls;

type

 TRISCOSForm = class(TPanel)
  private
   procedure FormMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
   procedure TitlebarMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure TitlebarMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
   procedure TitlebarMouseUp(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure TitleBarPaint(Sender:TObject);
   procedure FormMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure FormMouseUp(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure FormPaint(Sender:TObject);
   procedure DirListPaint(Sender:TCustomTreeView;
    const ARect:TRect;var DefaultDraw:Boolean);
   procedure ButtonMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure ButtonMouseUp(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure GenericMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
   procedure SetCaption(ACaption: String);
   function GetCaption: String;
   procedure DeFocusSiblings;
  private
   Fdragging       : Boolean;
   FSizeState      : Byte;
   FTitleBarBG,
   FMaximise,
   FIconise,
   FClose,
   FBack,
   FTile           : TImage;
   FMaximiseImages,
   FPrevStatImages,
   FIconiseImages,
   FCloseImages,
   FBackImages     : TImageList;
   FHeader,
   FTitleBar       : TPanel;
   FTitleBarText   : TLabel;
   FmouseX,
   FmouseY,
   FformX,
   FformY,
   FformW,
   FformH,
   FoldX,
   FoldY,
   FoldWidth,
   FoldHeight      : Integer;
   FOnCloseQuery   : TCloseQueryEvent;
   FOnClose        : TCloseEvent;
   const FminH         = 150;
   const FminW         = 150;
   const FTitleBarSize = 20;
   {$INCLUDE GFX.pas}
  published
   constructor Create(AOwner: TComponent); override;
   procedure DeFocus;
   procedure SetTile(ATile: TImage);
  published
   DirList    : TTreeView;
   property Caption     : String           read GetCaption    write SetCaption;
   property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
   property OnClose     : TCloseEvent      read FOnClose      write FOnClose;
  public
   destructor Destroy; override;
 end;

 { TMainForm }

 TMainForm = class(TForm)
  Button1: TButton;
  DesktopTile:TImage;
  WindowTile:TImage;
  IconBar : TPanel;
  procedure Button1Click(Sender:TObject);
  procedure FormPaint(Sender:TObject);
  procedure SubFormClose(Sender: TObject; var CanClose: TCloseAction);
 private

 public
  ChildForms: array of TRISCOSForm;
 end;

var
 MainForm: TMainForm;

implementation

{$R *.lfm}

constructor TRISCOSForm.Create(AOwner: TComponent);
 function CreateImage(LAlign: TAlign; LImageList: TImageList): TImage;
 begin
  Result            :=TImage.Create(FHeader as TComponent);
  Result.Align      :=LAlign;
  Result.Parent     :=FHeader as TWinControl;
  Result.Visible    :=True;
  Result.AutoSize   :=True;
  Result.Images     :=LImageList;
  Result.ImageIndex :=0;
  Result.OnMouseDown:=@ButtonMouseDown;
  Result.OnMouseUp  :=@ButtonMouseUp;
 end;
 function CreateImage(Ldata: array of Byte): TImage;
 var
  Lms    : TMemoryStream=nil;
 begin
  Result            :=TImage.Create(Self as TComponent);
  Result.Parent     :=Self as TWinControl;
  Result.Visible    :=False;
  Lms               :=TMemoryStream.Create;
  Lms.Write(Ldata,Length(Ldata));
  Lms.Position      :=0;
  Result.Picture.LoadFromStream(Lms);
  Lms.Clear;
 end;
 function CreateImageList: TImageList;
 begin
  Result            :=TImageList.Create(Self as TComponent);
  Result.Height     :=FTitleBarSize;
  Result.Width      :=FTitleBarSize;
 end;
 procedure AddImage(LList: TImageList;Ldata: array of Byte);
 var
  LImage : TImage=nil;
 begin
  LImage            :=CreateImage(Ldata);
  LList.Add(LImage.Picture.Bitmap,nil);
  LImage.Free;
 end;
begin
 inherited Create(AOwner);
 //Form attributes
 Self.Width             :=490; //Default width
 Self.Height            :=372; //Default height
 Self.BevelWidth        :=4;
 Self.OnMouseMove       :=@FormMouseMove;
 Self.OnMouseUp         :=@FormMouseUp;
 Self.OnMouseDown       :=@FormMouseDown;
 //Image Lists
 FMaximiseImages        :=CreateImageList;
 AddImage(FMaximiseImages,GFXMaximise);
 AddImage(FMaximiseImages,GFXMaximisePress);
 FPrevStatImages        :=CreateImageList;
 AddImage(FPrevStatImages,GFXPreviousSize);
 AddImage(FPrevStatImages,GFXPreviousSizePress);
 FIconiseImages         :=CreateImageList;
 AddImage(FIconiseImages ,GFXIconise);
 AddImage(FIconiseImages ,GFXIconisePress);
 FCloseImages           :=CreateImageList;
 AddImage(FCloseImages   ,GFXClose);
 AddImage(FCloseImages   ,GFXClosePress);
 FBackImages            :=CreateImageList;
 AddImage(FBackImages    ,GFXBack);
 AddImage(FBackImages    ,GFXBackPress);
 //Header
 FHeader                :=TPanel.Create(Self as TComponent);
 FHeader.Parent         :=Self as TWinControl;
 FHeader.Align          :=alTop;
 FHeader.Visible        :=True;
 FHeader.Height         :=FTitleBarSize;
 //Iconise button
 FIconise               :=CreateImage(alRight ,FIconiseImages);
 FIconise.Tag           :=3;
 //Toggle size button
 FMaximise              :=CreateImage(alRight ,FMaximiseImages);
 FMaximise.Tag          :=0;
 //Close button
 FClose                 :=CreateImage(alLeft  ,FCloseImages);
 FClose.Tag             :=1;
 //Back button
 FBack                  :=CreateImage(alLeft  ,FBackImages);
 FBack.Tag              :=2;
 //Titlebar background image
 FTitleBarBG            :=CreateImage(GFXTitleBarBG);
 //Title bar
 FTitleBar              :=TPanel.Create(FHeader as TComponent);
 FTitleBar.Parent       :=FHeader as TWinControl;
 FTitleBar.Align        :=alClient;
 FTitleBar.Color        :=clYellow;
 FTitleBar.BorderStyle  :=bsNone;
 FTitleBar.BevelOuter   :=bvNone;
 FTitleBar.BevelWidth   :=1;
 FTitleBar.Caption      :='';
 FTitleBar.Visible      :=True;
 FTitleBar.Height       :=FTitleBarSize;
 FTitleBar.OnMouseDown  :=@TitlebarMouseDown;
 FTitleBar.OnMouseMove  :=@TitlebarMouseMove;
 FTitleBar.OnMouseUp    :=@TitlebarMouseUp;
 FTitleBar.OnPaint      :=@TitlebarPaint;
 //Title bar text
 FTitleBarText          :=TLabel.Create(FTitleBar as TComponent);
 FTitleBarText.Parent   :=FTitleBar as TWinControl;
 FTitleBarText.Align    :=alClient;
 FTitleBarText.Alignment:=taCenter;
 FTitleBarText.Caption  :='RISC OS Window'; //Default title
 FTitleBarText.OnMouseDown:=@TitlebarMouseDown;
 FTitleBarText.OnMouseMove:=@TitlebarMouseMove;
 FTitleBarText.OnMouseUp  :=@TitlebarMouseUp;
 //Tree view (directory listing)
 DirList                :=TTreeView.Create(Self as TComponent);
 DirList.Parent         :=Self as TWinControl;
 DirList.Align          :=alClient;
 DirList.Visible        :=True;
 DirList.Color          :=clNone;//clBackground;
 DirList.BackgroundColor:=clNone;//clBackground;
 DirList.BorderStyle    :=bsNone;
 DirList.OnMouseDown    :=@GenericMouseDown;
 DirList.OnCustomDraw   :=@DirListPaint;
 //Reset flags and co-ordinates to default values
 Fdragging              :=False;
 FmouseX                :=-1;
 FmouseY                :=-1;
 FSizeState             :=0;
 FoldWidth              :=Self.Width;
 FoldHeight             :=Self.Height;
 FoldX                  :=Self.Left;
 FoldY                  :=Self.Top;
 DeFocusSiblings;
 FTile                  :=nil;
end;

destructor TRISCOSForm.Destroy;
begin
 inherited;
end;

procedure TRISCOSForm.TitlebarMouseDown(Sender:TObject;Button:TMouseButton;
 Shift:TShiftState;X,Y:Integer);
begin
 //Set the dragging flag
 Fdragging:=True;
 //Remember our current position
 FmouseX:=X;
 FmouseY:=Y;
 //Set the form co-ordinates
 FformX:=Self.Left;
 FformY:=Self.Top;
 //Change the bevel
 FTitleBar.BevelOuter:=bvLowered;
 GenericMouseDown(Sender,Button,Shift,X,Y);
end;

procedure TRISCOSForm.TitlebarMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer
 );
var
 LformX: Integer=0;
 LformY: Integer=0;
begin
 //Only if we are dragging the form
 if Fdragging then
 begin
  //Work out the distance moved
  LformX:=X-FmouseX;
  LformY:=Y-FmouseY;
  //Move the form
  Self.Left:=FformX+LformX;
  Self.Top :=FformY+LformY;
  //Reset the form co-ordinates for next time
  FformX:=Self.Left;
  FformY:=Self.Top;
 end;
end;

procedure TRISCOSForm.TitlebarMouseUp(Sender:TObject;Button:TMouseButton;
 Shift:TShiftState;X,Y:Integer);
begin
 //Reset the dragging flag
 Fdragging:=False;
 FTitleBar.BevelOuter:=bvRaised;
end;

procedure TRISCOSForm.FormMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
var
 LformX: Integer=0;
 LformY: Integer=0;
const
 Lmargin=12; //Zone of margin
begin
 //If we're not already resizing
 if not Fdragging then
 begin
  //Reset the state
  FSizeState :=0;
  //Determine what state we are in
  if(X>=Self.Width-Lmargin) and(X<=Self.Width) then FSizeState:=FSizeState+1; //Right
  if(Y>=Self.Height-Lmargin)and(Y<=Self.Height)then FSizeState:=FSizeState+2; //Bottom
  //Left and top resizing doesn't work too great - well, at all!!
  if(X>=0)                  and(X<=Lmargin)    then FSizeState:=FSizeState+4; //Left
  if(Y>=0)                  and(Y<=Lmargin)    then FSizeState:=FSizeState+8; //Top
  //Reset the impossible states
  if(FSizeState=5)
  or(FSizeState=7)
  or(FSizeState=10)
  or(FSizeState=11)
  or(FSizeState>12)then FSizeState:=0;
  case FSizeState of
    0: Self.Cursor:=crDefault; //In the main area of the form
    1: Self.Cursor:=crSizeWE;  //On the right hand side
    2: Self.Cursor:=crSizeNS;  //On the bottom
    3: Self.Cursor:=crSizeNWSE;//On the bottom right
    4: Self.Cursor:=crSizeWE;  //On the left hand side
    6: Self.Cursor:=crSizeNESW;//On the bottom left
    8: Self.Cursor:=crSizeNS;  //On the top
    9: Self.Cursor:=crSizeNESW;//On the top right hand side
   12: Self.Cursor:=crSizeNWSE;//On the top left
  end;
 end
 else
 begin
  //Work out the distance moved
  LformX:=X-FmouseX;
  LformY:=Y-FmouseY;
  //What are we moving?
  if(FSizeState AND 1)=1then Self.Width :=FformW+LformX;//Changing the width (R)
  if(FSizeState AND 4)=4then Self.Width :=FformW-LformX;//Changing the width (L)
  if(FSizeState AND 2)=2then Self.Height:=FformH+LformY;//Changing the height (B)
  if(FSizeState AND 8)=8then Self.Height:=FformH-LformY;//Changing the height (T)
  //Ensure a minimum size
  if Self.Width <FminW  then Self.Width :=FminW;
  if Self.Height<FminH  then Self.Height:=FminH;
  //Move the form, if needed
  if(FSizeState AND 4)=4then Self.Left  :=FformX+LformX;//Horizontally
  if(FSizeState AND 8)=8then Self.Top   :=FformY+LformY;//Vertically
  //Reset the form co-ordinates for next time
  FformX:=Self.Left;
  FformY:=Self.Top;
  FformW:=Self.Width;
  FformH:=Self.Height;
  //Resizing from left or top won't work if these get set
  if(FSizeState AND 1)=1then FmouseX:=X;
  if(FSizeState AND 2)=2then FmouseY:=Y;
 end;
end;

procedure TRISCOSForm.TitleBarPaint(Sender:TObject);
var
 rc: TRect;
begin
 rc:=Rect(0,0,FTitlebar.Canvas.Width,FTitlebar.Canvas.Height);
 FTitlebar.Canvas.StretchDraw(rc,FTitleBarBG.Picture.Graphic);
end;

procedure TRISCOSForm.FormMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
begin
 GenericMouseDown(Sender,Button,Shift,X,Y);
 //Set the dragging flag, if we are in one of the resize zones
 if FSizeState<>0 then
 begin
  Fdragging:=True;
  //Remember our current position
  FmouseX  :=X;
  FmouseY  :=Y;
  //Set the form co-ordinates
  FformX   :=Self.Left;
  FformY   :=Self.Top;
  FformW   :=Self.Width;
  FformH   :=Self.Height;
 end;
end;

procedure TRISCOSForm.FormMouseUp(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
begin
 //Reset the dragging flag, if we are in one of the resize zones
 if FSizeState<>0 then Fdragging:=False;
end;

procedure TRISCOSForm.FormPaint(Sender:TObject);
var
 b : TBrush=nil;
 rc: TRect;
 c : TCanvas=nil;
begin
 if FTile<>nil then
 begin
  if Sender is TPanel    then c:=TPanel(Sender).Canvas;
  if Sender is TTreeView then c:=TTreeView(Sender).Canvas;
  if c<>nil then
  begin
   rc      :=Rect(0,0,c.Width,c.Height);
   b       :=Tbrush.Create;
   b.Bitmap:=FTile.Picture.Bitmap;
   c.Brush :=b;
   c.FillRect(rc);
   b.Free;
  end;
 end;
end;

procedure TRISCOSForm.DirListPaint(Sender:TCustomTreeView;
    const ARect:TRect;var DefaultDraw:Boolean);
begin
 FormPaint(Sender);
end;

procedure TRISCOSForm.ButtonMouseDown(Sender:TObject;Button:TMouseButton;
 Shift:TShiftState;X,Y:Integer);
begin
 TImage(Sender).ImageIndex:=1;
 GenericMouseDown(Sender,Button,Shift,X,Y);
end;

procedure TRISCOSForm.ButtonMouseUp(Sender:TObject;Button:TMouseButton;
 Shift:TShiftState;X,Y:Integer);
var
 CanClose   : Boolean=True;
 CloseAction: TCloseAction=caFree;
begin
 TImage(Sender).ImageIndex:=0;
 case TImage(Sender).Tag of
  0 : //Toggle Size
   if Self.Align=alClient then
   begin
    Self.Align :=alNone;    //Previous state
    TImage(Sender).Images:=FMaximiseImages;
   end
   else
   begin
    Self.Align :=alClient; //Max
    TImage(Sender).Images:=FPrevStatImages;
   end;
  1 : //Close
   begin
    if Assigned(FOnCloseQuery) then FOnCloseQuery(Self as TObject,CanClose);
    if CanClose then
    begin
     if Assigned(FOnClose) then FOnClose(Self as TObject,CloseAction);
     if CloseAction=caFree then Self.Destroy;
    end;
   end;
  2 : Self.SendToBack;//Back
  3 : //Iconise
   if Self.Height<FminH then
   begin //Return to previous size and position
    Self.Align :=alNone;
    Self.Width :=FoldWidth;
    Self.Height:=FoldHeight;
    Self.Top   :=FoldY;
    Self.Left  :=FoldX;
   end
   else
   begin
    Self.Align :=alNone;
    FoldWidth  :=Self.Width;
    Self.Width :=FminW;
    FoldHeight :=Self.Height;
    Self.Height:=FTitleBar.Height+Self.BevelWidth*2;
    FoldY      :=Self.Top;
    Self.Top   :=Self.Parent.ClientHeight-Self.Height-8;
    FoldX      :=Self.Left;
    Self.Left  :=8;
   end;
 end;
end;

procedure TRISCOSForm.GenericMouseDown(Sender:TObject;Button:TMouseButton;
    Shift:TShiftState;X,Y:Integer);
begin
 Self.BringToFront;
 FTitleBar.Color:=clYellow;
 DeFocusSiblings;
end;

procedure TRISCOSForm.SetCaption(ACaption: String);
begin
 //Set the titlebar caption
 FTitleBarText.Caption:=ACaption;
end;

function TRISCOSForm.GetCaption: String;
begin
 //Return the titlebar caption
 Result:=FTitleBarText.Caption;
end;

procedure TRISCOSForm.DeFocus;
begin
 FTitleBar.Color:=clSilver;
end;

procedure TRISCOSForm.DeFocusSiblings;
var
 i : Integer=0;
begin
 for i:=0 to Self.Owner.ComponentCount-1 do
  if Self.Owner.Components[i].ClassType=TRISCOSForm then
   if Self.Owner.Components[i]<>Self then
    TRISCOSForm(Self.Owner.Components[i]).DeFocus;
end;

procedure TRISCOSForm.SetTile(ATile: TImage);
begin
 FTile:=ATile;
 Self.Invalidate;
 DIrList.Invalidate;
end;

{ TMainForm }

procedure TMainForm.Button1Click(Sender:TObject);
var
 LrootNode: TTreeNode=nil;
begin
 SetLength(ChildForms,Length(ChildForms)+1);
 ChildForms[Length(ChildForms)-1]:=TRISCOSForm.Create(MainForm as TComponent);
 ChildForms[Length(ChildForms)-1].Parent:=MainForm as TWinControl;
 ChildForms[Length(ChildForms)-1].Visible:=True;
 ChildForms[Length(ChildForms)-1].Caption:='Window '+IntToStr(Length(ChildForms));
 ChildForms[Length(ChildForms)-1].OnClose:=@SubFormClose;
 ChildForms[Length(ChildForms)-1].SetTile(WindowTile);
 LrootNode:=ChildForms[Length(ChildForms)-1].DirList.Items.Add(nil,'$');
 ChildForms[Length(ChildForms)-1].DirList.Items.AddChild(LrootNode,'!Boot');
 ChildForms[Length(ChildForms)-1].DirList.Items.AddChild(LrootNode,'!System');
end;

procedure TMainForm.FormPaint(Sender:TObject);
var
 b : TBrush=nil;
 rc: TRect;
 c : TCanvas=nil;
begin
 if Sender is TForm     then c:=TForm(Sender).Canvas;
 if Sender is TPanel    then c:=TPanel(Sender).Canvas;
 if Sender is TTreeView then c:=TTreeView(Sender).Canvas;
 if c<>nil then
 begin
  rc      :=Rect(0,0,c.Width,c.Height);
  b       :=Tbrush.Create;
  b.Bitmap:=DesktopTile.Picture.Bitmap;
  c.Brush :=b;
  c.FillRect(rc);
  b.Free;
 end;
end;

procedure TMainForm.SubFormClose(Sender: TObject; var CanClose: TCloseAction);
var
 i : Integer=0;
 j : Integer=0;
begin
 if Length(ChildForms)>0 then
 begin
  i:=0;
  while(i<Length(ChildForms))and(ChildForms[i]<>TRISCOSForm(Sender))do inc(i);
  if i<Length(ChildForms) then
  begin
   if i<Length(ChildForms)-1 then
    for j:=i+1 to Length(ChildForms)-1 do
     ChildForms[j-1]:=ChildForms[j];
   SetLength(ChildForms,Length(ChildForms)-1);
  end;
 end;
end;

end.

