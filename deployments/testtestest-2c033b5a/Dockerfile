# Use the official Python slim image as the base image
FROM python:3.12-slim

# Set a non-root user for security
RUN useradd --create-home appuser

# Set the working directory
WORKDIR /app

# Copy only the requirements file first for layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Change ownership of the application files to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Expose the application port
EXPOSE 8000

# Define the health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8000/health || exit 1

# Command to run the application
CMD ["python", "app.py"]