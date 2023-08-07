public class BoxAiRequest {

    public class DialogueHistory {
		public String prompt;
		public String answer;
		public String created_at;
	}

    public class Config {
		public Boolean is_streamed;
	}

	public class Item {
		public String id;
		public String type;
		public String content;
	}

	public String mode;
	public String prompt;
	public List<Item> items;
    public List<DialogueHistory> dialogue_history;
	public Config config;

	
	public static BoxAiRequest parse(String json) {
		return (BoxAiRequest) System.JSON.deserialize(json, BoxAiRequest.class);
	}
}