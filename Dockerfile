FROM python:3.12-slim

WORKDIR /app

# Prevent Python from writing .pyc files and enable unbuffered console logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create instance directory for SQLite persistence
RUN mkdir -p /app/instance

# Copy application files
COPY . .

# Expose web port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
