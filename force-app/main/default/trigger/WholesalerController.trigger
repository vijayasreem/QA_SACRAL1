·       User able to find the sub functionalities when he clicks user’s functionality.·       User able to access the sub functionalities like edit, view and download.·       If user has access then user able to access this page.·       If user didn’t have access then redirect to login page.·       User name should not be empty; username should be unique.·       Number should not be empty and should be number "/^\d+$/" and should be unique.·       Clicking on Download Data will allow User to view the results in Excel format.·       User have the option of filtering the data using the drop down menuType.·       The Submit and Reset buttons are given on this screen.·       Once User have made User selections click on Submit it will add/edit the wholesaler, or click on Reset to reset the selections to the last search.
Trigger WholesalerTrigger on Wholesaler__c (Before insert, Before update) {
 
  // User has access
  If(Userinfo.getUserRoleId() != null) {
 
    // User name should not be empty; username should be unique
    For(Wholesaler__c w : Trigger.new) {
      If(w.Name == null) {
        w.addError('WHOLESALER NAME BLANK');
      } Else If(Trigger.isInsert) {
        Wholesaler__c existingW = [SELECT Name FROM Wholesaler__c WHERE Name = :w.Name];
        If(existingW != null) {
          w.addError('WHOLESALER DUPLICATE NAME');
        }
      }
    }
 
    // Number should not be empty and should be number "/^\d+$/" and should be unique
    For(Wholesaler__c w : Trigger.new) {
      If(w.Number__c == null) {
        w.addError('WHOLESALER INVALID NUMBER');
      } Else If(!String.valueOf(w.Number__c).matches('/^\d+$/')) {
        w.addError('WHOLESALER INVALID NUMBER');
      } Else If(Trigger.isInsert) {
        Wholesaler__c existingW = [SELECT Number__c FROM Wholesaler__c WHERE Number__c = :w.Number__c];
        If(existingW != null) {
          w.addError('WHOLESALER DUPLICATE NUMBER');
        }
      }
    }
 
    // Type should not be empty
    For(Wholesaler__c w : Trigger.new) {
      If(w.Type__c == null) {
        w.addError('TYPE IS REQUIRED');
      }
    }
 
    // Date created cannot be modified
    For(Wholesaler__c w : Trigger.new) {
      w.Date_Created__c = Trigger.oldMap.get(w.id).Date_Created__c;
    }
 
    // Last modified date should be set to the current date
    For(Wholesaler__c w : Trigger.new) {
      w.Last_Modified__c = Date.today();
    }
  }
 
  // User does not have access
  Else {
    // Redirect user to the login page
    PageReference loginPage = new PageReference('/login');
    loginPage.setRedirect(true);
    return loginPage;
  }
}