const express = require('express')
const app = express()
const { Client } = require('pg')
const cors = require("cors");

app.use(cors());
app.use(express.json());

// https://node-server-employee-data-aws.herokuapp.com/

const db = new Client({
    user: 'postgres',
    host: 'database-2.c8vulry6drc6.ap-south-1.rds.amazonaws.com',
    database: 'employee-info',
    password: 'mypassword',
    port: 5432,
})
db.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
});

app.post('/create', (req, res) => {
    const name = req.body.name;
    const age = req.body.age;
    const country = req.body.country;
    const wage = req.body.wage;
    const position = req.body.position;

    let dbQuery = `INSERT INTO "employeeTable"(name, age, country, position, wage) VALUES ('${name}','${age}','${country}','${position}','${wage}')`;
    db.query(dbQuery,
        (err, result) => {
            if (err) {
                console.log(err)
            } else {
                res.send
            }
        }
    )
})

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