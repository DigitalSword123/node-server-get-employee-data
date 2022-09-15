module.exports.buildSuccessResponse = function(respons) {
    return {
        "success": "true",
        "message": "employee data added to table"
    };
}

module.exports.buildFailureResponse = function(respons) {
    return {
        "success": "false",
        "message": "errror occured in during employee data added to table"
    };
}

module.exports.buildDataNotFound = function(ServiceRequest) {
    let name = ServiceRequest.name;
    return {
        "success": "false",
        "message": `no data found for ${name}`
    };
}