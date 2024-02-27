# Define the base image
FROM registry.hub.knime.com/knime/knime-full:r-5.1.2-433
# Define the list of update sites and features
# Optional, the default is the KNIME Analytics Platform update site (first entry in the list below)
ENV KNIME_UPDATE_SITES=https://update.knime.com/analytics-platform/5.1,https://update.knime.com/community-contributions/trusted/5.1
# Install a feature from the Community Trusted update site
# ENV KNIME_FEATURES="sdl.harvard.features.geospatial.feature.group"
ENV KNIME_FEATURES="sdl.harvard.features.geospatial.feature.group"

# Change to the root user
USER root
# Install the ca-certificates package to avoid SSL certificate issues
RUN apt update && apt install -y ca-certificates curl
# Change back to the knime user
USER knime

# Execute extension installation script 
RUN ./install-extensions.sh

# Install Python 3.9
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" 
# /home/knime/
RUN bash -c "bash Miniforge3-$(uname)-$(uname -m).sh -b -p /home/knime/condaforge"
RUN rm -rf Miniforge3-$(uname)-$(uname -m).sh
ENV PATH="/home/knime/condaforge/bin:$PATH"

# Install Python packages
COPY knime_py39.yml /home/knime/knime_py39.yml
RUN /home/knime/condaforge/bin/conda env create -f /home/knime/knime_py39.yml
RUN rm -rf /home/knime/knime_py39.yml