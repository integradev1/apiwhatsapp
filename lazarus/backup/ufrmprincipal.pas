unit ufrmPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, ActnList, LCLType, ExtDlgs, ubarcodes, fpjson,jsonparser;

type


  //SUPORTE PODE SER ENVIADO PAR
  // integradev@gmail.com
  //atendimento@integradev.com.br

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btDesconectar: TSpeedButton;
    edtCaptionImage: TEdit;
    edtCaptionVideo: TEdit;
    edtNomeArquivoDocumento: TEdit;
    edtIntanciaToken: TEdit;
    edtPathAudio: TEdit;
    edtPathImage: TEdit;
    edtPathVideo: TEdit;
    edtPathDocumento: TEdit;
    edtFoneAdd: TEdit;
    edtResponse: TMemo;
    edtTipoArquivo: TComboBox;
    edtTokenApi: TEdit;
    EdtURL: TEdit;
    Image1: TImage;
    imgQrCode: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lLeituraContador: TLabel;
    lStatus: TLabel;
    ListContatos: TListBox;
    edtMensagem: TMemo;
    OpenDialog1: TOpenDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlBasePainel: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    btSendRequest: TSpeedButton;
    btConsultarStatus: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    tabDocumento: TTabSheet;
    tabImagem: TTabSheet;
    tabAudio: TTabSheet;
    tabStatus: TTabSheet;
    tabSimples: TTabSheet;
    tabURL: TTabSheet;
    tabVideo: TTabSheet;
    tAguardarLeituraQrCode: TTimer;
    procedure btDesconectarClick(Sender: TObject);
    procedure edtTipoArquivoSelect(Sender: TObject);
    procedure edtTokenApiExit(Sender: TObject);
    procedure edtIntanciaTokenExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure ListContatosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btSendRequestClick(Sender: TObject);
    procedure btConsultarStatusClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure tAguardarLeituraQrCodeTimer(Sender: TObject);
  private
       var timerLeitura : integer;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses untUtils, untIntegraDev;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.edtTipoArquivoSelect(Sender: TObject);
begin
  case edtTipoArquivo.ItemIndex of
     0 : EdtURL.Text:= '';
     1 : EdtURL.text := 'https://www.thecampusqdl.com/uploads/files/pdf_sample_2.pdf';
     2 : EdtURL.text := 'https://integradev.com.br/wp-content/uploads/2023/06/logo-1.png';
     3 : EdtURL.text := 'https://edisciplinas.usp.br/pluginfile.php/5196097/mod_resource/content/1/Teste.mp4';
  end;
end;

procedure TfrmPrincipal.btDesconectarClick(Sender: TObject);
var JSON: TJSONData;
  Obj: TJSONObject;
   classIntegra : TIntegraDev;
begin
  try
    classIntegra := TIntegraDev.Create(edtTokenApi.Text, edtIntanciaToken.Text);
    JSON := GetJSON(classIntegra.setDesconectado());
    Obj := TJSONObject(JSON);
    lStatus.Caption:=Obj.Strings['status'];

    if (trim(Obj.Strings['status'])='desconectado') then
    Begin
         btDesconectar.Enabled:= false;
         btConsultarStatus.Enabled:= true;
    end;

  finally
    FreeAndNil(JSON);
    FreeAndNil(classIntegra);
  end;
end;



procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
   if Length(edtFoneAdd.text)<10 then
   Begin
        Messagedlg('Telefone Invalido inserir (DD)9999-9999',mtInformation,[mbok],0);
        exit;
   end;

   ListContatos.Items.Add(edtFoneAdd.text);
   edtFoneAdd.Clear;
   edtFoneAdd.SetFocus;
end;

procedure TfrmPrincipal.btSendRequestClick(Sender: TObject);
var classIntegra : TIntegraDev;
  tipoDocumento : String;
