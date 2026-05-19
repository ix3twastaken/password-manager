unit AboutForm;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, dmImages;

type
  TFormAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    LabelAbout: TLabel;
    LabelDescription: TLabel;
    Label3: TLabel;
    LabelLicense: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    Image1: TImage;
    LinkLabel3: TLinkLabel;
    LinkLabel4: TLinkLabel;
    Label6: TLabel;
    LinkLabel5: TLinkLabel;
    LinkLabel6: TLinkLabel;
    Label7: TLabel;
    LinkLabel7: TLinkLabel;
    LinkLabel8: TLinkLabel;
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
  public
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;
end.
