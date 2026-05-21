-- ================================================================================
-- ECHOBREAKER — SUPABASE DATABASE SCHEMA
-- Run this entire file in the Supabase SQL Editor (Dashboard → SQL Editor → New query)
-- ================================================================================

-- ----------------------------------------
-- TABLE: users
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id       BIGSERIAL PRIMARY KEY,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT         NOT NULL,
    is_verified_author BOOLEAN  DEFAULT FALSE,
    is_active     BOOLEAN      DEFAULT TRUE,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    last_login    TIMESTAMP    NULL
);

-- ----------------------------------------
-- TABLE: author_applications
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS author_applications (
    application_id   BIGSERIAL PRIMARY KEY,
    user_id          BIGINT       NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    application_text TEXT,
    status           VARCHAR(20)  DEFAULT 'PENDING',   -- PENDING | APPROVED | REJECTED
    applied_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- TABLE: tags
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS tags (
    tag_id     BIGSERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- TABLE: articles
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS articles (
    article_id  BIGSERIAL PRIMARY KEY,
    author_id   BIGINT       NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title       VARCHAR(500) NOT NULL,
    content     TEXT         NOT NULL,
    view_count  BIGINT       DEFAULT 0,
    status      VARCHAR(20)  DEFAULT 'DRAFT',           -- DRAFT | PUBLISHED
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NULL,
    published_at TIMESTAMP   NULL
);

-- ----------------------------------------
-- TABLE: article_tags
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS article_tags (
    article_tag_id BIGSERIAL PRIMARY KEY,
    article_id     BIGINT NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE,
    tag_id         BIGINT NOT NULL REFERENCES tags(tag_id)         ON DELETE CASCADE,
    assigned_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(article_id, tag_id)
);

-- ----------------------------------------
-- TABLE: view_logs
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS view_logs (
    log_id                BIGSERIAL PRIMARY KEY,
    user_id               BIGINT NOT NULL REFERENCES users(user_id)    ON DELETE CASCADE,
    article_id            BIGINT NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE,
    view_duration_seconds INT    DEFAULT 0,
    viewed_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- TABLE: user_preferences
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS user_preferences (
    preference_id  BIGSERIAL PRIMARY KEY,
    user_id        BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    tag_id         BIGINT NOT NULL REFERENCES tags(tag_id)   ON DELETE CASCADE,
    affinity_score INT    DEFAULT 0,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, tag_id)
);

-- ----------------------------------------
-- TABLE: article_interactions
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS article_interactions (
    interaction_id   BIGSERIAL PRIMARY KEY,
    user_id          BIGINT      NOT NULL REFERENCES users(user_id)       ON DELETE CASCADE,
    article_id       BIGINT      NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE,
    interaction_type VARCHAR(20) NOT NULL,              -- LIKE | SAVE
    created_at       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, article_id, interaction_type)
);

-- ================================================================================
-- SEED DATA (optional — remove if you prefer a blank database)
-- ================================================================================

-- Seed tags
INSERT INTO tags (name) VALUES
    ('Technology'),
    ('Politics'),
    ('Science'),
    ('Culture'),
    ('Sports'),
    ('Environment'),
    ('Economy'),
    ('Health')
ON CONFLICT (name) DO NOTHING;

-- ================================================================================
-- END OF SCHEMA
-- ================================================================================
