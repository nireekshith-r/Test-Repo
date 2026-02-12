# Use the official Python slim image as the base image
FROM python:3.12-slim

# Set a non-root user for security
RUN useradd --create-home appuser
USER appuser

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements file first for layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 8000

# Define a health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8000/health || exit 1

# Set the default command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]