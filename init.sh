# 5. Create project structure
echo "📂 Setting up project structure..."

touch .env
echo "🚀 Initializing .env file Setup..."

# 1️⃣ Create .env if not exists
if [ ! -f ".env" ]; then
    echo "📄 Creating .env file..."
    cat <<EOL > .env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=ap-south-1
EOL
    echo "✅ .env created. Please update AWS credentials."
else
    echo "📄 .env already exists."
fi


mkdir -p src
touch src/__init__.py
touch src/main.py

mkdir -p architecture
# touch drafts/test.ipynb

# mkdir -p .github
# touch .github/deploy.yml

mkdir -p src/data_load
touch src/data_load/__init__.py
touch src/data_load/data_load.py

mkdir -p src/data_split
touch src/data_split/__init__.py
touch src/data_split/data_split.py

mkdir -p src/utils
touch src/utils/__init__.py
touch src/utils/utils.py

mkdir -p src/rag_backend
touch src/rag_backend/__init__.py
touch src/rag_backend/rag_backend.py


mkdir -p src/tests
touch src/tests/__init__.py
# touch src/tests/test_graph.py
# touch src/tests/test_graph.py

echo "📦 Initializing all __init__.py files under src..."

for dir in src/*/; do
    module_name=$(basename "$dir")

    # Skip if no matching .py file exists
    if [ -f "${dir}${module_name}.py" ]; then
        cat <<EOL > "${dir}__init__.py"
from src.${module_name} import *
EOL
        echo "✅ Updated ${dir}__init__.py"
    fi
done

echo "🎯 All modules initialized."

touch Dockerfile

# Write Dockerfile content
cat > Dockerfile << 'EOF'
FROM python:3.11-slim

# Set working directory to /src
WORKDIR /src

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Add the current directory to Python path
ENV PYTHONPATH=/src

# Expose port
EXPOSE 8000

# Run the srclication
CMD ["streamlit", "run", "src/mainsrc.py", "--server.port=8000", "--server.address=0.0.0.0"]
EOF

echo "Dockerfile created successfully"



# 2️⃣ Load environment variables from .env
if [ -f ".env" ]; then
    echo "🔐 Loading AWS credentials from .env..."
    export $(grep -v '^#' .env | xargs)
fi


# 3️⃣ Configure AWS CLI automatically
if command -v aws &> /dev/null; then
    echo "⚙️ Configuring AWS CLI..."

    aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set region "$AWS_DEFAULT_REGION"
    aws configure set output json

    echo "✅ AWS CLI configured."

    echo "🔎 Verifying AWS login..."
    aws sts get-caller-identity
else
    echo "❌ AWS CLI not installed. Please install AWS CLI first."
fi


# 4. Create requirements.txt if not exists & add libraries
if [ ! -f "requirements.txt" ]; then
    echo "📄 Creating requirements.txt..."
    cat <<EOL > requirements.txt
langchain
python-dotenv
Flask-SQLAlchemy
faiss-cpu
boto3
langchain-aws
streamlit
fastapi
langchain_community
pytest
transformers
pypdf
PyYAML
EOL
    echo "✅ requirements.txt created with default libraries."
else
    echo "📄 requirements.txt already exists, skipping creation."
fi

set -e  # Exit if any command fails

echo "🚀 Initializing Finance Health Report project with Conda..."
conda create --prefix ./venv python=3.12 -y

# 1. Create Conda environment in local folder (./venv)
if [ ! -d "venv" ]; then
    echo "📦 Creating Conda environment in ./venv ..."
    conda create --prefix ./venv python=3.12 -y
else
    echo "✅ Conda environment already exists in ./venv"
fi

echo "🚀 Creating setup.py file with the Project information as needed..."
touch setup.py

# Create setup.py
echo "📝 Creating setup.py..."
cat > setup.py <<EOL
from setuptools import setup, find_packages

setup(
    name="Routing_Agentic_AI_Workflow",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "streamlit",
        "langchain",
        "langchain-groq",
        "langgraph",
        "python-dotenv",
        "langchain",
        "langchain_huggingface",
        "langchain-tavily",
        "reportlab",
        "google-api-python-client",
        "google_auth_oauthlib",
        "langchain-openai",
        "langchain-groq",
        "pytest"
            ],

    author="Sushant Sur",
    description="ROuting Agentic AI Workflow",
    python_requires=">=3.12",
)
EOL

echo "✅ Setup complete and ready to run!"
echo "✅ Project structure is ready."

echo "⚙️ Installing project in editable mode..."
pip install -e .

#Run the file using the command as ./init.sh in gitbash terminal