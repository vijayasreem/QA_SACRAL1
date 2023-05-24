//Unit Tests
describe('loadWholesalerById_WholesalerController', function() {
    var component;

    beforeEach(function() {
        component = {
            get: function(actionName) {
                return {
                    setParams: function() {
                        return {
                            setCallback: function(scope, callbackFn) {
                                callbackFn({
                                    getState: function() {
                                        return 'SUCCESS';
                                    },
                                    getReturnValue: function() {
                                        return {
                                            id: 1,
                                            name: 'Wholesaler 1'
                                        };
                                    }
                                });
                            }
                        };
                    }
                };
            }
        };
        spyOn($A, 'enqueueAction').and.callFake(function(action) {
            action.getCallback()({
                getState: function() {
                    return 'SUCCESS';
                },
                getReturnValue: function() {
                    return {
                        id: 1,
                        name: 'Wholesaler 1'
                    };
                }
            });
        });
    });

    afterEach(function() {
        component = undefined;
    });

    it('should reject the promise with an appropriate error message when no id is provided', function(done) {
        // Call the function
        component.loadWholesalerById_WholesalerController(null).then(function() {
            // This should not be called
            expect(true).toBe(false);
            done();
        }, function(error) {
            expect(error.status).toBe(400);
            expect(error.message).toBe('ID parameter must be a positive integer');
            done();
        });
    });

    it('should reject the promise with an appropriate error message when an invalid id is provided', function(done) {
        // Call the function
        component.loadWholesalerById_WholesalerController(-1).then(function() {
            // This should not be called
            expect(true).toBe(false);
            done();
        }, function(error) {
            expect(error.status).toBe(400);
            expect(error.message).toBe('ID parameter must be a positive integer');
            done();
        });
    });

    it('should resolve the promise with wholesaler details when a valid id is provided', function(done) {
        // Call the function
        component.loadWholesalerById_WholesalerController(1).then(function(response) {
            expect(response.status).toBe(200);
            expect(response.wholesaler.id).toBe(1);
            expect(response.wholesaler.name).toBe('Wholesaler 1');
            done();
        }, function() {
            // This should not be called
            expect(true).toBe(false);
            done();
        });
    });

    it('should reject the promise with an appropriate error message when a non-existent id is provided', function(done) {
        // Mock the server response
        $A.enqueueAction.and.callFake(function(action) {
            action.getCallback()({
                getState: function() {
                    return 'ERROR';
                }
            });
        });

        // Call the function
        component.loadWholesalerById_WholesalerController(2).then(function() {
            // This should not be called
            expect(true).toBe(false);
            done();
        }, function(error) {
            expect(error.status).toBe(404);
            expect(error.message).toBe('Wholesaler not found');
            done();
        });
    });

});