import { FastifyRequest, FastifyReply } from 'fastify';
import { verifyFirebaseToken } from '../utils/firebase-admin';
import { prisma } from '../utils/db';

// Extend Fastify request type to include user
declare module 'fastify' {
  interface FastifyRequest {
    user?: {
      id: string;
      email: string | null;
      name: string | null;
    };
  }
}

/**
 * Firebase Authentication Middleware
 * 
 * Verifies Firebase ID token from Authorization header
 * and attaches user info to request object.
 */
export async function authMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
): Promise<void> {
  try {
    // 🔧 DEV MODE: Accept x-user-id header for testing
    const testUserId = request.headers['x-user-id'] as string;
    if (testUserId) {
      request.user = {
        id: testUserId,
        email: `${testUserId}@test.com`,
        name: 'Test User',
      };
      
      // Ensure user exists in database
      await ensureUserExists(testUserId, `${testUserId}@test.com`);
      
      console.log(`🔧 DEV MODE: Using test user ${testUserId}`);
      
      // Also set userId for controllers expecting it
      (request as any).userId = testUserId;
      return;
    }
    
    // Extract token from Authorization header
    const authHeader = request.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      reply.code(401).send({
        error: 'Unauthorized',
        message: 'Missing or invalid Authorization header. Expected: Bearer <token> OR x-user-id header for dev',
      });
      return;
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token with Firebase
    const decodedToken = await verifyFirebaseToken(token);

    if (!decodedToken) {
      reply.code(401).send({
        error: 'Unauthorized',
        message: 'Invalid or expired Firebase token',
      });
      return;
    }

    // Attach user info to request
    request.user = {
      id: decodedToken.uid,
      email: decodedToken.email || null,
      name: decodedToken.name || null,
    };

    // Ensure user exists in database
    await ensureUserExists(request.user.id, request.user.email);

    // Also set userId for controllers expecting it
    (request as any).userId = request.user.id;

    // Log authenticated request
    console.log(`✅ Authenticated request from user: ${request.user.id} (${request.user.email})`);
    
  } catch (error) {
    console.error('❌ Auth middleware error:', error);
    reply.code(500).send({
      error: 'Internal Server Error',
      message: 'Authentication failed',
    });
  }
}

/**
 * Ensure user exists in database
 * Auto-creates user record if it doesn't exist
 */
async function ensureUserExists(userId: string, email: string | null): Promise<void> {
  try {
    // Check if user exists
    const existingUser = await prisma.user.findUnique({
      where: { id: userId },
    });

    // If user doesn't exist, create them
    if (!existingUser) {
      await prisma.user.create({
        data: {
          id: userId,
          email: email || undefined,
          createdAt: new Date(),
        },
      });
      console.log(`✅ Auto-created user in database: ${userId} (${email})`);
    }
  } catch (error) {
    console.error('⚠️ Error ensuring user exists:', error);
    // Don't throw - allow request to continue even if user creation fails
  }
}

/**
 * Optional Auth Middleware
 * 
 * Tries to verify token but doesn't fail if missing.
 * Useful for endpoints that work with or without auth.
 */
export async function optionalAuthMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
): Promise<void> {
  try {
    const authHeader = request.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const decodedToken = await verifyFirebaseToken(token);

      if (decodedToken) {
        request.user = {
          id: decodedToken.uid,
          email: decodedToken.email || null,
          name: decodedToken.name || null,
        };
        
        // Ensure user exists in database
        await ensureUserExists(request.user.id, request.user.email);
        
        console.log(`✅ Optional auth: user ${request.user.id} authenticated`);
      }
    }
    
    // Continue even if no token or invalid token
  } catch (error) {
    console.error('⚠️  Optional auth middleware error:', error);
    // Continue even on error
  }
}

/**
 * Helper to get user ID from request
 * Throws error if not authenticated
 */
export function getUserId(request: FastifyRequest): string {
  if (!request.user || !request.user.id) {
    throw new Error('User not authenticated');
  }
  return request.user.id;
}

/**
 * Helper to get user ID from request (returns null if not auth)
 */
export function getUserIdOrNull(request: FastifyRequest): string | null {
  return request.user?.id || null;
}
