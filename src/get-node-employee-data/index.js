"use strict";
/**
 @Module
* create a lambda function for inserting employee data to aws postgress database
*/

// including git hub action deployement

const FILE = "src/index.js";
const utils = require('./lib/utils');
const postgresUno = require('postgres-uno');
// Import required AWS SDK clients and commands for Node.js.
var AWS = require('aws-sdk');
AWS.config.update({ region: 'ap-south-1' });

// Create CloudWatchEvents service object
var ebevents = new AWS.EventBridge({ apiVersion: '2015-10-07' });

// https://node-server-employee-data-aws.herokuapp.com/

/** 
 * Entry point of lambda function
 * @param {object} ServiceRequest - 
 * @param context 
 * @param callback
 */

var dbConfig = {
    user: 'postgres',
    host: 'my-database-instance.cudkus0mfoea.ap-south-1.rds.amazonaws.com',
    database: 'employee_data',
    password: 'mypassword',
    port: 5432
};

// lambda entry point
module.exports.handler = async function(ServiceRequest, context, callback) {
    let response = {};
    let db = new postgresUno();
    try {
        console.log(FILE, " handler() - start:ServiceRequest" + JSON.stringify(ServiceRequest, null, 2));
        await db.connect(dbConfig);
        const req_name = ServiceRequest.body.name;
        console.log("req_name : " + req_name);
        let dbQuery = `SELECT * FROM "employeeTable" WHERE name='${req_name}'`;
        console.log("dbQuery : " + dbQuery)
        let result = await db.query(dbQuery);
        console.log("result : " + JSON.stringify(result));
        if (result && result.rows && result.rows.length === 1) {
            response.name = result.rows[0].name;
            response.age = result.rows[0].age;
            response.country = result.rows[0].country;
            response.wage = result.rows[0].wage;
            response.position = result.rows[0].position;
            var params = {
                Entries: [{
                    Detail: response,
                    DetailType: 'appRequestSubmitted',
                    Resources: [
                        'arn:aws:events:ap-south-1:877760304415:rule/employee-data-event-bus/employee-data',
                    ],
                    Source: 'arn:aws:lambda:ap-south-1:877760304415:function:get-node-employee-data-DEV'
                }]
            };
            ebevents.putEvents(params, function(err, data) {
                if (err) {
                    console.log("Error in sending to event bus", err);
                } else {
                    console.log("Success", data.Entries);
                }
            });
        } else {
            response = utils.buildDataNotFound(ServiceRequest)
        }

    } catch (err) {
        console.log("error happended" + err);
        response = utils.buildFailureResponse(err);
    }
    return response;
};