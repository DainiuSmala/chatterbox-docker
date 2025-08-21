FROM nvidia/cuda:11.8.0-runtime-ubuntu20.04

WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Clone the actual repository
RUN git clone https://github.com/stlohrey/chatterbox-finetuning.git .

# Install dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install -r requirements.txt

# Install PyTorch with CUDA
RUN pip3 install --no-cache-dir \
    torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    torchaudio==2.0.2+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Create directories
RUN mkdir -p /workspace/data /workspace/models

CMD ["sleep", "infinity"]
