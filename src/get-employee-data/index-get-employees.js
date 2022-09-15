"use strict";
/**
 @Module
* create a lambda function for inserting employee data
*/

const { Client } = require('pg')
const cors = require("cors");
app.use(cors());
app.use(express.json());
const FILE = "src/index.js";
const utils = require('./utils');

// https://node-server-employee-data-aws.herokuapp.com/

/** 
 * Entry point of lambda function
 * @param {object} event - 
 * @param context 
 * @param callback
 */

const db = new Client({
    user: 'postgres',
    host: 'database-2.c8vulry6drc6.ap-south-1.rds.amazonaws.com',
    database: 'employee-data',
    password: 'mypassword',
    port: 5432
})

// lambda entry point
module.exports.handler = async function(event, context, callback) {
    let response = null;
    try {
        console.log(FILE, " handler() - start:event" + JSON.stringify(event, null, 2));
        let dbQuery = `SELECT * FROM "employeeTable`;
        let result = await db.query(dbQuery);
        response = utils.buildSuccessResponse(result);
    } catch (err) {
        console.log("error happended" + err);
        response = utils.buildFailureResponse(err);
    }
    return response;
}



app.get('/employees', (req, res) => {
    db.query(`SELECT * FROM "employeeTable"`, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.send(result);
        }
    });
});

app.put('/update', (req, res) => {
    const id = req.body.id;
    const wage = req.body.wage;
    db.query(
        `UPDATE "employeeTable" SET wage = '${wage}' WHERE id = '${id}'`,
        (err, result) => {
            if (err) {
                console.log(err);
            } else {
                res.send(result);
            }
        }
    );
});

app.delete('/delete/:id', (req, res) => {
    const id = req.params.id;
    console.log(id);
    db.query(`DELETE FROM "employeeTable" WHERE id = ${id}`, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            res.send(result);
        }
    });
});

app.listen(3001, () => {
    console.log("server running at 3001");
})