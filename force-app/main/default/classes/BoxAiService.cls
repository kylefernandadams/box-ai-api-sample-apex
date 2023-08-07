public with sharing class BoxAiService {
    public static final String APPLICATION_JSON_HEADER = 'application/json';
    public static final String AUTHORIZATION_HEADER = 'Authorization';
    public static final String BEARER_PREFIX = 'Bearer ';
    public static final String BOX_AI_ENDPOINT = 'https://api.box.com/2.0/ai/ask';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String HTTP_METHOD = 'POST';

    public BoxAiResponse sendRequest(BoxAiRequest boxAiRequest, String token) {

        // Create HTTP Request
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod(HTTP_METHOD);
        httpRequest.setEndpoint(BOX_AI_ENDPOINT);
        httpRequest.setHeader(CONTENT_TYPE_HEADER, APPLICATION_JSON_HEADER);
        httpRequest.setHeader(AUTHORIZATION_HEADER, BEARER_PREFIX + token);

        // Serialize Object to JSON string
        httpRequest.setBody(JSON.serialize(boxAiRequest, true));

        // Send HTTP Request
        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);

        // Parse HTTP String body and cast to BoxAiResponse object
        BoxAiResponse boxAiResponse = BoxAiResponse.parse(httpResponse.getBody());
        
        return boxAiResponse;
    }
}