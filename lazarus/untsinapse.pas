unit untSinapse;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, dialogs;
   function EnviarArquivo(pathFile, fone, caption, url: string): Boolean;

implementation

function EnviarArquivo(pathFile, fone, caption, url: string): Boolean;
var
  HTTPClient: TFPHTTPClient;
  FormData: TMemoryStream;
  Bound, s: string;
  resp : TStrings;
begin
  Result := False;

  HTTPClient := TFPHTTPClient.Create(nil);
  FormData := TMemoryStream.Create;
  try
    Bound := '---------------------------' + IntToHex(Random(MaxInt), 8) + IntToHex(Random(MaxInt), 8);

    // Adiciona campo fone
    s := '--' + Bound + #13#10;
    s := s + 'Content-Disposition: form-data; name="fone"' + #13#10 + #13#10;
    s := s + fone + #13#10;
    FormData.Write(Pointer(s)^, Length(s));

    // Adiciona campo caption
    s := '--' + Bound + #13#10;
    s := s + 'Content-Disposition: form-data; name="caption"' + #13#10 + #13#10;
    s := s + caption + #13#10;
    FormData.Write(Pointer(s)^, Length(s));

    // Adiciona arquivo
    s := '--' + Bound + #13#10;
    s := s + 'Content-Disposition: form-data; name="file"; filename="' + ExtractFileName(pathFile) + '"' + #13#10;
    s := s + 'Content-Type: application/octet-stream' + #13#10 + #13#10;
    FormData.Write(Pointer(s)^, Length(s));

    FormData.CopyFrom(TFileStream.Create(pathFile, fmOpenRead), 0);

    s := #13#10 + '--' + Bound + '--' + #13#10;
    FormData.Write(Pointer(s)^, Length(s));

    HTTPClient.AddHeader('Content-Type', 'multipart/form-data; boundary=' + Bound);
    FormData.Position := 0; // Reset stream position

    HTTPClient.RequestBody := FormData;
    HTTPClient.Post(url, resp);

    showmessage(resp.Text)



    //Result := (HTTPClient.ResponseStatusCode = 200);
  finally
    HTTPClient.Free;
    FormData.Free;
  end;
end;

end.

