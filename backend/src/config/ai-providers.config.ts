// backend/src/config/ai-providers.config.ts
// 🧠 AI Provider Configuration

export const AI_PROVIDERS = {
  // GPT-4o/4.1 - OS Intelligence & Neural Canvas Chat
  OS_INTELLIGENCE: {
    provider: "openai",
    model: process.env.OPENAI_MODEL || "gpt-4o",
    apiKey: process.env.OPENAI_API_KEY,
    use: ["daily_intel", "study_nudges", "neural_chat", "general_chat"],
  },

  // Together AI (DeepSeek V3) - Quiz, Image Analysis, Video Cards
  STUDY_ASSISTANT: {
    provider: "together",
    model: process.env.TOGETHER_MODEL || "deepseek-ai/deepseek-chat",
    apiKey: process.env.TOGETHER_API_KEY,
    baseURL: "https://api.together.xyz/v1",
    use: ["quiz_generation", "image_analysis", "video_to_cards", "problem_solving"],
  },

  // Google Vision - OCR & Image Analysis
  VISION: {
    provider: "google",
    apiKey: process.env.GOOGLE_VISION_API_KEY,
    use: ["ocr", "image_text_extraction"],
  },

  // Tesseract - Offline OCR fallback
  TESSERACT: {
    provider: "tesseract",
    use: ["ocr_fallback"],
  },
};

export type AIProvider = "openai" | "together" | "google" | "tesseract";
export type AITask =
  | "daily_intel"
  | "study_nudges"
  | "neural_chat"
  | "general_chat"
  | "quiz_generation"
  | "image_analysis"
  | "video_to_cards"
  | "problem_solving"
  | "ocr"
  | "image_text_extraction"
  | "ocr_fallback";

export function getProviderForTask(task: AITask): {
  provider: AIProvider;
  model?: string;
  apiKey?: string;
  baseURL?: string;
} {
  // OS Intelligence tasks → OpenAI GPT-4o
  if (
    task === "daily_intel" ||
    task === "study_nudges" ||
    task === "neural_chat" ||
    task === "general_chat"
  ) {
    return {
      provider: "openai",
      model: AI_PROVIDERS.OS_INTELLIGENCE.model,
      apiKey: AI_PROVIDERS.OS_INTELLIGENCE.apiKey,
    };
  }

  // Study Assistant tasks → Together AI (DeepSeek V3)
  if (
    task === "quiz_generation" ||
    task === "image_analysis" ||
    task === "video_to_cards" ||
    task === "problem_solving"
  ) {
    return {
      provider: "together",
      model: AI_PROVIDERS.STUDY_ASSISTANT.model,
      apiKey: AI_PROVIDERS.STUDY_ASSISTANT.apiKey,
      baseURL: AI_PROVIDERS.STUDY_ASSISTANT.baseURL,
    };
  }

  // OCR tasks → Google Vision (primary)
  if (task === "ocr" || task === "image_text_extraction") {
    return {
      provider: "google",
      apiKey: AI_PROVIDERS.VISION.apiKey,
    };
  }

  // Fallback
  return {
    provider: "openai",
    model: AI_PROVIDERS.OS_INTELLIGENCE.model,
    apiKey: AI_PROVIDERS.OS_INTELLIGENCE.apiKey,
  };
}

