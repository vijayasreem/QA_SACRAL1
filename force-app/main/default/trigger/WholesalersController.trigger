·       Ability to view the sub functionality when click on user functionality.                 ·       User should be able to redirect to login page if user doesn't have access.                 ·       User should be able to view the results in excel format when click on download data.                 ·       User should be able to filter the data using the drop down menu.                 ·       User should be able to add/edit the wholesaler.
Trigger:
trigger Wholesalers on Wholesalers__c (before insert, before update) {
 
  //validate username
  if(Trigger.isInsert || Trigger.isUpdate){
    for(Wholesalers__c w : Trigger.new){
      if(String.isBlank(w.Name)){
        w.adderror('WHOLESALER NAME BLANK');
      }
      if(!String.isBlank(w.Name) && Trigger.isInsert){
        Wholesalers__c checkW = [SELECT Id FROM Wholesalers__c WHERE Name = :w.Name LIMIT 1];
        if(checkW != null){
          w.adderror('WHOLESALER DUPLICATE NAME');
        }
      }
    }
    //validate number
    for(Wholesalers__c w : Trigger.new){
      if(!String.isBlank(w.Number) && !String.valueOf(w.Number).matches('/^\d+$/')){
        w.adderror('WHOLESALER INVALID NUMBER');
      }
      if(!String.isBlank(w.Number) && Trigger.isInsert){
        Wholesalers__c checkW = [SELECT Id FROM Wholesalers__c WHERE Number = :w.Number LIMIT 1];
        if(checkW != null){
          w.adderror('WHOLESALER DUPLICATE NUMBER');
        }
      }
    }
    
    //validate type
    for(Wholesalers__c w : Trigger.new){
      if(!String.isBlank(w.Type) && !(w.Type == 'I' || w.Type == 'M')){
        w.adderror('WHOLESALER INVALID TYPE');
      }
    }
  }
 
  //redirect to login page if user doesn't have access
  if(!UserInfo.isCurrentUserLicensed('Wholesalers')){
    PageReference pageRef = new PageReference('/login');
    pageRef.setRedirect(true);
    return pageRef;
  }
}