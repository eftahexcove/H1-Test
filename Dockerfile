FROM python:3.10-slim
# Install system dependencies for headless browsing
RUN apt-get update && apt-get install -y \
    wget gnupg curl \
    && rm -rf /var/lib/apt/lists/*
# Set up non-root user for Hugging Face compatibility
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH
WORKDIR $HOME/app
# Install dependencies
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && playwright install chromium
# Copy application and expose UI port
COPY --chown=user . .
EXPOSE 7860
CMD ["python", "main.py"]
