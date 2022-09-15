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