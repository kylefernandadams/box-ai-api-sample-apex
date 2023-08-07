public with sharing class BoxAiFlowAction {
    public class BoxRequest {
        @InvocableVariable(label='Mode')
        public String boxAiMode;

        @InvocableVariable(label='Prompt')
        public String boxAiPrompt;

        @InvocableVariable(label='Item Collection')
        public List<BoxAiItem> boxAiItemCollection;

        @InvocableVariable(label='Dialogue History Collection')
        public List<BoxAiDialogueHistory> boxAiDialogueHistoryCollection;

        @InvocableVariable(label='Is Answer Streamed?')
        public Boolean isAnswerStreamed;

        @InvocableVariable(label='Box Access Token')
        public String boxAccessToken;
    }

    public class BoxResult {
        @InvocableVariable(label='Answer')
        public String boxAiAnswer;

        @InvocableVariable(label='Created At')
        public String boxAiCreatedAt;

        @InvocableVariable(label='Completion Reason')
        public String boxAiCompletionReason;

        @InvocableVariable(label='BoxAI Error')
        public BoxAiException error;
    }

    @InvocableMethod(label='Box AI - Send Request' category='Box')
    public static List<BoxResult> sendAIRequest(List<BoxRequest> boxRequestList) {
        List<BoxResult> boxResultList = new List<BoxResult>();
        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = new BoxResult();

            try{
                // Check if BoxAI Items existUpdat
                if(boxRequest.boxAiItemCollection?.size() > 0) {

                    // Get all of the items and add it to a list
                    List<BoxAiRequest.Item> itemList = new List<BoxAiRequest.Item>();
                    for(BoxAiItem boxAiItemFromFlow: boxRequest.boxAiItemCollection) {
                        BoxAiRequest.Item boxAiItem = new BoxAiRequest.Item();
                        boxAiItem.id = boxAiItemFromFlow.itemId;
                        boxAiItem.type = boxAiItemFromFlow.itemType;

                        if(String.isBlank(boxAiItemFromFlow.itemContent)) {
                            boxAiItem.content = '';
                        }
                        else {
                            boxAiItem.content = boxAiItemFromFlow.itemContent;
                        }

                        itemList.add((boxAiItem));
                    }

                    // If a dialogue history has been provided, loop through and add it to a list
                    List<BoxAiRequest.DialogueHistory> dialogueHistoryList = new List<BoxAiRequest.DialogueHistory>();
                    if(boxRequest.boxAiDialogueHistoryCollection?.size() > 0) {
                        for(BoxAiDialogueHistory dialogueHistoryFromFlow: boxRequest.boxAiDialogueHistoryCollection) {
                            BoxAiRequest.DialogueHistory dialogueHistory = new BoxAiRequest.DialogueHistory();
                            dialogueHistory.answer = dialogueHistoryFromFlow.answer;
                            dialogueHistory.created_at = dialogueHistoryFromFlow.createdAt;
                            dialogueHistory.prompt = dialogueHistoryFromFlow.prompt;
                            dialogueHistoryList.add(dialogueHistory);
                        }
                        
                    }

                    // Create the BoxAiRequest object
                    BoxAiRequest boxAiRequest = new BoxAiRequest();
                    boxAiRequest.items = itemList;
                    boxAiRequest.dialogue_history = dialogueHistoryList;

                    BoxAiRequest.Config boxAiConfig = new BoxAiRequest.Config();
                    boxAiConfig.is_streamed = boxRequest.isAnswerStreamed;
                    boxAiRequest.config = boxAiConfig;
                    boxAiRequest.mode = boxRequest.boxAiMode;
                    boxAiRequest.prompt = boxRequest.boxAiPrompt;

                    // Send BoxAI Request and return a response
                    BoxAiService boxAiService = new BoxAiService();
                    BoxAiResponse boxAiResponse = boxAiService.sendRequest(boxAiRequest, boxRequest.boxAccessToken);
                    boxResult.boxAIAnswer = boxAiResponse.answer;
                    boxResult.boxAiCompletionReason = boxAiResponse.completion_reason;
                    boxResult.boxAiCreatedAt = boxAiResponse.created_at;
                    boxResult.error = boxAiResponse.error;

                    boxResultList.add(boxResult);
                }
                else {
                    throw new BoxAiException('No item collection was provided');
                }
            }
            catch(BoxAiFlowActionException e) {
                System.debug(e.getMessage());
            }
        }
        return boxResultList;
    }

    public class BoxAiFlowActionException extends Exception {
    }
}