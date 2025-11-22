// backend/src/services/ocr.service.ts
// 🖼️ OCR Service - Google Vision + Tesseract

import axios from "axios";
import FormData from "form-data";

const GOOGLE_VISION_API_KEY = process.env.GOOGLE_VISION_API_KEY;
const GOOGLE_VISION_URL = "https://vision.googleapis.com/v1/images:annotate";

export class OCRService {
  /**
   * Extract text from image using Google Vision (primary)
   */
  async extractText(imageBase64: string): Promise<{
    text: string;
    confidence: number;
    method: "google" | "tesseract";
  }> {
    // Try Google Vision first
    if (GOOGLE_VISION_API_KEY) {
      try {
        const result = await this.googleVisionOCR(imageBase64);
        return {
          text: result.text,
          confidence: result.confidence,
          method: "google",
        };
      } catch (err) {
        console.warn("⚠️ Google Vision failed, falling back to Tesseract:", err);
      }
    }

    // Fallback to Tesseract
    try {
      const result = await this.tesseractOCR(imageBase64);
      return {
        text: result.text,
        confidence: result.confidence,
        method: "tesseract",
      };
    } catch (err) {
      console.error("❌ Both OCR methods failed:", err);
      throw new Error("OCR failed");
    }
  }

  /**
   * Google Vision API OCR
   */
  private async googleVisionOCR(imageBase64: string): Promise<{
    text: string;
    confidence: number;
  }> {
    const response = await axios.post(
      `${GOOGLE_VISION_URL}?key=${GOOGLE_VISION_API_KEY}`,
      {
        requests: [
          {
            image: {
              content: imageBase64.replace(/^data:image\/\w+;base64,/, ""),
            },
            features: [
              {
                type: "DOCUMENT_TEXT_DETECTION",
                maxResults: 1,
              },
            ],
          },
        ],
      }
    );

    const annotations = response.data.responses[0]?.textAnnotations;
    if (!annotations || annotations.length === 0) {
      throw new Error("No text detected");
    }

    const text = annotations[0].description;
    const confidence = annotations[0].confidence || 0.9;

    return { text, confidence };
  }

  /**
   * Tesseract OCR (fallback)
   */
  private async tesseractOCR(imageBase64: string): Promise<{
    text: string;
    confidence: number;
  }> {
    // For now, return a placeholder
    // In production, you'd integrate node-tesseract-ocr or similar
    throw new Error("Tesseract not yet implemented - requires node-tesseract-ocr");
  }

  /**
   * Analyze image content (math, diagram, text, etc.)
   */
  async analyzeImageContent(imageBase64: string): Promise<{
    type: "math" | "diagram" | "text" | "handwriting" | "mixed";
    detectedElements: string[];
    confidence: number;
  }> {
    if (!GOOGLE_VISION_API_KEY) {
      return {
        type: "text",
        detectedElements: ["general text"],
        confidence: 0.5,
      };
    }

    try {
      const response = await axios.post(
        `${GOOGLE_VISION_URL}?key=${GOOGLE_VISION_API_KEY}`,
        {
          requests: [
            {
              image: {
                content: imageBase64.replace(/^data:image\/\w+;base64,/, ""),
              },
              features: [
                { type: "LABEL_DETECTION", maxResults: 10 },
                { type: "TEXT_DETECTION", maxResults: 1 },
              ],
            },
          ],
        }
      );

      const labels = response.data.responses[0]?.labelAnnotations || [];
      const hasText = response.data.responses[0]?.textAnnotations?.length > 0;

      const detectedElements = labels.map((l: any) => l.description);

      // Determine type based on labels
      let type: "math" | "diagram" | "text" | "handwriting" | "mixed" = "text";
      if (labels.some((l: any) => /math|equation|formula|calculation/i.test(l.description))) {
        type = "math";
      } else if (labels.some((l: any) => /diagram|chart|graph|figure/i.test(l.description))) {
        type = "diagram";
      } else if (labels.some((l: any) => /handwriting|handwritten/i.test(l.description))) {
        type = "handwriting";
      } else if (hasText && labels.length > 3) {
        type = "mixed";
      }

      return {
        type,
        detectedElements,
        confidence: labels[0]?.score || 0.7,
      };
    } catch (err) {
      console.error("⚠️ Image analysis failed:", err);
      return {
        type: "text",
        detectedElements: [],
        confidence: 0.5,
      };
    }
  }
}

export const ocrService = new OCRService();

