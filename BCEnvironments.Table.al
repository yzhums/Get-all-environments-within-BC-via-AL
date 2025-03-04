table 50102 "BC Environments"
{
    Caption = 'BC Environments';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Application Family"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Type; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; State; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Contry/Region"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Current Version"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }

    procedure GetEnvironments()
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        JsonResponse: JsonObject;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;
        JsonObjectLoop: JsonObject;
        AuthToken: SecretText;
        EnvironmentEndpointUrl: Text;
        ResponseText: Text;
        FileName: Text;
        BCEnvironments: Record "BC Environments";
    begin
        BCEnvironments.Reset();
        BCEnvironments.DeleteAll();
        // Get OAuth token
        AuthToken := GetOAuthToken();

        if AuthToken.IsEmpty() then
            Error('Failed to obtain access token.');

        // Define the BC Environment Endpoint URL

        EnvironmentEndpointUrl := 'https://api.businesscentral.dynamics.com/admin/v2.3/applications/businesscentral/environments';
        // Initialize the HTTP request
        HttpRequestMessage.SetRequestUri(EnvironmentEndpointUrl);
        HttpRequestMessage.Method := 'GET';
        HttpRequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', AuthToken));

        // Send the HTTP request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            // Log the status code for debugging
            //Message('HTTP Status Code: %1', HttpResponseMessage.HttpStatusCode());

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                HttpResponseMessage.Content.ReadAs(ResponseText);
                JsonResponse.ReadFrom(ResponseText);

                if JsonResponse.Get('value', JsonToken) then begin
                    JsonArray := JsonToken.AsArray();
                    BCEnvironments.Init();
                    foreach JsonTokenLoop in JsonArray do begin
                        JsonObjectLoop := JsonTokenLoop.AsObject();
                        if JsonObjectLoop.Get('name', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments.Name := JsonValue.AsText();
                        end;
                        if JsonObjectLoop.Get('applicationFamily', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments."Application Family" := JsonValue.AsText();
                        end;
                        if JsonObjectLoop.Get('type', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments.Type := JsonValue.AsText();
                        end;
                        if JsonObjectLoop.Get('status', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments.State := JsonValue.AsText();
                        end;
                        if JsonObjectLoop.Get('countryCode', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments."Contry/Region" := JsonValue.AsText();
                        end;
                        if JsonObjectLoop.Get('applicationVersion', JsonTokenLoop) then begin
                            JsonValue := JsonTokenLoop.AsValue();
                            BCEnvironments."Current Version" := JsonValue.AsText();
                        end;
                        BCEnvironments.Insert();
                    end;
                end;

            end else begin
                //Report errors!
                HttpResponseMessage.Content.ReadAs(ResponseText);
                Error('Failed to fetch files from Endpoint: %1 %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
            end;
        end else
            Error('Failed to send HTTP request to Endpoint');
    end;

    procedure GetOAuthToken() AuthToken: SecretText
    var
        ClientID: Text;
        ClientSecret: Text;
        TenantID: Text;
        AccessTokenURL: Text;
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
    begin
        ClientID := 'b4fe1687-f1ab-4bfa-b494-0e2236ed50bd';
        ClientSecret := 'huL8Q~edsQZ4pwyxka3f7.WUkoKNcPuqlOXv0bww';
        TenantID := '7e47da45-7f7d-448a-bd3d-1f4aa2ec8f62';
        AccessTokenURL := 'https://login.microsoftonline.com/' + TenantID + '/oauth2/v2.0/token';
        Scopes.Add('https://api.businesscentral.dynamics.com/.default');
        if not OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, AccessTokenURL, '', Scopes, AuthToken) then
            Error('Failed to get access token from response\%1', GetLastErrorText());
    end;
}
