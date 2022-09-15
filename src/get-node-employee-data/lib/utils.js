module.exports.buildSuccessResponse = function(respons) {
    return {
        "success": "true",
        "message": "employee data fetch sucess"
    };
}

module.exports.buildFailureResponse = function(ServiceRequest) {
    return {
        "success": "false",
        "message": "errror occured in getting the data from database"
    };
}

module.exports.buildDataNotFound = function(ServiceRequest) {
    let name = ServiceRequest.name;
    return {
        "success": "false",
        "message": `no data found for ${name}`
    };
}