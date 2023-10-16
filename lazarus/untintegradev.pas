unit untIntegraDev;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, RESTRequest4D, dialogs,StdCtrls, Base64 ;

type

{ TIntegraDev }

TIntegraDev = Class
      const urlBase = 'https://api.integradev.com.br/instance/';
  private
         apiToken : String;
         instanciaToken : String;
         function getEndPoint : string;
  Public
        constructor Create(api, instancia : string);

        function EnviarTexto(fones , mensagem : string):string;
        function EnviarURL(fones , url, tipoDocumento : string):string;

        function EnviarImagem(fone, pathFile, caption: string): string;
        function EnviarVideo(fone, pathFile, caption: string): string;
        function EnviarDocumento(fone, pathFile, fileName: string): string;
end;


implementation

function FileToBase64(const FileName: string): string;
var
  FileStream: TFileStream;
  Bytes: TBytes;
  AnsiStr: AnsiString;
begin
  Result := '';
  if not FileExists(FileName) then Exit;

  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Bytes, FileStream.Size);
    FileStream.Read(Bytes[0], FileStream.Size);
    SetString(AnsiStr, PAnsiChar(@Bytes[0]), Length(Bytes));
    Result := EncodeStringBase64(AnsiStr);
  finally
    FileStream.Free;
  end;
end;




function EscapeJSONString(const Input: string): string;
begin
   Result := StringReplace(Input, '\', '\\', [rfReplaceAll]);
   Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
   Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
   Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  // Adicione outras substituições, se necessário
end;

{ TIntegraDev }

function TIntegraDev.getEndPoint: string;
begin
    result := urlBase+instanciaToken;
end;

constructor TIntegraDev.Create(api, instancia: string);
begin
     apiToken := api;
     instanciaToken:= instancia;
end;

function TIntegraDev.EnviarTexto(fones, mensagem: string): string;
var LResponse: IResponse;
   body : String;
begin
     if (trim(apiToken) = '') then
     Begin
          MessageDlg('Token da API não informado',mterror,[mbOK],0);
          exit;
     end;

     if (trim(instanciaToken) = '') then
     Begin
          MessageDlg('Token da Instancia não informado',mterror,[mbOK],0);
          exit;
     end;


     // atenção ao criar o objeto precisa ser valido
     body := '{ "message" : "'+EscapeJSONString(mensagem)+'"'+
             ' , "delayMessage" : 0 ' +
             ' , "to" : ['+fones+']' +
             ' }';



   LResponse := TRequest.New.BaseURL(getEndPoint+'/send-text')//passando url para texto
    .ContentType('application/json')
    .AddHeader('access-token',apiToken) //passando token da api
    .AddBody(body)
    .Post;

   result :=IntToStr(LResponse.StatusCode)+#13+ #13+
            LResponse.Content ;

end;

function TIntegraDev.EnviarURL(fones, url, tipoDocumento: string): string;
var LResponse: IResponse;
   body : String;
begin
     if (trim(apiToken) = '') then
     Begin
          MessageDlg('Token da API não informado',mterror,[mbOK],0);
          exit;
     end;

     if (trim(instanciaToken) = '') then
     Begin
          MessageDlg('Token da Instancia não informado',mterror,[mbOK],0);
          exit;
     end;


     // atenção ao criar o objeto precisa ser valido
     body := '{ "url" : "'+url +'"'+
             ' , "delayMessage" : 0 ' +
             ' , "to" : ['+fones+']' +
             ' , "type" : "'+tipoDocumento+'"' +
             ' }';

   LResponse := TRequest.New.BaseURL(getEndPoint+'/send-file-url')//passando url para texto
    .ContentType('application/json')
    .AddHeader('access-token',apiToken) //passando token da api
    .AddBody(body)
    .Post;

   result :=IntToStr(LResponse.StatusCode)+#13+ #13+
            LResponse.Content

end;


function TIntegraDev.EnviarImagem(fone, pathFile, caption: string): string;
var LResponse: IResponse;
    body : String;
begin
     if (trim(apiToken) = '') then
     Begin
          MessageDlg('Token da API não informado',mterror,[mbOK],0);
          exit;
     end;

     if (trim(instanciaToken) = '') then
     Begin
          MessageDlg('Token da Instancia não informado',mterror,[mbOK],0);
          exit;
     end;


     // atenção ao criar o objeto precisa ser valido
     body := '{ "file64" : "'+FileToBase64(pathFile)+'"'+
             ' , "delayMessage" : 0 ' +
             ' , "to" : ['+fone+']' +
             ' , "caption" : "'+caption+'"' +
             ' }';

     LResponse := TRequest.New.BaseURL(getEndPoint+'/send-image')//passando url para image
      .ContentType('application/json')
      .AddHeader('access-token',apiToken) //passando token da api
      .AddBody(body)
      .Post;

     result :=IntToStr(LResponse.StatusCode)+#13+ #13+
              LResponse.Content

end;

function TIntegraDev.EnviarVideo(fone, pathFile, caption: string): string;
var LResponse: IResponse;
    body : String;
begin
     if (trim(apiToken) = '') then
     Begin
          MessageDlg('Token da API não informado',mterror,[mbOK],0);
          exit;
     end;

     if (trim(instanciaToken) = '') then
     Begin
          MessageDlg('Token da Instancia não informado',mterror,[mbOK],0);
          exit;
     end;


     // atenção ao criar o objeto precisa ser valido
     body := '{ "file64" : "'+FileToBase64(pathFile)+'"'+
             ' , "delayMessage" : 0 ' +
             ' , "to" : ['+fone+']' +
             ' , "caption" : "'+caption+'"' +
             ' }';

     LResponse := TRequest.New.BaseURL(getEndPoint+'/send-video')//passando url para image
      .ContentType('application/json')
      .AddHeader('access-token',apiToken) //passando token da api
      .AddBody(body)
      .Post;

     result :=IntToStr(LResponse.StatusCode)+#13+ #13+
              LResponse.Content
end;

function TIntegraDev.EnviarDocumento(fone, pathFile, fileName: string): string;
var LResponse: IResponse;
    body : String;
begin
     if (trim(apiToken) = '') then
     Begin
          MessageDlg('Token da API não informado',mterror,[mbOK],0);
          exit;
     end;

     if (trim(instanciaToken) = '') then
     Begin
          MessageDlg('Token da Instancia não informado',mterror,[mbOK],0);
          exit;
     end;


     // atenção ao criar o objeto precisa ser valido
     body := '{ "file64" : "'+FileToBase64(pathFile)+'"'+
             ' , "delayMessage" : 0 ' +
             ' , "to" : ['+fone+']' +
             ' , "filename" : "'+fileName+'"' +
             ' }';

     LResponse := TRequest.New.BaseURL(getEndPoint+'/send-document')//passando url para image
      .ContentType('application/json')
      .AddHeader('access-token',apiToken) //passando token da api
      .AddBody(body)
      .Post;

     result :=IntToStr(LResponse.StatusCode)+#13+ #13+
              LResponse.Content

end;

end.

