FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# Hugging Face Spaces بيشغّل الحاوية بمستخدم غير root، فلازم مجلد الكتابة يكون مفتوح
RUN mkdir -p /app/history && chmod -R 777 /app
ENV PORT=7860
# worker واحد: الأعمال محفوظة في ذاكرة العملية، فلازم كلها في نفس الـ process
CMD gunicorn -w 1 --threads 8 -t 600 -b 0.0.0.0:${PORT} app:app
