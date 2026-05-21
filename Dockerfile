FROM node:22-slim

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y --no-install-recommends \
		# general exploration tools for agents
		curl \
		gpg \
		less \
		tree \
		htop \
		jq \
		jid \
		ripgrep \
		xmlstarlet \
		libxml2-utils \
		yq \
		fd-find \
		# Python toolchain
		python3 \
		python3-pip \
		python3-venv \
		python-is-python3 \
	# delete apt cache
	&& rm -rf /var/lib/apt/lists/* \
	# create `fd` as alias for `fdfind`
	&& ln -s $(which fdfind) /usr/local/bin/fd \
	# format ls output
	&& echo 'alias ls="ls -hal --color"' >> /root/.bashrc

# Java/Maven toolchain
RUN curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
		| gpg --dearmor --yes -o /usr/share/keyrings/adoptium.gpg \
	&& . /etc/os-release \
	&& printf '%s\n' \
'Types: deb' \
'URIs: https://packages.adoptium.net/artifactory/deb' \
"Suites: $VERSION_CODENAME" \
'Components: main' \
"Architectures: $(dpkg --print-architecture)" \
'Signed-By: /usr/share/keyrings/adoptium.gpg' \
		| tee /etc/apt/sources.list.d/adoptium.sources > /dev/null \
	&& apt update \
	&& apt install -y --no-install-recommends \
		temurin-25-jdk \
		maven \
	&& rm -rf /var/lib/apt/lists/*

# install opencode and link local config folders in workdir
RUN npm install -g opencode-ai \
	&& npm cache clean --force \
	&& rm /root/.local -Rf \
	&& mkdir -p /root/.local/share \
	&& mkdir -p /root/.local/state \
	&& ln -s /workdir/.myopencode/share/ /root/.local/share/opencode \
	&& ln -s /workdir/.myopencode/state/ /root/.local/state/opencode

WORKDIR /workdir/
ENTRYPOINT ["opencode"]
