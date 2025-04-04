# Helix Editor Docker Environment

This repository provides a Dockerized environment for the [Helix Editor](https://helix-editor.com/), a modern text editor. The Dockerfile sets up the Helix editor along with essential tools and language servers for development.

## Features

- **Helix Editor**: Installed and configured for use.
- **Python LSP Server**: Includes `python-lsp-server` with `ruff` and `black` injected.
- **Bash Language Server**: Installed globally via `npm`.
- **Pre-configured Environment**: Includes necessary dependencies and configurations.

## Requirements

- Docker installed on your system.

## Usage

1. **Pull the Pre-built Image**:
   You can pull the pre-built container from Docker Hub:
   ```bash
   docker pull sivannikov/debug-container
   ```

2. **Build the Docker Image Locally** (optional):
   If you prefer to build the image locally:
   ```bash
   docker build -t helix-editor .
   ```

3. **Run the Container**:
   ```bash
   docker run -it helix-editor
   ```

4. **Access Helix**:
   Inside the container, you can use the `hx` command to start the Helix editor.

## Customization

- You can modify the `.config` directory to include your custom Helix configurations. This directory is copied into the container during the build process.

## Notes

- The Dockerfile uses the `bitnami/minideb:bookworm` base image.
- Ensure that the required dependencies are installed on your host system to build the image successfully.

## License

This project is licensed under the Apache-2.0 License. See the `Dockerfile` for copyright details.
