// backend/src/controllers/stats.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";

export async function statsController(fastify: FastifyInstance) {
  /**
   * GET /stats/summary - Get comprehensive user stats
   */
  fastify.get("/stats/summary", async (req: any) => {
    const userId = req.userId;

    // Get all study sessions
    const sessions = await prisma.studySession.findMany({
      where: { userId },
      select: { minutes: true, createdAt: true },
    });

    // Calculate total study hours
    const totalMinutes = sessions.reduce((sum, s) => sum + (s.minutes || 0), 0);
    const totalStudyHours = Math.round(totalMinutes / 60);

    // Calculate streak
    const { currentStreak, peakStreak } = calculateStreaks(sessions);

    // Get mastery count
    const masteredTopics = await prisma.topicMastery.count({
      where: { userId, score: { gte: 75 } },
    });

    // Get weekly stats
    const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const weeklyMinutes = sessions
      .filter((s) => new Date(s.createdAt) >= weekAgo)
      .reduce((sum, s) => sum + (s.minutes || 0), 0);

    // Average session length
    const avgSessionLength = sessions.length > 0
      ? Math.round(totalMinutes / sessions.length)
      : 0;

    // Today's minutes
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayMinutes = sessions
      .filter((s) => new Date(s.createdAt) >= today)
      .reduce((sum, s) => sum + (s.minutes || 0), 0);

    return {
      totalStudyHours: `${totalStudyHours}h`,
      peakStreak: `${peakStreak} Days`,
      sessionsCompleted: sessions.length,
      conceptsMastered: masteredTopics,
      currentStreak: peakStreak,
      weeklyMinutes,
      avgSessionLength,
      todayMinutes,
    };
  });

  /**
   * GET /stats/detailed - Get detailed analytics
   */
  fastify.get("/stats/detailed", async (req: any) => {
    const userId = req.userId;

    const [sessions, exams, mastery, scans, videos] = await Promise.all([
      prisma.studySession.findMany({
        where: { userId },
        orderBy: { createdAt: "desc" },
        take: 30,
      }),
      prisma.exam.count({ where: { userId } }),
      prisma.topicMastery.findMany({ where: { userId } }),
      prisma.scannedProblem.count({ where: { userId } }),
      prisma.videoSummary.count({ where: { userId } }),
    ]);

    // Group sessions by subject
    const subjectBreakdown: Record<string, number> = {};
    sessions.forEach((s) => {
      const subject = s.subject || "General";
      subjectBreakdown[subject] = (subjectBreakdown[subject] || 0) + (s.minutes || 0);
    });

    // Mastery distribution
    const masteryDistribution = {
      mastered: mastery.filter((m) => m.score >= 75).length,
      learning: mastery.filter((m) => m.score >= 50 && m.score < 75).length,
      struggling: mastery.filter((m) => m.score < 50).length,
    };

    return {
      totalSessions: sessions.length,
      totalExams: exams,
      totalScans: scans,
      totalVideos: videos,
      subjectBreakdown,
      masteryDistribution,
      recentSessions: sessions.slice(0, 10),
    };
  });
}

function calculateStreaks(sessions: Array<{ createdAt: Date }>): {
  currentStreak: number;
  peakStreak: number;
} {
  if (sessions.length === 0) return { currentStreak: 0, peakStreak: 0 };

  // Sort by date descending
  const sorted = sessions
    .map((s) => new Date(s.createdAt))
    .sort((a, b) => b.getTime() - a.getTime());

  // Group by day
  const days = new Set<string>();
  sorted.forEach((date) => {
    const day = date.toISOString().split("T")[0];
    days.add(day);
  });

  const uniqueDays = Array.from(days).sort().reverse();

  // Calculate current streak
  let currentStreak = 0;
  const today = new Date().toISOString().split("T")[0];
  const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString().split("T")[0];

  if (uniqueDays[0] === today || uniqueDays[0] === yesterday) {
    currentStreak = 1;
    for (let i = 1; i < uniqueDays.length; i++) {
      const prevDay = new Date(uniqueDays[i - 1]);
      const currDay = new Date(uniqueDays[i]);
      const diffDays = Math.floor(
        (prevDay.getTime() - currDay.getTime()) / (24 * 60 * 60 * 1000)
      );
      if (diffDays === 1) {
        currentStreak++;
      } else {
        break;
      }
    }
  }

  // Calculate peak streak
  let peakStreak = 0;
  let tempStreak = 1;
  for (let i = 1; i < uniqueDays.length; i++) {
    const prevDay = new Date(uniqueDays[i - 1]);
    const currDay = new Date(uniqueDays[i]);
    const diffDays = Math.floor((prevDay.getTime() - currDay.getTime()) / (24 * 60 * 60 * 1000));
    if (diffDays === 1) {
      tempStreak++;
    } else {
      peakStreak = Math.max(peakStreak, tempStreak);
      tempStreak = 1;
    }
  }
  peakStreak = Math.max(peakStreak, tempStreak);

  return { currentStreak, peakStreak };
}

