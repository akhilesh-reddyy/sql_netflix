**Netflix Movies & TV Shows Analysis**
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Overview**

This project provides a comprehensive analysis of Netflix’s content using SQL. The goal is to extract actionable insights and solve real-world business problems such as content distribution, genre popularity, country-wise production trends, and actor/director contributions.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
__Objectives__

Analyze the distribution of content types (Movies vs TV Shows).

Identify the most common ratings for each content type.

Examine content trends by release year, country, and duration.

Explore genres, directors, actors, and keyword-based content categorization.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Dataset**

Source: [Kaggle – Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

Key columns: show_id, type, title, director, casts, country, date_added, release_year, rating, duration, listed_in, description.

**Database Schema**
```
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id      VARCHAR(5) PRIMARY KEY,
    type         VARCHAR(10) NOT NULL,
    title        VARCHAR(250) NOT NULL,
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   DATE,
    release_year INT CHECK (release_year >= 1900),
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```




