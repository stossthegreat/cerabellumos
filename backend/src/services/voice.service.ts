import axios from "axios";
import { ENV } from "../utils/env";

/**
 * Voice Service - Eleven Labs TTS Integration
 * 
 * Generates natural speech for the Study OS companion.
 * Different voice settings for different emotional contexts.
 */

export type VoiceEmotion = "calm" | "urgent" | "hype" | "encouraging";

export class VoiceService {
  private apiKey: string;
  private voiceId: string;
  private baseUrl = "https://api.elevenlabs.io/v1";

  constructor() {
    this.apiKey = ENV.ELEVENLABS_API_KEY || "";
    this.voiceId = ENV.ELEVENLABS_VOICE_ID || "";

    if (!this.apiKey || !this.voiceId) {
      console.warn("⚠️ Eleven Labs not configured. Voice features disabled.");
    }
  }

  /**
   * Generate speech from text with emotional context
   */
  async generateSpeech(
    text: string,
    emotion: VoiceEmotion = "calm"
  ): Promise<Buffer | null> {
    if (!this.apiKey || !this.voiceId) {
      console.log("⚠️ Eleven Labs not configured, skipping TTS");
      return null;
    }

    try {
      console.log(`🎤 Generating speech (${emotion}): "${text.substring(0, 50)}..."`);

      const response = await axios.post(
        `${this.baseUrl}/text-to-speech/${this.voiceId}`,
        {
          text,
          model_id: "eleven_monolingual_v1",
          voice_settings: this.getVoiceSettings(emotion),
        },
        {
          headers: {
            "xi-api-key": this.apiKey,
            "Content-Type": "application/json",
          },
          responseType: "arraybuffer",
        }
      );

      console.log(`✅ Speech generated successfully (${response.data.byteLength} bytes)`);
      return Buffer.from(response.data);
    } catch (error: any) {
      console.error("❌ Eleven Labs TTS error:", error.message);
      if (error.response) {
        console.error("Response data:", error.response.data);
      }
      return null;
    }
  }

  /**
   * Get voice settings based on emotional context
   */
  private getVoiceSettings(emotion: VoiceEmotion) {
    switch (emotion) {
      case "calm":
        return {
          stability: 0.75,
          similarity_boost: 0.75,
          style: 0.0,
          use_speaker_boost: true,
        };

      case "urgent":
        return {
          stability: 0.5,
          similarity_boost: 0.8,
          style: 0.4,
          use_speaker_boost: true,
        };

      case "hype":
        return {
          stability: 0.4,
          similarity_boost: 0.85,
          style: 0.6,
          use_speaker_boost: true,
        };

      case "encouraging":
        return {
          stability: 0.65,
          similarity_boost: 0.8,
          style: 0.2,
          use_speaker_boost: true,
        };

      default:
        return {
          stability: 0.75,
          similarity_boost: 0.75,
          style: 0.0,
          use_speaker_boost: true,
        };
    }
  }

  /**
   * Convert audio buffer to base64 for mobile transmission
   */
  bufferToBase64(buffer: Buffer): string {
    return buffer.toString("base64");
  }

  /**
   * Check if voice service is configured
   */
  isConfigured(): boolean {
    return !!(this.apiKey && this.voiceId);
  }
}

export const voiceService = new VoiceService();
