# AZ Logistik Backend Technical Test

![Backend](https://img.shields.io/badge/Backend-Technical%20Test-blue)
![Node.js](https://img.shields.io/badge/Node.js-v20.x-green)
![PHP](https://img.shields.io/badge/PHP-v8.x-purple)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-v14.x-orange)

This repository contains the technical assessment for the backend developer position at AZ Logistik, focusing on SQL, PHP and Node.js implementation for a restaurant reservation and ordering system.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Assessment Questions](#assessment-questions)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Configuration](#environment-configuration)
- [Features](#features)
  - [SQL Queries](#sql-queries)
  - [PHP Reports](#php-reports)
  - [Node.js API](#nodejs-api)
- [API Documentation](#api-documentation)
- [Database Schema](#database-schema)
- [Testing](#testing)

## 🔍 Project Overview

This project implements a backend system for a restaurant management application with the following main components:

1. **SQL Queries**: SQL queries for analyzing restaurant data
2. **PHP Report Generator**: Dynamic customer reports with filtering capabilities
3. **Node.js API**: Table allocation and reservation system with conflict resolution

## 📝 Assessment Questions

This technical test is divided into three areas focusing on different backend skills:

### SQL Challenges (Questions 1-4)

1. **Top Customer Analysis**: Query to find top customers by spend over a specified period
2. **Reservation Analytics**: Query to analyze reservation patterns
3. **Menu Performance**: Query to determine popular menu items
4. **Query Optimization**: Rewriting queries for better performance

### PHP Implementation (Question 5)

5. **Dynamic Report Generator**: Create a PHP report showing top customers with additional metrics

### Node.js Implementation (Questions 6-7)

6. **Advanced Table Allocation System**: Develop a system to allocate tables based on party size and VIP status
7. **Reservation Management**: Implement validation and conflict resolution for table reservations

## 🛠️ Tech Stack

This project leverages the following technologies:

- **Database**: PostgreSQL
- **Backend**:
  - Node.js with Express
  - PHP
- **ORM**: Raw SQL queries ( no ORM used )
- **Testing**: Manual testing
- **Documentation**: Swagger / OpenAPI ( planned )

## 📁 Project Structure

The project is organized into three main directories:

```
azlogistik-be-technical-test/
├── node/                   # Node.js API implementation
│   ├── api_doc/            # API documentation
│   ├── config/             # Configuration files and database setup
│   │   └── migrations/     # SQL migration files
│   ├── helpers/            # Helper functions and utilities
│   ├── middleware/         # Express middleware
│   ├── routes/             # API route definitions
│   ├── services/           # Business logic services
│   ├── index.js            # API entry point
│   └── migrate.js          # Database migration script
│
├── php/                    # PHP implementation
│   ├── report/             # Report generation
│   └── utils/              # PHP utilities
│
└── sql/                    # SQL queries and optimizations
```

### Node.js Architecture

The Node.js application follows a layered architecture:

```
┌─────────────┐
│  API Routes │
├─────────────┤
│ Middleware  │
├─────────────┤
│  Services   │
├─────────────┤
│  Helpers    │
├─────────────┤
│   Config    │
└─────────────┘
```

- **Routes**: Define API endpoints and HTTP methods
- **Middleware**: Handle authentication, validation, and common concerns
- **Services**: Implement core business logic
- **Helpers**: Provide utility functions
- **Config**: Store configuration data and database setup

## 🚀 Getting Started

### Prerequisites

- Node.js v20.x or higher
- PHP v8.0 or higher
- PostgreSQL v14.x
- Git

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/aldoignatachandra/azlogistik-backend-technical-test.git
   cd azlogistik-be-technical-test
   ```

2. Set up the Node.js application:

   ```bash
   cd node
   npm install / yarn install
   ```

3. Create and populate the database:
   ```bash
   cd node
   node migrate.js / yarn migrate
   ```
   This script will:
   - Check if the target database exists and create it if needed
   - Run all migration scripts in order
   - Seed the database with initial data

### Environment Configuration

Create `.env` files for both PHP and Node.js applications:

#### Node.js `.env` file

```
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
PORT=3000
```

#### PHP `.env` file

```
PG_HOST=localhost
PG_PORT=5432
PG_DB=your_database_name
PG_USER=your_database_user
PG_PASS=your_database_password
```

## ✨ Features

### SQL Queries

The project includes several SQL queries for data analysis:

1. **Top Customers by Spending** (`query1.sql`): Identifies the highest spending customers in the past 60 days
2. **Reservation Statistics** (`query2.sql`): Analysis of reservation patterns
3. **Menu Performance** (`query3.sql`): Tracks popular menu items
4. **Query Optimization** (`query4_optimization.sql`): Performance-optimized queries

### PHP Reports

- **Top Customers Report**: Dynamically generated report based on date range
  - Endpoint: `GET /report/top-customers.php?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD`
  - Features:
    - Customer ranking by spending
    - Visit count tracking
    - Favorite menu identification
    - Average spending per visit

### Node.js API

The system implements a sophisticated table allocation and reservation system:

1. **Advanced Table Allocation System**:

   - Intelligent table assignment based on party size
   - VIP customer preferential allocation (based on spending history)
   - Conflict detection and resolution

2. **Reservation System**:
   - Overlap checking to prevent double-booking
   - Validation and error handling
   - Status tracking (pending, confirmed, etc.)

## 📘 API Documentation

### Endpoints

#### Table Allocation and Reservation

```
POST /api/reservation/allocate-table
```

Request body:

```json
{
  "user_id": 1,
  "party_size": 4,
  "requested_date": "2023-05-20",
  "requested_time": "18:30",
  "duration_minutes": 120
}
```

Response:

```json
{
  "reservation": {
    "id": 123,
    "user_id": 1,
    "table_id": 5,
    "start_time": "2023-05-20 18:30:00",
    "end_time": "2023-05-20 20:30:00",
    "status": "pending"
  }
}
```

#### Reservation Availability Check

```
POST /api/reservation/check
```

Request body:

```json
{
  "table_id": 5,
  "start_time": "2023-05-20 18:30:00",
  "end_time": "2023-05-20 20:30:00"
}
```

Response:

```json
{
  "status": "success"
}
```

## 📊 Database Schema

The database includes the following key tables:

- **users**: Customer information and roles
- **tables**: Restaurant tables with capacity information
- **reservations**: Table booking records with start/end times
- **menus**: Available food and drinks with pricing
- **orders**: Customer orders linked to specific reservations

Each table includes:

- Primary keys
- Foreign key relationships
- Indexes for query optimization
- Timestamp fields with automatic update triggers

## 🧪 Testing

To test the API endpoints:

1. Start the Node.js server:

   ```bash
   cd node
   npm run dev / yarn dev
   ```

2. Test the PHP reports:
   ```bash
   cd php
   php -S localhost:8000 -t .
   ```
   Then navigate to: http://localhost:8000/report/top-customers.php?start_date=2023-01-01&end_date=2023-12-31

## 👨‍💻 Author

Created with 💻 by Ignata

- 📂 GitHub: [Aldo Ignata Chandra](https://github.com/aldoignatachandra)
- 💼 LinkedIn: [Aldo Ignata Chandra](https://linkedin.com/in/aldoignatachandra)
