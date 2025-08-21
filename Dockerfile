FROM nvidia/cuda:11.8.0-runtime-ubuntu20.04

WORKDIR /workspace

# Install system dependencies including Git LFS
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    wget \
    curl \
    python3 \
    python3-pip \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for better Hugging Face downloads
ENV HF_HOME=/workspace/hf_cache
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENG GIT_LFS_SKIP_SMUDGE=1
ENV HF_HUB_DISABLE_PROGRESS_BARS=0

# Clone your repository
RUN git clone https://github.com/DainiuSmala/chatterbox-finetuning.git .

# Install Python dependencies with specific versions for stability
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Install Hugging Face hub tools for better download management
RUN pip3 install --no-cache-dir \
    huggingface_hub \
    hf_transfer \  # For accelerated downloads
    --upgrade

# Install PyTorch and ML dependencies
RUN pip3 install --no-cache-dir \
    torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    torchaudio==2.0.2+cu118 \
    transformers==4.31.0 \
    datasets==2.13.1 \
    accelerate==0.21.0 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Create cache directories
RUN mkdir -p ${HF_HOME} /workspace/data /workspace/models /workspace/output

# Optional: Pre-download specific components (adjust based on your needs)
# RUN python3 -c "
# from huggingface_hub import snapshot_download
# snapshot_download(repo_id='microsoft/DialoGPT-medium', cache_dir='$HF_HOME')
# "

CMD ["sleep", "infinity"]
