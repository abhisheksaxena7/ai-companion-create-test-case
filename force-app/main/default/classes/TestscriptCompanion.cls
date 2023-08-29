global with sharing class TestscriptCompanion implements copadoAiHelper.Action.Actionable{
    global String[] appliesTo() {
        // declare for which objects this action is relevant.
        // return an empty array if the action is relevant to any object.
        return new String[]{};
    }

    global String jsonSchema() {
        // the name will be visible to the user, so be clear and concise
        // the description will be relevant to OpenAI ... be clear and verbose
        return '{'+
        '    "name": "create_test_script",'+
        '    "description": "Given a conversation with the customer on the AI Companion, create a test script for the User Story Customer is on",'+
        '    "examples": ["create a test script in Copado"],'+
        '    "parameters": {'+
        '        "type": "object",'+
        '        "properties": {'+
        '            "title": {'+
        '                "type": "string",'+
        '                "description": "The title of the test case"'+
        '            },'+
        '             "introduction": {'+
        '                "type": "string",'+
        '                "description": "The introduction of the test case"'+
        '            },'+
        '             "description": {'+
        '                "type": "string",'+
        '                "description": "The description of the test case"'+
        '            },'+
        '             "prerequisites": {'+
        '                "type": "string",'+
        '                "description": "The prerequisites of the test case"'+
        '            },'+
        '             "expected": {'+
        '                "type": "string",'+
        '                "description": "The expected result of the test case"'+
        '            },'+
        '             "userstory": {'+
        '                "type": "string",'+
        '                "description": "The User Story associated with the test case"'+
        '            },'+
        '             "risk": {'+
        '                "type": "string",'+
        '                "description": "The risk of the test case"'+
        '            }},'+
        '        "required": ["userstory","title","introduction","description","expected"]'+
        '    }'+
        '}';
    }

    public class MyException extends Exception {}

    global copadoAiHelper.ActionResponse call(Id contextId, Map<String, Object> args) {
        // this parameter is automatically added. It might be null if the action is not for specific objects.
        String copadoContextId = (String)args.get('copadoContextId');
        String userStoryNumber = (String) args.get('userstory');
        String title = (String) args.get('title');
        String introduction = (String) args.get('introduction');
        String testDescription = (String) args.get('description');
        String prerequisites = (String) args.get('prerequisites');
        String expectedResult = (String) args.get('expected');
        String risk = (String) args.get('risk');

        Boolean success = TestscriptCompanion.createTestScript(title, introduction, testDescription, prerequisites, expectedResult, risk, userStoryNumber);
        if (success){
            return new copadoAiHelper.ActionResponse('I have created the Test case with Subject: ' + title);
        }
            return new copadoAiHelper.ActionResponse('I could not created the support case. Something went wrong.');
    }

    public static Boolean createTestScript(String title, String introduction, String testDescription,
                                            String prerequisites, String expectedResult, String risk, String userStoryNumber){
        copado__Test_Script__c testScript = new copado__Test_Script__c();
        testScript.copado__Test_Title__c = title;
        testScript.copado__Introduction__c = introduction;
        testScript.copado__Test_Description__c = testDescription;
        testScript.copado__Prerequisites__c = prerequisites;
        testScript.copado__Expected_Result__c = expectedResult;
        testScript.copado__Risk__c = risk;

        try{
            copado__User_Story__c userStory = [SELECT ID FROM copado__User_Story__c WHERE Name=:userStoryNumber];
            testScript.copado__User_Story__c = userStory.ID;
        }
        catch(Exception e){
            String errorMsg = 'userStory='+userStoryNumber+'Title='+title+'introduction='+introduction+'testDescription='+testDescription+'prerequisites='+prerequisites+'expectedResult'+expectedResult+'risk='+risk;
            throw new MyException(errorMsg);
        }

        insert testScript;

        return true;
    }
}
