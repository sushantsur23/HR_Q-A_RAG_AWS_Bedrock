# HR_Q-A_RAG_AWS_Bedrock







### 🔥 1️⃣ Multi-Stage Dockerfile (Python + Distroless)

Unlike Go, Python is not statically compiled.
So we:
- Stage 1 → Build dependencies
- Stage 2 → Copy minimal runtime
- Final stage → Distroless Python runtime

### 🔐 Distroless Security Advantage

Distroless removes:
- Bash
- apt
- curl
- package managers

So attackers can’t exec into container easily.

### 🧪 Build the Image
```bash
docker build -t my-python-app .
```

### 🚀 Run the Container
```bash
docker run -p 8000:8000 my-python-app
```

### 🌐 2️⃣ Create Custom Bridge Network

By default Docker uses bridge.

You want a custom one.
```bash
docker network create \
  --driver bridge \
  my_custom_network
```

Verify:
```bash
docker network ls
```

### ✅ Run Container in Custom Network
```bash
docker run -d \
  --name app-container \
  --network my_custom_network \
  -p 8000:8000 \
  my-python-app
```

### 🧠 Why Custom Network?

Custom bridge gives:
- Internal DNS resolution
- Container-to-container communication by name
- Better isolation
- Controlled IP ranges

###  🏗 If Using FastAPI (Better Production)

Replace ENTRYPOINT with:
```bash
ENTRYPOINT ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### 🧠 Architect-Level Upgrade (Even Better)

Instead of copying full src/, use:
```bash
COPY . .
```
And define PYTHONPATH.

### 🔥 Even More Secure (Non-Root User)

Distroless runs as non-root by default.
If using non-distroless:
RUN useradd -m appuser
USER appuser

### 🎯 Final Architecture

Docker Image
   ├── Stage 1: Builder
   └── Stage 2: Distroless Runtime

Docker Network
   └── Custom Bridge
         ├── app-container
         ├── redis
         └── other services 