begin
 try
  classIntegra := TIntegraDev.Create(edtTokenApi.Text, edtIntanciaToken.Text);

  if PageControl1.ActivePage = tabSimples then
  Begin
    edtResponse.Text := classIntegra.EnviarTexto(listBoxToStr(ListContatos),
                                                       edtMensagem.text);
  end else
  if PageControl1.ActivePage = tabURL then
  Begin
      case edtTipoArquivo.ItemIndex of
          1: tipoDocumento:= 'document';
          2: tipoDocumento:= 'image';
          3: tipoDocumento:= 'video';
          else
            Begin
                messagedlg('Defina o Tipo de Arquivo a Ser enviado',mtError,[mbok],0);
                exit;
            end;
       end;

       edtResponse.Text := classIntegra.EnviarURL(listBoxToStr(ListContatos),
                                                  EdtURL.text,
                                                  tipoDocumento);
  end else
  if PageControl1.ActivePage = tabVideo then
  Begin
      if (trim(edtCaptionVideo.Text)='') then
      Begin
           Messagedlg('Caption do video não informado',mtError,[mbok],0);
           exit;
      end;

      if (trim(edtPathVideo.Text)='') then
      Begin
           Messagedlg('video não informado',mtError,[mbok],0);
           exit;
      end;

      edtResponse.Text := classIntegra.EnviarVideo(listBoxToStr(ListContatos),
                                          edtPathVideo.text,
                                          edtCaptionVideo.text);
  end else
  if PageControl1.ActivePage = tabImagem then
  Begin
       if (trim(edtCaptionImage.Text)='') then
      Begin
           Messagedlg('Caption da Imagem não informado',mtError,[mbok],0);
           exit;
      end;

      if (trim(edtPathImage.Text)='') then
      Begin
           Messagedlg('Imagem não informado',mtError,[mbok],0);
           exit;
      end;

      edtResponse.Text := classIntegra.EnviarImagem(listBoxToStr(ListContatos),
                                          edtPathImage.text,
                                          edtCaptionImage.text);

  end else
  if PageControl1.ActivePage = tabDocumento then
  Begin
       if (trim(edtNomeArquivoDocumento.Text)='') then
      Begin
           Messagedlg('Nome Arquivo não informado',mtError,[mbok],0);
           exit;
      end;

      if (trim(edtPathDocumento.Text)='') then
      Begin
           Messagedlg('Documento não informado',mtError,[mbok],0);
           exit;
      end;

      edtResponse.Text := classIntegra.EnviarDocumento(listBoxToStr(ListContatos),
                                          edtPathDocumento.text,
                                          edtNomeArquivoDocumento.text);

  end else
  if PageControl1.ActivePage = tabAudio then
  Begin

      if (trim(edtPathAudio.Text)='') then
      Begin
           Messagedlg('Audio não informado',mtError,[mbok],0);
           exit;
      end;

      edtResponse.Text := classIntegra.EnviarAudio(listBoxToStr(ListContatos),
                                          edtPathAudio.text
                                          );

  end;

 finally
     FreeAndNil(classIntegra);
 end;
end;

procedure TfrmPrincipal.btConsultarStatusClick(Sender: TObject);
var JSON: TJSONData;
  Obj: TJSONObject;
   classIntegra : TIntegraDev;
begin
  try
    classIntegra := TIntegraDev.Create(edtTokenApi.Text, edtIntanciaToken.Text);
    JSON := GetJSON(classIntegra.getStatus());
    Obj := TJSONObject(JSON);
    lStatus.Caption:=Obj.Strings['status'];

    imgQrCode.Visible:= false;

    if (trim(Obj.Strings['status'])<>'conectado') then
    Begin
         btDesconectar.Enabled:= false;
         if (trim(Obj.Strings['status'])='desconectado') then
         Begin
             //Estando Desconectado ira buscar qrCode para Leitura
             FreeAndNil(JSON);
             JSON := GetJSON(classIntegra.getQrCode());
             Obj := TJSONObject(JSON);

             if (Obj.Strings['qrCode']) <> '' then
             Begin
                 //carrega strBase64 para o Timage
                 btConsultarStatus.Enabled:= false;
                 LoadBase64ToImage(Obj.Strings['qrCode'], imgQrCode);
                 imgQrCode.Visible:= true;
                 lLeituraContador.Caption:= '';
                 lLeituraContador.Visible:= true;
                 //ativa o timer de Leitura QRCode
                 timerLeitura:= 60;
                 tAguardarLeituraQrCode.enabled := true;
             end else
             Begin
                  MessageDlg(Obj.Strings['msg'],mtError,[mbok],0);
             end;
         end;
    end else
    Begin
         btDesconectar.Enabled:= true;
    end;

  finally
    FreeAndNil(JSON);
    FreeAndNil(classIntegra);
  end;
end;


