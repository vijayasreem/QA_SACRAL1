trigger nfrn_ndm_master_data_lambda on NFRN_Region__c (before insert, before update, before delete){
    //Validate JWT token
    if(!ValidateJWT()){
        //Unauthorized access
        System.debug('Unauthorized access');
        System.assert(false, 'Unauthorized access');
    }

    //Validate administrative privileges
    if(!ValidateAdmin()){
        //Forbidden access
        System.debug('Forbidden access');
        System.assert(false, 'Forbidden access');
    }
    
    //Check if operation is insert, update or delete
    if(Trigger.isInsert){
        //Getting list of all NFRN regions
        List<NFRN_Region__c> nfrnRegions = [SELECT Id, RegionName
                                            FROM NFRN_Region__c];
        //Return list of all NFRN regions in JSON format
        System.debug(JSON.serialize(nfrnRegions));
    }
    
    if(Trigger.isUpdate){
        //Getting list of all NFRN regions
        List<NFRN_Region__c> nfrnRegions = [SELECT Id, RegionName
                                            FROM NFRN_Region__c];
        //Return list of all NFRN regions in JSON format
        System.debug(JSON.serialize(nfrnRegions));
    }
    
    if(Trigger.isDelete){
        //Getting list of all NFRN regions
        List<NFRN_Region__c> nfrnRegions = [SELECT Id, RegionName
                                            FROM NFRN_Region__c];
        //Return list of all NFRN regions in JSON format
        System.debug(JSON.serialize(nfrnRegions));
    }
}