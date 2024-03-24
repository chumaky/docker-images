#!/usr/bin/env sh

# Wait for Redis server to be ready
sleep 10

# Load data into Redis
redis-cli -h redis hset users:1 id 1 name John
redis-cli -h redis hset users:2 id 2 name Sarah
redis-cli -h redis hset users:3 id 3 name T-800
