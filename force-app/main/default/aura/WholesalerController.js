/**
 * @description Load Wholesaler By Id
 * @author [Your Name]
 */
({
    /**
     * @description Load wholesaler by ID
     * @param {Integer} id - The ID of the wholesaler to be loaded
     * @returns {Promise} - A promise object containing the wholesaler details
     */
    loadWholesalerById_WholesalerController: function(id) {
        return new Promise($A.getCallback(function(resolve, reject) {
            if (id <= 0) {
                reject({
                    status: 400,
                    message: 'ID parameter must be a positive integer'
                });
            }
            // Call the Apex method to retrieve the wholesaler details
            var action = component.get('c.getWholesalerById');
            action.setParams({
                'id': id
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var wholesaler = response.getReturnValue();
                    // Resolve the promise with the wholesaler details
                    resolve({
                        status: 200,
                        wholesaler: wholesaler
                    });
                } else if (state === 'ERROR') {
                    reject({
                        status: 404,
                        message: 'Wholesaler not found'
                    });
                }
            });
            $A.enqueueAction(action);
        }));
    }
})