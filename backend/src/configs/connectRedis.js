import Redis from "ioredis";

import dotenv from "dotenv";
dotenv.config();
console.log('Redis URL:', process.env.REDIS_URL ? 'Found' : 'Not found');

// Create Redis client using the connection string
export const redisClient = new Redis(process.env.REDIS_URL || 'redis://localhost:6379', {
    retryDelayOnFailover: 100,
    maxRetriesPerRequest: 3,
    connectTimeout: 60000,
    lazyConnect: false,
    enableReadyCheck: true,
    retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
    }
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