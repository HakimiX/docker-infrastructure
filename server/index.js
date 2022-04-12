const { Pool } = require('pg');
const redis = require('redis');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const keys = require("./keys");

const app = express();
app.use(cors());
app.use(bodyParser.json());

const pgClient = new Pool({
  user: keys.pgUser,
  host: keys.pgHost,
  database: keys.pgDatabase,
  password: keys.pgPassword,
  port: keys.pgPort
});

pgClient.on('error', () => console.log('Lost Postgres connection'));

// Create initial table
pgClient.on("connect", (client) => {
  client
    .query('CREATE TABLE IF NOT EXISTS values (number INT)')
    .catch((err) => console.error(err));
});

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000 // if connection is lost, attempt to reconnect once every 1000ms
});

const redisPublisher = redisClient.duplicate();

app.get('/', (req, res) => {
  res.send('it works');
});

app.get('/values/all', async (req, res) => {
  const values = await pgClient.query('SELECT * from values');
  res.send(values.rows);
});

app.get('/values/current', async (req, res) => {
  // look at a hash value inside redis and get all the information from it
  redisClient.hgetall('values', (err, values) => {
    res.send(values);
  });
});

app.post('/values', async (req, res) => {
  const index = req.body.index;

  // check that the index is less than 40 (or else the fib calculation will take a very long time)
  if (parseInt(index) > 40) {
    return res.status(422).send('Index too high');
  }

  redisClient.hset('values', index, 'Nothing yet!'); // the worker will eventually replace 'Nothing yet'
  redisPublisher.publish('insert', index); // triggers worker process
  pgClient.query('INSERT INTO values(number) VALUES($1)', [index]);

  res.send({
    working: true
  });
});

const PORT = 5000;

app.listen(PORT, err => {
  console.log(`Listening on http://localhost:${PORT}`);
});
