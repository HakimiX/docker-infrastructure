const env = require('./config');
const redis = require('redis');

const redisClient = redis.createClient({
  host: env.redisHost,
  port: env.redisPort,
  retry_strategy: () => 1000 // if connection is lost, attempt to reconnect once every 1000ms
});

const sub = redisClient.duplicate();

/**
 * Calculate fibonacci number
 * @param  {number} index
 */
function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

/**
 * every time a new number shows up in redis, calculate the fibonacci value
 * and then insert that into a hash called 'values' and store it in Redis. T
 * The key (message) will be the index
 * */
sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)))
});

// Subsribe to insert events in Redis.
sub.subscribe('insert');
