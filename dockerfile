FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install sudo
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        gosu \
        sudo

################################################################################
# User settings

ARG USER_NAME
ENV USER_NAME=$USER_NAME

ENV GROUP_NAME="g-devbox"

RUN groupadd --gid 1001 ${USER_NAME} \
&& useradd --uid 1001 --gid 1001 -m -s /bin/bash ${USER_NAME} \
&& echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER_NAME} \
&& chmod 0440 /etc/sudoers.d/${USER_NAME} \
&& echo 'root:root' | chpasswd \
&& echo "${USER_NAME}:${USER_NAME}" | chpasswd \
&& groupadd --gid 1010 ${GROUP_NAME} \
&& usermod -aG ${GROUP_NAME} root \
&& usermod -aG ${GROUP_NAME} ${USER_NAME}

################################################################################
# Create necessary directories for build

# init
RUN mkdir -p /tmp/init/
COPY ./scripts/init/ /tmp/init/

# Software Neovim
ARG NEOVIM_VERSION

################################################################################
# Run initialization script
RUN chmod 777 /tmp/init/init.sh
RUN mkdir -p /var/log && chmod 777 /var/log

RUN /tmp/init/init.sh 2>&1 | tee /var/log/init.log

# Clean up
RUN rm -rf /tmp/init/

################################################################################
# SSH Setup

################################################################################
# Validate HOST_OS argument
ARG HOST_OS

# Add os name to environment variable
RUN \
if [ ! "$HOST_OS" = "Windows" ] \
&& [ ! "$HOST_OS" = "MacOS" ] \
&& [ ! "$HOST_OS" = "Linux" ] ; then \
echo "Unsupported HOST_OS: $HOST_OS. Supported values are Windows, MacOS, Linux." >&2; \
exit 1; \
fi

ENV HOST_OS=$HOST_OS

################################################################################
# Set default entrypoint and command

ENTRYPOINT ["/etc/devbox/scripts/entrypoint/entrypoint.sh"]

CMD ["/bin/bash"]
