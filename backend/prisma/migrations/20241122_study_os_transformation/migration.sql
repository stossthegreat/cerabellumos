-- Cerebellum Study OS Transformation Migration
-- Removes habit-related models, adds study-specific models

-- Drop old habit-related tables
DROP TABLE IF EXISTS "TodaySelection" CASCADE;
DROP TABLE IF EXISTS "Completion" CASCADE;
DROP TABLE IF EXISTS "HabitSnapshot" CASCADE;
DROP TABLE IF EXISTS "Alarm" CASCADE;
DROP TABLE IF EXISTS "AntiHabit" CASCADE;
DROP TABLE IF EXISTS "Habit" CASCADE;
DROP TABLE IF EXISTS "Task" CASCADE;

-- Drop FutureYou/LifeTask tables
DROP TABLE IF EXISTS "FutureYouJob" CASCADE;
DROP TABLE IF EXISTS "FutureYouBookEdition" CASCADE;
DROP TABLE IF EXISTS "FutureYouChapter" CASCADE;
DROP TABLE IF EXISTS "FutureYouPurposeProfile" CASCADE;
DROP TABLE IF EXISTS "LifeTaskBook" CASCADE;
DROP TABLE IF EXISTS "LifeTaskArtifact" CASCADE;
DROP TABLE IF EXISTS "LifeTaskChapter" CASCADE;

-- Update CoachMessageKind enum
ALTER TYPE "CoachMessageKind" ADD VALUE IF NOT EXISTS 'intel';
ALTER TYPE "CoachMessageKind" ADD VALUE IF NOT EXISTS 'exam_alert';
ALTER TYPE "CoachMessageKind" ADD VALUE IF NOT EXISTS 'mastery_alert';

-- Add study fields to User table
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "intelEnabled" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "studyReminders" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "grade" TEXT;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "studyGoals" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "learningStyle" TEXT;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "weeklyGoal" INTEGER NOT NULL DEFAULT 600;

-- Rename briefsEnabled/debriefsEnabled (keep for backward compat or remove)
-- ALTER TABLE "User" DROP COLUMN IF EXISTS "briefsEnabled";
-- ALTER TABLE "User" DROP COLUMN IF EXISTS "debriefsEnabled";

-- Create Exam table
CREATE TABLE IF NOT EXISTS "Exam" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "topic" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "weight" INTEGER NOT NULL DEFAULT 100,
    "targetGrade" TEXT,
    "icon" TEXT NOT NULL DEFAULT '📚',
    "daysRemaining" INTEGER NOT NULL DEFAULT 0,
    "threatLevel" TEXT NOT NULL DEFAULT 'MEDIUM',
    "progress" INTEGER NOT NULL DEFAULT 0,
    "prediction" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Exam_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "Exam_userId_idx" ON "Exam"("userId");
CREATE INDEX IF NOT EXISTS "Exam_userId_date_idx" ON "Exam"("userId", "date");
CREATE INDEX IF NOT EXISTS "Exam_threatLevel_idx" ON "Exam"("threatLevel");

ALTER TABLE "Exam" ADD CONSTRAINT "Exam_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create StudySession table
CREATE TABLE IF NOT EXISTS "StudySession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "topic" TEXT,
    "minutes" INTEGER NOT NULL,
    "effectiveness" INTEGER,
    "notes" TEXT,
    "masteryDelta" DOUBLE PRECISION,
    "focusScore" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StudySession_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "StudySession_userId_idx" ON "StudySession"("userId");
CREATE INDEX IF NOT EXISTS "StudySession_userId_createdAt_idx" ON "StudySession"("userId", "createdAt");
CREATE INDEX IF NOT EXISTS "StudySession_subject_idx" ON "StudySession"("subject");

ALTER TABLE "StudySession" ADD CONSTRAINT "StudySession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create TopicMastery table
CREATE TABLE IF NOT EXISTS "TopicMastery" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "topic" TEXT NOT NULL,
    "score" INTEGER NOT NULL DEFAULT 0,
    "confidence" INTEGER NOT NULL DEFAULT 50,
    "lastStudied" TIMESTAMP(3),
    "totalMinutes" INTEGER NOT NULL DEFAULT 0,
    "sessionsCount" INTEGER NOT NULL DEFAULT 0,
    "peakTimes" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "struggles" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TopicMastery_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "TopicMastery_userId_subject_topic_key" ON "TopicMastery"("userId", "subject", "topic");
CREATE INDEX IF NOT EXISTS "TopicMastery_userId_idx" ON "TopicMastery"("userId");
CREATE INDEX IF NOT EXISTS "TopicMastery_userId_score_idx" ON "TopicMastery"("userId", "score");

ALTER TABLE "TopicMastery" ADD CONSTRAINT "TopicMastery_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create Project table
CREATE TABLE IF NOT EXISTS "Project" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "emoji" TEXT NOT NULL DEFAULT '📚',
    "description" TEXT,
    "pinned" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastActive" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "Project_userId_idx" ON "Project"("userId");
CREATE INDEX IF NOT EXISTS "Project_userId_lastActive_idx" ON "Project"("userId", "lastActive");

ALTER TABLE "Project" ADD CONSTRAINT "Project_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create Message table
CREATE TABLE IF NOT EXISTS "Message" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "Message_projectId_idx" ON "Message"("projectId");
CREATE INDEX IF NOT EXISTS "Message_projectId_createdAt_idx" ON "Message"("projectId", "createdAt");

ALTER TABLE "Message" ADD CONSTRAINT "Message_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create ScannedProblem table
CREATE TABLE IF NOT EXISTS "ScannedProblem" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT,
    "topic" TEXT,
    "imageUrl" TEXT,
    "ocrText" TEXT NOT NULL,
    "solution" TEXT NOT NULL,
    "explanation" TEXT NOT NULL,
    "saved" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScannedProblem_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "ScannedProblem_userId_idx" ON "ScannedProblem"("userId");
CREATE INDEX IF NOT EXISTS "ScannedProblem_userId_createdAt_idx" ON "ScannedProblem"("userId", "createdAt");

ALTER TABLE "ScannedProblem" ADD CONSTRAINT "ScannedProblem_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create VideoSummary table
CREATE TABLE IF NOT EXISTS "VideoSummary" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT,
    "subject" TEXT,
    "topic" TEXT,
    "transcript" TEXT,
    "summary" TEXT NOT NULL,
    "keyPoints" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "saved" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VideoSummary_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "VideoSummary_userId_idx" ON "VideoSummary"("userId");
CREATE INDEX IF NOT EXISTS "VideoSummary_userId_createdAt_idx" ON "VideoSummary"("userId", "createdAt");

ALTER TABLE "VideoSummary" ADD CONSTRAINT "VideoSummary_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create StudyTarget table
CREATE TABLE IF NOT EXISTS "StudyTarget" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "emoji" TEXT NOT NULL DEFAULT '🎯',
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StudyTarget_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "StudyTarget_userId_idx" ON "StudyTarget"("userId");
CREATE INDEX IF NOT EXISTS "StudyTarget_userId_completed_idx" ON "StudyTarget"("userId", "completed");

ALTER TABLE "StudyTarget" ADD CONSTRAINT "StudyTarget_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Add index on CoachMessage for better querying
CREATE INDEX IF NOT EXISTS "CoachMessage_userId_kind_idx" ON "CoachMessage"("userId", "kind");
CREATE INDEX IF NOT EXISTS "CoachMessage_userId_createdAt_idx" ON "CoachMessage"("userId", "createdAt");

