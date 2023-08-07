public class BoxAiException extends Exception {

	@AuraEnabled @InvocableVariable public Integer status;
	@AuraEnabled @InvocableVariable public String message;
	@AuraEnabled @InvocableVariable public String help_url;
	@AuraEnabled @InvocableVariable public String request_id;
	@AuraEnabled @InvocableVariable public String type;
	@AuraEnabled @InvocableVariable public String code;

	
	public static BoxAiException parse(String json) {
		return (BoxAiException) System.JSON.deserialize(json, BoxAiException.class);
	}
}