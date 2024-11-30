# Base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies (e.g., PostgreSQL client libraries)
RUN apt-get update && apt-get install -y libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip to avoid warnings
RUN pip install --upgrade pip

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files to the container
COPY . /app/

# Expose port 8000 for the Django app
EXPOSE 8000

# Run the application with Gunicorn (optimized for production)
CMD ["gunicorn", "task_management.wsgi:application", "--bind", "0.0.0.0:8000"]
