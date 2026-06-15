# IPL Cricket Stats Analysis — SQL & Power BI

An end-to-end data analytics project analysing 15 seasons of Indian Premier League (IPL) cricket data using PostgreSQL and Power BI. The project covers data modelling, cleaning, exploratory analysis, advanced SQL, and interactive dashboards.

---

## Project Overview

| Attribute | Detail |
|---|---|
| Dataset | IPL Complete Dataset 2008–2022 (Kaggle) |
| Rows analysed | ~179,000 deliveries across 950 matches |
| Tools used | PostgreSQL, pgAdmin, Power BI Desktop |
| SQL concepts | JOINs, CTEs, Window functions, Subqueries |
| Status | Complete |

---

## folder structure

```
ipl-sql-analysis/
├── raw/
│   ├── matches.csv
│   └── deliveries.csv
├── sql/
│   ├── 01_schema.sql          ← table creation and imports
│   ├── 02_cleaning.sql        ← mapping tables and data fixes
│   ├── 03_views.sql           ← clean views for Power BI
│   └── 04_analysis.sql        ← all analytical queries
├── dashboard/
│   └── ipl_dashboard.pbix     ← Power BI dashboard file
└── README.md
```

---

## Data Model

Two core tables imported from raw CSVs:

```
matches (950 rows)
└── id, season_year, venue, team1, team2,
    toss_winner, toss_decision, winning_team,
    player_of_match, won_by, margin

deliveries (179,000 rows)
└── id (FK → matches), innings, overs, ball_number,
    batter, bowler, batsman_run, total_run,
    extra_type, is_wicket_delivery, kind
```

Two mapping tables created for data standardisation:

```
venue_mapping   ← standardises 6 venue naming inconsistencies
team_mapping    ← handles franchise rebrands and replacements
```

---

## Data Quality Issues Found and Fixed

| Issue | Example | Fix |
|---|---|---|
| Venue naming inconsistencies | "Wankhede Stadium" vs "Wankhede Stadium, Mumbai" | venue_mapping lookup table |
| Franchise rebrands | Delhi Daredevils → Delhi Capitals (2019) | team_mapping with change_type column |
| Franchise replacements | Deccan Chargers → Sunrisers Hyderabad (2013) | team_mapping with from_season column |
| Spelling inconsistencies | "Rising Pune Supergiant" vs "Rising Pune Supergiants" | team_mapping spelling_fix entry |
| Season format inconsistency | "2007/08" vs "2011" | Added season_year INTEGER column |
| Zero-indexed overs | Overs stored as 0–19 not 1–20 | Adjusted all phase filters accordingly |

> Raw CSV files were never modified. All cleaning was applied through mapping tables and PostgreSQL views — preserving the original data at all times.

---

## Key Analytical Questions Answered

### 1. Toss Impact
> Does winning the toss actually help you win the match?

**Finding:** Toss winners won only 51.5% of matches — barely better than a coin flip. Winning the toss has minimal impact on match outcome across 15 IPL seasons.

---

### 2. Venue Analysis — Batting First vs Chasing
> Which venues favour batting first and which favour chasing?

| Venue | Total Matches | Bat First Win% | Chase Win% |
|---|---|---|---|
| MA Chidambaram Stadium | 48 | 61.2% | 38.8% |
| Sawai Mansingh Stadium | 47 | 31.9% | 68.1% |
| Wankhede Stadium | 104 | 46.2% | 53.8% |
| Brabourne Stadium | 27 | 51.9% | 48.1% |

**Finding:** Sawai Mansingh Stadium (Jaipur) strongly favours chasing at 68.1% — consistent with dew factor and spin-friendly conditions. MA Chidambaram (Chennai) strongly favours batting first at 61.2% — the Chepauk pitch historically gets slower as the match progresses making chasing harder.

---

### 3. Top Run Scorers Per Season (Window Functions)
> Who were the top 3 batsmen by runs in each IPL season?

**Finding:** KL Rahul was the most consistent top performer, finishing in the top 3 run scorers across 5 different IPL seasons. Virat Kohli's 2016 season produced 973 runs — the highest individual season total in IPL history — a record that still stands.

**SQL concepts used:** `DENSE_RANK()`, `PARTITION BY season_year`, multi-CTE structure

---

### 4. Season-on-Season Improvement (LAG Function)
> Which batsmen improved their run tally the most from one season to the next?

**Finding:** Jos Buttler recorded the single biggest season-to-season improvement in the dataset. Kohli's 2016 record season was followed by a significant decline — a textbook example of regression to the mean where extreme performances tend to be followed by more average ones.

**SQL concepts used:** `LAG()`, `PARTITION BY batter`, `ORDER BY season_year ASC`

---

### 5. Bowler Phase Comparison — Powerplay vs Death Overs
> Who are the most economical bowlers in powerplay overs (0–5) and death overs (15–19)?

