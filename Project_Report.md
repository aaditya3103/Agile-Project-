# Mini-Project Report: End-to-End DevOps Pipeline

**Project Title:** Automated End-to-End DevOps Pipeline for a To-Do Web Application  
**Application Name:** TaskPilot  
**GitHub Repository:** https://github.com/aaditya3103/todo-devops  

---

## 1. Introduction
Modern software engineering requires rapid, reliable, and continuous delivery of applications. This project implements an automated, end-to-end DevOps pipeline for a lightweight, web-based To-Do application (TaskPilot). The pipeline bridges software development, automated testing, containerization, deployment, and performance monitoring.

---

## 2. Problem Statement
Traditional software deployment practices involve manual testing, environment discrepancies ("it works on my machine"), slow release cycles, and a lack of real-time application observability. This project resolves these issues by implementing a fully automated DevOps pipeline.

---

## 3. Objectives
1. Design and develop a functional Python Flask To-Do application with RESTful APIs.
2. Establish version control and collaboration using Git and GitHub.
3. Automate application testing using PyTest.
4. Containerize the application using Docker to ensure portability across environments.
5. Create a declarative CI/CD pipeline definition using Jenkinsfile.
6. Enable application and infrastructure monitoring with Prometheus metrics and alerting rules.

---

## 4. Proposed System
The proposed system follows standard DevOps methodology:
- **Developer** writes and pushes code to **GitHub**.
- **Continuous Integration** executes automated tests on every commit.
- **Docker** builds a portable container image.
- **Deployment** runs the container exposing standard HTTP ports.
- **Prometheus** monitors application health and performance via a dedicated `/metrics` endpoint.

---

## 5. Technology Stack
- **Web Framework:** Python 3.12, Flask 3.0
- **Database:** SQLite with Flask-SQLAlchemy
- **Version Control:** Git, GitHub
- **Testing Framework:** PyTest
- **Containerization:** Docker
- **Continuous Integration / Continuous Deployment:** Jenkins (`Jenkinsfile`)
- **Monitoring & Metrics:** Prometheus, `prometheus-client`
- **Frontend:** HTML5, CSS3, JavaScript

---

## 6. System Architecture

```text
[Developer] 
    │
    ▼ (git push)
[GitHub Repository]
    │
    ▼ (Webhook / Polling)
[Jenkins CI/CD Pipeline]
    ├── Stage 1: Checkout
    ├── Stage 2: Install Dependencies
    ├── Stage 3: Automated Testing (PyTest)
    ├── Stage 4: Docker Build
    └── Stage 5: Deploy (Container)
    │
    ▼
[Running Container : Port 5000]
    ▲
    │ (Scrapes /metrics)
[Prometheus Monitoring : Port 9090]
    │
    ▼
[Alerting Rules]
```

---

## 7. Application Development
The core application is a Task Management application providing full CRUD capabilities:
- **`GET /`**: Responsive web UI dashboard.
- **`GET /health`**: Health check probe returning service uptime status.
- **`GET /metrics`**: Prometheus exporter exposing request counters and duration.
- **`GET /api/tasks`**: Retrieve all tasks (with status filtering).
- **`POST /api/tasks`**: Create new task.
- **`PUT /api/tasks/<id>`**: Update existing task.
- **`PATCH /api/tasks/<id>/toggle`**: Toggle task completion status.
- **`DELETE /api/tasks/<id>`**: Delete task.

---

## 8. Git / GitHub Implementation
- Repository initialized with branch `main`.
- Remote repository hosted at `https://github.com/aaditya3103/todo-devops`.
- Files committed: `app.py`, `requirements.txt`, `test_app.py`, `Dockerfile`, `Jenkinsfile`, `prometheus.yml`, `README.md`, `templates/`, `static/`.

---

## 9. Automated Testing
Automated testing is configured using **PyTest**.
- **Scope:** 13 test cases covering UI response, health endpoints, metrics endpoints, CRUD operations, and error handling (400 Bad Request, 404 Not Found).
- **Execution Command:** `run_tests.bat` (or `py -3 -m pytest -v` / `pytest -v`)
- **Result:** `13 passed in 1.11s` (100% pass rate).

---

## 10. Jenkins CI/CD Pipeline
A declarative `Jenkinsfile` automates the software delivery pipeline:
- **Checkout:** Pulls the latest source code from GitHub.
- **Install Dependencies:** Installs packages specified in `requirements.txt`.
- **Test:** Runs PyTest suite; halts pipeline if tests fail.
- **Docker Build:** Builds container image `todo-app:latest`.
- **Deploy:** Runs the Docker container on port 5000.

---

## 11. Docker Implementation
The application is containerized using a multi-stage, lightweight `Dockerfile`:
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
- **Build Command:** `docker build -t todo-app .`
- **Run Command:** `docker run -d -p 5000:5000 --name my-todo-app todo-app`

---

## 12. Deployment
The container runs in isolated runtime environments, mapping container port `5000` to the host. Health is verified via `http://localhost:5000/health`.

---

## 13. Prometheus Monitoring
Prometheus is configured to scrape the application's `/metrics` endpoint every 5 seconds.
- **Target Status:** `todo-app (1/1 up)` - State: `UP`
- **Monitored Metrics:**
  - `up`: Application uptime status.
  - `http_requests_total`: Total count of HTTP requests by status code.
  - `http_request_duration_seconds`: Request latency.

---

## 14. Grafana Dashboard
Metrics gathered by Prometheus can be visualized via Grafana dashboards showing:
- Application Availability Gauge (100% UP).
- Request throughput per second.
- Error rates (4xx, 5xx responses).

---

## 15. Alerting
Prometheus alert rules detect abnormal conditions:
```yaml
groups:
  - name: application_alerts
    rules:
      - alert: ApplicationDown
        expr: up{job="todo-app"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "To-Do Application is down!"
```

---

## 16. Results
- End-to-end automated pipeline successfully built and verified.
- Seamless containerization with consistent runtime performance.
- Automated tests safeguard against regression before build and deployment.
- Real-time observability achieved with Prometheus.

---

## 17. Challenges
1. Setting up cross-container networking between the app and Prometheus (resolved by creating a custom Docker network `devops-net`).
2. Ensuring zero-privilege execution without heavy local installations (resolved using cloud development sandboxes).
3. Windows environment portability issues where `python` and `pip` were omitted from the system PATH variable, leaving only the Windows Python launcher (`py -3`) registered. When double-clicking `.bat` files, Windows failed to resolve the commands and closed prematurely. Resolved by implementing an automated interpreter discovery cascade in `run_app.bat` and `run_tests.bat` (supporting `.venv`, `py -3`, `python`, `py`, and standard paths) and invoking modules through `<interpreter> -m pip` and `<interpreter> -m pytest` with interactive pause guards.

---

## 18. Future Scope
- Kubernetes orchestration for autoscaling and self-healing.
- Integration of SonarQube for static code quality analysis.
- Deployment to cloud container services (AWS ECS / GCP Cloud Run).

---

## 19. Conclusion
The mini-project successfully demonstrates an end-to-end DevOps pipeline for a Python Flask application. All stages—source control, automated testing, containerization, continuous delivery, and monitoring—were successfully implemented and verified.

---

## 20. References
- Flask Documentation: https://flask.palletsprojects.com/
- Docker Documentation: https://docs.docker.com/
- Prometheus Monitoring: https://prometheus.io/docs/
- PyTest Testing Framework: https://docs.pytest.org/