procedure TfrmPrincipal.SpeedButton4Click(Sender: TObject);
begin
   edtPathImage.Clear;
   if OpenPictureDialog1.Execute then
    begin
      // O usuário selecionou um arquivo
      if FileExists(OpenPictureDialog1.FileName) then
        edtPathImage.Text:= OpenPictureDialog1.FileName;
    end;
end;

procedure TfrmPrincipal.SpeedButton5Click(Sender: TObject);
begin
  edtPathVideo.Clear;

  OpenDialog1.Filter:= 'Video (*.mp4)|*.mp4|Todos os arquivos (*)|*|';
  if OpenDialog1.Execute then
   begin
     // O usuário selecionou um arquivo
     if FileExists(OpenDialog1.FileName) then
       edtPathVideo.Text:= OpenDialog1.FileName;
   end;
end;

procedure TfrmPrincipal.SpeedButton6Click(Sender: TObject);
begin
 edtPathDocumento.Clear;

 OpenDialog1.Filter:= 'Todos os arquivos (*)|*|';
 if OpenDialog1.Execute then
  begin
    // O usuário selecionou um arquivo
    if FileExists(OpenDialog1.FileName) then
      edtPathDocumento.Text:= OpenDialog1.FileName;
  end;
end;

procedure TfrmPrincipal.SpeedButton7Click(Sender: TObject);
begin
 edtPathAudio.Clear;

 OpenDialog1.Filter:= 'Audio (*.mp3)|*.mp3|Todos os arquivos (*)|*|';
 if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
      edtPathAudio.Text:= OpenDialog1.FileName;
  end;
end;

procedure TfrmPrincipal.tAguardarLeituraQrCodeTimer(Sender: TObject);
var JSON: TJSONData;
  Obj: TJSONObject;
   classIntegra : TIntegraDev;
begin
  if timerLeitura <=0 then
  Begin
      imgQrCode.Visible:= false;
      tAguardarLeituraQrCode.Enabled:=false;
      lLeituraContador.Visible:= false;
      lStatus.Caption:= 'desconectado(leitura qrCode Expirado)';
       btConsultarStatus.Enabled:= true;
  end else
  Begin
        try
          classIntegra := TIntegraDev.Create(edtTokenApi.Text, edtIntanciaToken.Text);
          JSON := GetJSON(classIntegra.getStatus());
          Obj := TJSONObject(JSON);
          lStatus.Caption:=Obj.Strings['status'];

          if (trim(Obj.Strings['status'])='conectado') then
          Begin
              tAguardarLeituraQrCode.Enabled:=false;
              lLeituraContador.Visible:= false;
              btConsultarStatus.Enabled:= true;
              imgQrCode.Visible:= false;
              btDesconectar.Enabled:= true;
              exit;
          end;

         Dec(timerLeitura);
         lLeituraContador.Caption := 'Aguardando Leitura('+IntToStr(timerLeitura)+'s)';
        finally
          FreeAndNil(JSON);
          FreeAndNil(classIntegra);
        end;
  end;

end;


procedure TfrmPrincipal.edtTokenApiExit(Sender: TObject);
begin
   SalvarIni('api-token',edtTokenApi.text);
end;

procedure TfrmPrincipal.edtIntanciaTokenExit(Sender: TObject);
begin
     SalvarIni('instancia-token',edtIntanciaToken.text);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
   edtTokenApi.text := LerIni('api-token');
   edtIntanciaToken.text := LerIni('instancia-token');

   PageControl1.ActivePage:= tabSimples;
   edtFoneAdd.SetFocus;
end;

procedure TfrmPrincipal.Label19Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.ListContatosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   // Verifica se a tecla pressionada é a tecla Delete (Del)
   if (Key = VK_DELETE) and (ListContatos.ItemIndex >= 0) then
   begin
     // Pede uma confirmação
     if MessageDlg('Você deseja remover o item selecionado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
       // Remove o item selecionado no ListBox
       ListContatos.Items.Delete(ListContatos.ItemIndex);
     end;
   end;

   edtFoneAdd.SetFocus;
end;

procedure TfrmPrincipal.PageControl1Change(Sender: TObject);
begin
    if PageControl1.ActivePage = tabStatus then
    Begin
        if (Trim(edtTokenApi.Text) <> '') and (trim(edtIntanciaToken.text)<>'') then
        Begin
            btConsultarStatusClick(self);
        end;
    end;
end;



end.

