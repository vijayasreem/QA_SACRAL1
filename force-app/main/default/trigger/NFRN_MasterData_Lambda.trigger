trigger NFRNRegionTrigger on NFRN__Region__c (after insert, after update, after delete) {
    // Security check
    if (!UserInfo.isCurrentUserSystemAdmin()) {
        System.debug('User is not an admin, cannot access NFRN Regions');
        return;
    }

    // Get list of NFRN Regions
    List<NFRN__Region__c> nfrnRegions = [SELECT Id, Region_Name__c FROM NFRN__Region__c];

    // Generate response with status code 200
    RestResponse response = new RestResponse();
    response.statusCode = 200;
    response.responseBody = JSON.serialize(nfrnRegions);

    // Send response
    RestContext.response.responseBody = response.responseBody;
    RestContext.response.statusCode = response.statusCode;
}