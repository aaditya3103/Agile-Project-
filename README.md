# TaskPilot - DevOps To-Do Application

A lightweight, modern web-based To-Do management application designed as the core application for an **End-to-End DevOps Pipeline**. Built with Python, Flask, SQLite, and Prometheus metrics instrumentation, complete with automated unit and API testing.

---

## 🚀 Features

- **Interactive UI**: Clean, responsive dashboard to create, view, edit, filter, search, and delete tasks.
- **Task Management**:
  - Add tasks with title, description, priority levels (`Low`, `Medium`, `High`), and due dates.
  - Interactive status toggling (Pending ↔ Completed) with real-time stats counter.
  - Filter tasks by status (`All`, `Pending`, `Completed`) and instantaneous search.
- **RESTful API**: Full CRUD API endpoints adhering to standard HTTP methods (`GET`, `POST`, `PUT`, `DELETE`, `PATCH`).
- **DevOps Ready**:
  - `/health` endpoint for uptime monitoring and container orchestration health checks.
  - `/metrics` endpoint exporting Prometheus-compatible metrics (`http_requests_total`, `http_request_duration_seconds`, `todo_tasks_total`).
- **Automated Testing**: 100% test coverage for API routes, validations, and UI rendering using `pytest`.

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Backend** | Python 3.12, Flask 3.0 |
| **Database** | SQLite via Flask-SQLAlchemy |
| **Monitoring** | `prometheus-client` |
| **Testing** | `pytest` |
| **Frontend** | HTML5, CSS3, JavaScript (Vanilla fetch API) |

---

## 📂 Project Structure

```text
Agile Project/
├── app.py              # Main Flask application and REST API
├── requirements.txt    # Project dependencies
├── test_app.py         # PyTest automated test suite
├── .gitignore          # Git ignore file
├── README.md           # Documentation
├── templates/
│   └── index.html      # Frontend HTML template
└── static/
    ├── style.css       # Custom stylesheet
    └── app.js          # Interactive frontend logic
```

---

## ⚡ Getting Started (Local Setup)

### Option A: One-Click Launch (Windows - Recommended)
The project includes self-configuring batch scripts that automatically detect your Python environment (supporting both the Windows **`py -3`** launcher and standard **`python`**, even if `python` and `pip` were not added to your Windows environment `PATH`):

1. **Start the Application**:
   - Double-click **`run_app.bat`** (or run `.\run_app.bat` from terminal).
   - The script automatically discovers Python / the `py -3` launcher, verifies dependencies, and launches the server.
   - Open your browser at: **`http://localhost:5000`**

2. **Run Automated Tests**:
   - Double-click **`run_tests.bat`** (or run `.\run_tests.bat` from terminal).
   - Automatically detects Python, executes all 13 PyTest test cases, and pauses so you can review results.

---

### Option B: Manual Setup

#### 1. Create and Activate Virtual Environment
```bash
# Windows (Windows Python Launcher 'py -3')
py -3 -m venv .venv
.venv\Scripts\activate

# Windows (Standard python in PATH)
python -m venv .venv
.venv\Scripts\activate

# Linux / macOS
python3 -m venv .venv
source .venv/bin/activate
```

#### 2. Install Dependencies
```bash
# Windows (via py launcher)
py -3 -m pip install -r requirements.txt

# Windows (standard python) / Linux / macOS
pip install -r requirements.txt
```

#### 3. Run the Application
```bash
# Windows (via py launcher)
py -3 app.py

# Standard python
python app.py
```
Open your browser and navigate to: **`http://localhost:5000`**

---

## 🧪 Running Automated Tests

Run the automated PyTest suite to verify application logic:

```bash
# Windows (1-Click)
run_tests.bat

# Windows (via py launcher)
py -3 -m pytest -v

# Standard python / Linux
python -m pytest -v
```

All 13 test cases validate:
- Home page loading (`200 OK`)
- Health check status (`/health`)
- Prometheus metrics output (`/metrics`)
- Task creation (`POST /api/tasks`)
- Input validation (rejecting empty task titles with `400 Bad Request`)
- Task retrieval and single item lookups (`GET /api/tasks`, `GET /api/tasks/<id>`)
- 404 error handling for non-existent items
- Task modification (`PUT /api/tasks/<id>`)
- Task status toggling (`PATCH /api/tasks/<id>/toggle`)
- Task deletion (`DELETE /api/tasks/<id>`)
- Status filtering (`?status=pending` / `?status=completed`)

---

## 📡 REST API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Web user interface |
| `GET` | `/health` | Health check endpoint returning `{"status": "UP"}` |
| `GET` | `/metrics` | Prometheus metrics scrape target |
| `GET` | `/api/tasks` | List tasks (supports query parameter `?status=pending\|completed`) |
| `POST` | `/api/tasks` | Create a new task |
| `GET` | `/api/tasks/<id>` | Fetch specific task by ID |
| `PUT` | `/api/tasks/<id>` | Update an existing task |
| `PATCH` | `/api/tasks/<id>/toggle` | Toggle task completion status |
| `DELETE` | `/api/tasks/<id>` | Delete a task |

---

## 🐳 Docker Deployment

### 1. Build Docker Image
```bash
docker build -t taskpilot:latest .
```

### 2. Run Container with Persistent Data Volume
To ensure SQLite tasks survive container destruction and restarts, mount the `/app/instance` directory:

```bash
docker run -d -p 5000:5000 --name taskpilot -v taskpilot-data:/app/instance taskpilot:latest
```

The application is now accessible at: **`http://localhost:5000`**

### 3. Container Management
```bash
# View container logs
docker logs -f taskpilot

# Check container status
docker ps

# Stop and remove container
docker stop taskpilot
docker rm taskpilot
```

---

## 🧭 DevOps Pipeline Roadmap

- [x] **Stage 1 & 2: Plan & Develop** — Completed To-Do application with clean UI and REST API
- [x] **Stage 7: Automated Testing** — PyTest suite configured and verified
- [ ] **Stage 6: Git & GitHub** — Repository initialization and commits
- [x] **Stage 10: Dockerization** — Production-ready `Dockerfile`, `.dockerignore`, and container volume persistence
- [ ] **Stage 8 & 9: Jenkins CI/CD** — Jenkins pipeline setup (`Jenkinsfile`)
- [ ] **Stage 13 & 14: Prometheus & Grafana** — Metric collection, dashboard, and alerts
