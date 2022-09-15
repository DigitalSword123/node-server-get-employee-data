"use strict";
/**
 @Module
* create a lambda function for inserting employee data to aws postgress database
*/

// including git hub action deployement

const FILE = "src/index.js";
const utils = require('./lib/utils');
const postgresUno = require('postgres-uno');

// https://node-server-employee-data-aws.herokuapp.com/

/** 
 * Entry point of lambda function
 * @param {object} event - 
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
module.exports.handler = async function(event, context, callback) {
    let response = null;
    let db = new postgresUno();
    try {
        console.log(FILE, " handler() - start:event" + JSON.stringify(event, null, 2));
        await db.connect(dbConfig);
        const name = event.body.name;
        const age = event.body.age;
        const country = event.body.country;
        const wage = event.body.wage;
        const position = event.body.position;

        let dbQuery = `INSERT INTO "employeeTable"(name, age, country, position, wage) VALUES ('${name}','${age}','${country}','${position}','${wage}')`;
        let result = await db.query(dbQuery);
        response = utils.buildSuccessResponse(result);
    } catch (err) {
        console.log("error happended" + err);
        response = utils.buildFailureResponse(err);
    }
    return response;
};