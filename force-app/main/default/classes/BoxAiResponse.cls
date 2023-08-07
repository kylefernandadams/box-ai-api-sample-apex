public class BoxAiResponse {

	public String answer;
	public String created_at;
	public String completion_reason;
    public BoxAiException error;

	
	public static BoxAiResponse parse(String json) {
		return (BoxAiResponse) System.JSON.deserialize(json, BoxAiResponse.class);
	}
}