# Use a multi-stage build
FROM arm64v8/debian AS builder

# Copy your ARM64 binary and any necessary files
COPY runme.arm64 /app/runme.arm64

# Set the working directory
WORKDIR /app

# The actual runtime image
FROM arm64v8/debian

# Install QEMU for ARM64 emulation
RUN apt-get update && apt-get install -y qemu-user

# Copy the ARM64 binary from the builder stage
COPY --from=builder /app/runme.arm64 /app/runme.arm64

# Set the working directory
WORKDIR /app

# Run the ARM64 binary using QEMU emulation
CMD ["qemu-aarch64", "./runme.arm64"]