| Bowler | PP Economy | PP Wickets | Death Economy | Death Wickets | Overall Economy |
|---|---|---|---|---|---|
| SP Narine | 6.75 | 24 | 8.23 | 55 | 7.49 |
| SL Malinga | 6.70 | 37 | 8.52 | 90 | 7.61 |
| R Ashwin | 6.83 | 46 | 8.70 | 16 | 7.77 |
| B Kumar | 6.29 | 55 | 9.83 | 77 | 8.06 |

**Finding:** Sunil Narine is the most complete bowler across both phases with an overall economy of 7.49. Lasith Malinga's 90 death wickets at 8.52 economy makes him the most impactful death bowler in IPL history. Bhuvneshwar Kumar's powerplay economy of 6.29 is the best all time but his death economy of 9.83 reveals clear phase specialisation.

**SQL concepts used:** Phase filtering with `overs BETWEEN`, `NULLIF` for division safety, wide exclusion from ball counts

---

### 6. Head-to-Head Franchise Records
> Which franchise dominates which opponent most consistently?

**Finding:** MI vs CSK is IPL's biggest rivalry with 34 meetings. Mumbai Indians are the most dominant franchise overall. Punjab Kings show the highest vulnerability, being dominated most consistently across their head-to-head record.

**SQL concepts used:** `LEAST()` and `GREATEST()` for consistent team pair ordering, triple team_mapping JOIN for full name standardisation

---

### 7. All Rounder Index
> Who are IPL's most complete all rounders combining batting and bowling?

| Player | Total Runs | Strike Rate | Total Wickets | Economy | All Rounder Score |
|---|---|---|---|---|---|
| SR Watson | 3880 | 140.27 | 92 | 8.30 | 8 |
| RA Jadeja | 2502 | 131.06 | 132 | 7.80 | 10 |
| KA Pollard | 3437 | 152.08 | 69 | 8.97 | 11 |
| DJ Bravo | 1560 | 133.45 | 183 | 8.69 | 11 |
| AD Russell | 2039 | 181.73 | 89 | 9.44 | 13 |

**Methodology:** Players ranked by strike rate (batting quality), economy rate (bowling quality), and an impact score combining runs + wickets × 20 to normalise scales. Rankings summed — lower score = better all rounder. Minimum thresholds: 1500 runs, 1000 balls faced, 50 wickets, 600 balls bowled.

**Finding:** Shane Watson is IPL's most complete all rounder by this index. DJ Bravo leads all rounders in wickets with 183 dismissals. Jadeja's economy of 7.80 makes him the hardest to score off among genuine all rounders.

---

## SQL Concepts Demonstrated

| Concept | Where Used |
|---|---|
| CTEs (WITH clause) | All complex analytical queries |
| Window functions | RANK(), DENSE_RANK(), LAG() |
| PARTITION BY | Top performers per season, LAG improvement |
| Multi-table JOINs | Deliveries enriched with match context |
| CASE WHEN | Phase filtering, batting order logic, team standardisation |
| COALESCE | Null handling, mapping table fallbacks |
| LEAST / GREATEST | Consistent head-to-head team pair ordering |
| NULLIF | Division by zero prevention in rate calculations |
| Aggregations | SUM, COUNT, ROUND with GROUP BY and HAVING |
| Views | Clean data layer between raw tables and Power BI |
| Indexes | Performance optimisation on high-frequency filter columns |

---

## Power BI Dashboard

The dashboard connects directly to PostgreSQL via live connection and includes five pages:

- **Top run scorers** — career runs bar chart with Top N filter
- **Season trends** — total runs scored per season line chart
- **Venue analysis** — batting first vs chasing win % clustered bar
- **Head to head** — franchise rivalry matrix with dominance %
- **All rounder index** — scatter plot of strike rate vs economy sized by impact

---

## How to Reproduce This Project

1. Download the IPL dataset from Kaggle — search "IPL Complete Dataset 2008–2022"
2. Install PostgreSQL and pgAdmin
3. Run `sql/01_schema.sql` to create tables and import CSVs
4. Run `sql/02_cleaning.sql` to create mapping tables and season_year column
5. Run `sql/03_views.sql` to create clean views
6. Run `sql/04_analysis.sql` to reproduce all analytical queries
7. Open `dashboard/ipl_dashboard.pbix` in Power BI Desktop and update the PostgreSQL connection string

---

## What I Learned

- Designing a relational schema from raw CSV files
- Identifying and resolving real-world data quality issues without modifying raw data
- Writing multi-CTE queries combining window functions, aggregations, and joins
- Building a clean data layer using views to separate raw data from analysis
- Connecting PostgreSQL to Power BI and building an interactive dashboard
- Thinking analytically — questioning results, verifying with sanity checks, and extracting business insights from numbers

---

## Dataset Source

Kaggle — IPL Complete Dataset 2008–2022  
License: Public Domain / CC0
