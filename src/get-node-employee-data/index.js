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
// var AWS = require('aws-sdk');
// AWS.config.region = 'ap-south-1';

const { EventBridgeClient, ActivateEventSourceCommand } = require("@aws-sdk/client-eventbridge");
// a client can be shared by different commands.
const client = new EventBridgeClient({ region: "REGION" });


// Create CloudWatchEvents service object
// const eventbridge = new AWS.EventBridge();

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

        let request = JSON.parse(ServiceRequest.body);
        var req_name = request.name;
        console.log("req_name : " + req_name);

        let dbQuery = `SELECT * FROM "employeeTable" WHERE name='${req_name}'`;
        console.log("dbQuery : " + dbQuery)
        let result = await db.query(dbQuery);
        // console.log("result : " + JSON.stringify(result));
        if (result && result.rows && result.rows.length === 1) {
            response.name = result.rows[0].name;
            response.age = result.rows[0].age;
            response.country = result.rows[0].country;
            response.wage = result.rows[0].wage;
            response.position = result.rows[0].position;
            let date_ob = new Date();
            var params = {
                Entries: [ /* required */ {
                        "detail-type": "Task event bus",
                        "source": "myapp.events",
                        "time": "2019-11-21T01:22:33Z",
                        "account": "877760304415",
                        "region": "ap-south-1",
                        "EventBusName": "default",
                        "resources": [],
                        Time: new Date || 'Wed Dec 31 1969 16:00:00 GMT-0800 (PST)' || 123456789,
                        "detail": JSON.stringify(response)
                    }
                    /* more items */
                ]
            };
            console.log("params : " + JSON.stringify(params, null, 2))
                // var event_bridge_result = await eventbridge.putEvents(params, function(err, data) {
                //     if (err) console.log(err, err.stack); // an error occurred
                //     else console.log("success " + data); // successful response
                // });

            const command = new ActivateEventSourceCommand(params);

            var event_bridge_result = await client.send(command, function(err, data) {
                if (err) console.log(err, err.stack); // an error occurred
                else console.log("success " + data); // successful response
            });
            console.log("event_bridge_resuslt : " + JSON.stringify(event_bridge_result, getCircularReplacer()));
        } else {
            response = utils.buildDataNotFound(ServiceRequest)
        }

    } catch (err) {
        console.log("error happended" + err);
        response = utils.buildFailureResponse(err);
    }
    return response;
};


const getCircularReplacer = () => {
    const seen = new WeakSet();
    return (key, value) => {
        if (typeof value === 'object' && value !== null) {
            if (seen.has(value)) {
                return;
            }
            seen.add(value);
        }
        return value;
    };
};