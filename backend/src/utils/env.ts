export const isDev = process.env.NODE_ENV !== "production";

export const ENV = {
  REDIS_URL: process.env.REDIS_URL || "redis://localhost:6379",
  DATABASE_URL: process.env.DATABASE_URL || "postgresql://postgres:postgres@localhost:5432/cerabellumos",
  
  // Eleven Labs TTS for companion voice
  ELEVENLABS_API_KEY: process.env.ELEVENLABS_API_KEY || "",
  ELEVENLABS_VOICE_ID: process.env.ELEVENLABS_VOICE_ID || "",
};
