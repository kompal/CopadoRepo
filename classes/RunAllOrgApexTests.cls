global with sharing class RunAllOrgApexTests {
	/**
	 * Custom object for storing InvocableVariables. InvocableMethods requires List<T> where T is a user defined type.
	 * You cannot pass Boolean, String or any other primitive type as a variable to an Invocable method.
	 * Custom Object types, sObjects or Ids are the only supported types.
	 * @see InvocableVariable
	 * @see InvocableMethod
	 */
	global class InvocableVariables {
		@InvocableVariable(label = 'Org Credentials Id' required = TRUE)
		global Id orgId;
	}
	/**
	 * Invocable method for allowing users to call Copado webhook urls for running a selenium test from Process builder
	 * @param  variables InvocableVariables
	 * @return           void
	 * @see InvocableVariable
	 * @see InvocableMethod
	 * @see RunAllOrgApexTests.doCallout
	 */
	@InvocableMethod(label = 'Invoke Run All Apex Tests for an Org' description = 'Sends request to given Copado webhookUrl')
	global static void execute(List<InvocableVariables> variables){
		String apiKey = DeployAPI.getUserAPIKey();
		String copadoURL = Settings.Server_URL;
		if(String.isBlank(apiKey)) throw new AsyncException(System.Label.API_KEY_MISSING);
        String url = copadoURL+'/json/v1/webhook/testOrg/'+variables[0].orgId+'?api_key='+apiKey;
        RunAllOrgApexTests.doCallout(url);
    }
    /**
	 * Future method that executes the HTTP request against given webhook.
	 * Defined as future in order to avoid "You have uncommitted work pending. Please commit or rollback before calling out" issue
	 * Since process builder depends on a DML on the given object there will always be an uncommited work for immediate actions
	 * @param url     Complete copado webhook url that will appear as a required parameter while creating the process from process builder
	 */
    @Future(callout = TRUE)
	private static void doCallout(String url) {
		WebhookAPI.callGenericWebhook(url);
	}
}