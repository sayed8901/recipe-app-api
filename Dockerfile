FROM python:3.9-alpine3.13

# Disable output buffering to ensure logs appear in real-time
ENV PYTHONUNBUFFERED 1


# Copy dependencies file from local development to  Docker container
COPY ./requirements.txt /tmp/requirements.txt
# Copy the application source code into the container
COPY ./app /app

# Set the working directory inside the container to /app
WORKDIR /app

# Expose port 8000 to allow external access to the Django application
EXPOSE 8000


# This Dockerfile contains all necessary commands to build and run a Python image.
# "&& \" is used to break long commands into multiple lines for better readability.

# line by line explanation of the RUN command:
# python -m venv /py && \  
#     → Creates a virtual environment at `/py`. Using a virtual environment in Docker ensures isolation.

# /py/bin/pip install --upgrade pip && \  
#     → Install & upgrades `pip` inside the virtual environment to ensure the latest package manager.

# python -m venv /py && \  
#     → Creates a virtual environment at `/py`. Using a virtual environment in Docker ensures isolation.

# /py/bin/pip install --upgrade pip && \  
#     → Upgrades `pip` inside the virtual environment to ensure the latest package manager.

# rm -rf /tmp && \  
#     → Removes the `/tmp` directory after installation to reduce image size and keep the container lightweight.

# adduser \  
#     --disabled-password \  
#     --no-create-home \  
#     django-user  
# → Creates a non-root user `django-user` without a password and home directory.
# Running the application as a non-root user improves security by limiting access in case of a system hack.

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


# It will update the path dynamically in the docker
ENV PATH="/py/bin:$PATH"

# defining and using the custom django-user
USER django-user
