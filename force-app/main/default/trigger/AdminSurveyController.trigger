trigger AdminSurveyController on Survey__c (before insert, before update) {

// check user permissions
if(UserInfo.getUserType() != 'Standard'){

// initialize constructor with default values
for(Survey__c s : Trigger.new){
    s.Survey_State__c = 'Not Started';
    s.Question_Count__c = 0;
    s.Rated_Count__c = 0;
}

// create survey
if(Trigger.isInsert){
    for(Survey__c s : Trigger.new){
        List<Question__c> questionList = new List<Question__c>();
        List<Survey_User_Mapping__c> userMappingList = new List<Survey_User_Mapping__c>();
 
        // create questions
        for(String q : s.Questions__c){
            Question__c qTemp = new Question__c(
                Survey__c = s.Id,
                Question_Text__c = q,
                Rating_Min__c = s.Rating_Min__c,
                Rating_Max__c = s.Rating_Max__c
            );
            questionList.add(qTemp);
        }
 
        // create mappings
        for(String u : s.Users__c){
            Survey_User_Mapping__c mapTemp = new Survey_User_Mapping__c(
                Survey__c = s.Id,
                User__c = u
            );
            userMappingList.add(mapTemp);
        }
 
        // insert records
        try{
            insert questionList;
            insert userMappingList;
        } catch (exception e){
            s.addError('Error creating survey');
        }
    }
}

// update survey
if(Trigger.isUpdate){
    for(Survey__c s : Trigger.new){
        // check state
        if(Trigger.oldMap.get(s.Id).Survey_State__c != 'Started'){
            List<Question__c> questionList = new List<Question__c>();
            List<Survey_User_Mapping__c> userMappingList = new List<Survey_User_Mapping__c>();
 
            // create questions
            for(String q : s.Questions__c){
                Question__c qTemp = new Question__c(
                    Survey__c = s.Id,
                    Question_Text__c = q,
                    Rating_Min__c = s.Rating_Min__c,
                    Rating_Max__c = s.Rating_Max__c
                );
                questionList.add(qTemp);
            }
 
            // create mappings
            for(String u : s.Users__c){
                Survey_User_Mapping__c mapTemp = new Survey_User_Mapping__c(
                    Survey__c = s.Id,
                    User__c = u
                );
                userMappingList.add(mapTemp);
            }
 
            // update records
            try{
                update questionList;
                update userMappingList;
            } catch (exception e){
                s.addError('Error updating survey');
            }
        }
    }
}

}