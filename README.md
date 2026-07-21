# ExpertListing App

ExpertListing is a high-performance, real-time real estate and general networking platform built with **Flutter**, **Golang**, and **PostgreSQL**.

This repository showcases an architecture optimized for speed, bandwidth conservation, and a seamless user experience reminiscent of top-tier social platforms.

## 🏗 System Design & Architectural Highlights

### 1. Optimistic UI & Race Condition Prevention
To make the app feel incredibly snappy, interactions like "Liking" a post update the UI instantly without waiting for network confirmation. 
- **The Challenge:** Since the app also listens to a real-time WebSocket channel for live updates, a local UI increment followed by a WebSocket broadcast could result in a "double-count" race condition.
- **The Solution:** The local state specifically flags the interacting user's ID. When the real-time ping arrives from the backend, the payload is checked. If the event originated from the current user, the WebSocket payload is intentionally ignored, preventing duplicate fires while still broadcasting the increment to all other connected clients.

### 2. Intelligent Real-Time Feed (Popup Aggregation)
When new posts are made by other users while the app is active, injecting them instantly into the top of the feed would forcefully push down the content the user is currently reading (UI jitter).
- **The Solution:** Real-time posts are silently caught by a background cache. A throttled listener aggregates these events and triggers a smooth floating **"New posts available"** popup. The user controls when their feed updates by tapping the popup, which smoothly animates the new posts into the UI.

### 3. Cursor-Based Pagination
For a highly dynamic feed where new items are inserted constantly, traditional `OFFSET/LIMIT` pagination causes data duplication or skipping. 
- **The Solution:** We implemented **Cursor-Based Pagination** using a `(timestamp, id)` tuple. This guarantees stable feed generation regardless of how many new items are injected into the database between scrolls.

### 4. Bandwidth-Optimized Cold Boots
When a user launches the app after being offline for days, pulling hundreds of missed posts would be a massive waste of cellular bandwidth and drastically increase load times.
- **The Solution:** On launch, the app instantly reads `SharedPreferences` to paint the screen with the last 50 cached posts (zero loading spinners). Concurrently, a background network call fetches *only* the **10 absolute newest posts** from the Golang backend. Older missed posts are simply fetched incrementally if the user decides to scroll down. 

### 5. Backend: Golang & PostgreSQL
- **High-Concurrency:** Powered by a lightweight **Golang (Gin)** backend utilizing `pgxpool` for optimal database connection pooling.
- **Eliminating Cartesian Explosion:** SQL queries for generating the feed bypass traditional `LEFT JOIN` aggregations (which cause catastrophic Cartesian product slowdowns). Instead, we utilize ultra-efficient **Correlated Subqueries** to pull aggregate counts (likes, comments), reducing query execution time significantly.
- **Background Simulator:** Built-in Go routines continuously generate realistic Real Estate listings and general networking posts at randomized intervals, simulating an active production environment for testing WebSocket handling.
- **Real-Time Layer:** Supabase acts purely as the PostgreSQL database host and WebSocket broadcasting layer, offloading real-time infrastructure while keeping custom business logic firmly in the Go backend.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK
- iOS Simulator or Android Emulator

### Running Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/expertlisting_app.git
   cd expertlisting_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   *(Note: The app is configured to route to the production Render backend automatically in Release mode, and a local Go server in Debug mode using `kDebugMode`).*
   ```bash
   # Run on emulator/device
   flutter run
   ```

### 📱 Download Release
If you'd like to test the live production app directly without building from source, download the latest Release APK here:
👉 **[Download Release APK](https://drive.google.com/file/d/1ZczZEjalw3qOPZddcLIh5V9Nqbg_G-l8/view?usp=sharing)**

---

## 📋 Assessment Details

### API Endpoints
The backend is a Golang/Gin service hosted on Render at `https://expertlisting-backend.onrender.com`.
- `GET /api/v1/posts` - Fetches a paginated feed of posts. Supports `type` (all, property, general, request), `limit`, and `cursor` (Timestamp|UUID).
- `POST /api/v1/posts/:id/like` - Toggles a like for the current user on a specific post.
- `GET /api/v1/posts/:id/comments` - Fetches comments for a specific post.
- `POST /api/v1/posts/:id/comments` - Adds a new comment to a post.
- `GET /api/v1/sidebar` - Fetches dynamic sidebar data (Trending Locations & Hot Requests).

### Database Schema
The database is PostgreSQL (hosted on Supabase) using the following core relational schema:
- **users**: `id (UUID)`, `name`, `avatar_url`, `created_at`
- **posts**: `id (UUID)`, `user_id (FK)`, `type (Enum)`, `content`, `image_url`, `location`, `price`, `bedrooms`, `bathrooms`, `created_at`
- **comments**: `id (UUID)`, `post_id (FK)`, `user_id (FK)`, `content`, `created_at`
- **likes**: `id (UUID)`, `post_id (FK)`, `user_id (FK)`, `created_at`, `UNIQUE(post_id, user_id)`

### Out of Scope & Assumptions
- **Authentication**: As per requirements, full auth/login was skipped. The backend uses a mocked "Current User" middleware that injects a static UUID into the context for all requests.
- **Top Communities**: The "Top Communities" section of the sidebar is mocked on the backend, while "Trending Locations" and "Hot Requests" are dynamically aggregated using real SQL queries.
- **Image Uploads**: Post creation was out of scope. Images are mocked via URLs in the background database seeder.
