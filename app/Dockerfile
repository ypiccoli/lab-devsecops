# --- Estágio de build: instala dependências ---
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# --- Estágio final: imagem mínima de execução ---
FROM python:3.12-slim

WORKDIR /app

# Copia apenas as dependências já instaladas, sem cache/ferramentas de build
COPY --from=builder /install /usr/local

# Usuário não-root criado antes da cópia da aplicação, para poder ser dono do arquivo
RUN useradd --create-home --shell /bin/bash appuser

COPY --chown=appuser:appuser app.py .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"] 
