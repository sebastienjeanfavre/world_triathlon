# World Triathlon Data Analytics Platform

A Snowflake-based data warehouse for comprehensive triathlon race analytics, athlete performance tracking, and competitive insights across World Triathlon events.

## Overview

This project implements a dimensional data model to analyze triathlon race results, athlete performance metrics, and competitive rankings. The platform enables deep analysis of race dynamics, performance trends, and comparative athlete assessments across different competition categories.

## Architecture

### Data Flow
```
Raw Data → Staging Layer → Datamart Layer → Analytics
```

- **Staging**: Raw data ingestion and initial processing
- **Datamart**: Dimensional model with facts and dimensions
- **Analytics**: Business intelligence queries and reports

### Database Schema

**Dimensional Model:**
- `dim_athlete` - Athlete demographics and categories
- `dim_event` - Competition events and specifications
- `dim_program` - Race programs and categories
- `fct_results` - Race results with split times and rankings
- `fct_ranking` - World Triathlon official rankings

## Project Structure

```
world_triathlon/
├── src/                    # Core database objects
│   ├── ddl/               # Data Definition Language
│   │   ├── datamart/      # Final analytical tables
│   │   └── staging/       # Raw data tables
│   ├── dml/               # Data Manipulation Language
│   │   ├── datamart/      # Data loading scripts
│   │   └── staging/       # Staging data processes
│   └── tests/             # Test scripts and sample data
├── analysis/              # Ad-hoc analytical queries
├── init/                  # Database initialization
├── git/                   # Git integration utilities
└── logs/                  # Pipeline execution logs
```

## Key Analytics Capabilities

### Performance Analysis
- **Split Time Analysis**: Swim, bike, run segment performance
- **Pace Calculations**: Running pace analysis by distance category
- **Relative Performance**: Position tracking across race segments
- **Performance Trends**: Historical athlete improvement tracking

### Competitive Intelligence
- **Ranking Analysis**: World ranking categorization and bucketing
- **Race Dynamics**: Analysis of position changes during races
- **Category Performance**: Elite, U23, and age-group comparisons
- **Course Analysis**: Performance variations by venue and distance

### Sample Queries
```sql
-- Elite women's running pace analysis
-- See: analysis/run_pace_start.sql

-- Performance ranking buckets
-- See: analysis/buckets.sql

-- Individual athlete performance tracking
-- See: analysis/athlete_analysis.sql
```

## Deployment

### Automated Pipeline
The platform uses Snowflake's native Git integration for automated deployments:

```sql
-- Scheduled staging refresh (Tuesdays 1 AM UTC)
CREATE TASK task_refresh_staging
SCHEDULE = 'USING CRON 0 1 * * 2 UTC'
AS CALL staging.sp_refresh_staging();

-- Datamart refresh with Git integration
CALL datamart.sp_refresh_datamart();
```

### Manual Deployment
1. **Initialize Database**: Run scripts in `init/`
2. **Create Staging Layer**: Execute `src/ddl/staging/`
3. **Create Datamart Layer**: Execute `src/ddl/datamart/`
4. **Load Data**: Run DML scripts in `src/dml/`
5. **Schedule Tasks**: Deploy tasks

## Data Sources

The platform processes World Triathlon official data including:
- Race results and timing data
- Athlete registration and demographics
- Event specifications and courses
- Official world ranking calculations

## Key Features

- **Real-time Analysis**: Live race result processing
- **Historical Tracking**: Multi-year performance comparisons
- **Segment Analysis**: Detailed swim/bike/run breakdowns
- **Ranking Integration**: Official World Triathlon rankings
- **Performance Metrics**: Pace, relative position, and trend analysis

## Usage Examples

### Athlete Performance Analysis
```sql
-- Track athlete improvement over time
SELECT athlete_fullname, prog_date, finish_position,
       split1_rank/nb_finishers AS swim_percentile,
       split5_rank/nb_finishers AS run_percentile
FROM fct_results r
JOIN dim_athlete a ON a.athlete_id = r.athlete_id
WHERE athlete_fullname = 'Nicola Spirig'
ORDER BY prog_date;
```

### Race Pace Analysis
```sql
-- Running pace analysis by category
SELECT prog_name,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY run_pace_min_km) AS median_pace
FROM analysis.run_pace_calculations
GROUP BY prog_name;
```

## Contributing

1. Follow dimensional modeling conventions
2. Use consistent naming: `dim_` for dimensions, `fct_` for facts
3. Include data lineage documentation
4. Test DDL changes in staging environment first

## Technology Stack

- **Database**: Snowflake Cloud Data Platform
- **Version Control**: Git with Snowflake Git integration
- **Orchestration**: Snowflake Tasks and Dynamic Tables
- **Analytics**: SQL-based dimensional modeling

---

For questions about World Triathlon data or analytics requirements, refer to the analysis queries in the `analysis/` directory for usage examples and patterns.