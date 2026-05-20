-- Fix: Add missing columns to the messages table
-- These columns are required by messages.php but were missing from the schema

ALTER TABLE `messages`
  ADD COLUMN `message_type` varchar(20) NOT NULL DEFAULT 'text' AFTER `content`,
  ADD COLUMN `file_url` text DEFAULT NULL AFTER `message_type`,
  ADD COLUMN `file_name` varchar(255) DEFAULT NULL AFTER `file_url`,
  ADD COLUMN `file_size` int(11) DEFAULT NULL AFTER `file_name`;
