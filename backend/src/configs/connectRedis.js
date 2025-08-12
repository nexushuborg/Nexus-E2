import Redis from "ioredis";

import dotenv from "dotenv";
dotenv.config();
console.log('Redis URL:', process.env.REDIS_URL ? 'Found' : 'Not found');

// Create Redis client using the connection string
export const redisClient = new Redis(process.env.REDIS_URL, {
    retryDelayOnFailover: 100,
    maxRetriesPerRequest: 3,
    connectTimeout: 60000,
    lazyConnect: true,
});


redisClient.on('connect', () => {
    console.log('✅ Redis connected successfully');
});

redisClient.on('error', (err) => {
    console.error('❌ Redis connection error:', err.message);
});

redisClient.on('close', () => {
    console.log('⚠️ Redis connection closed');
});

export default redisClient;