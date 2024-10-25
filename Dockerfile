# Define the base image
FROM knime/knime-full:r-5.3.2-564
# registry.hub.knime.com/knime/knime-full:r-5.3.1-498
# knime/knime-full:r-5.3.2-563
# Define the list of update sites and features


# Change to the root user
USER root
# Install the ca-certificates package to avoid SSL certificate issues
# RUN apt update && apt install -y ca-certificates curl
# Update/upgrade package manager and install ca-certificates to enable ca certificates that micromamba (for python) is asking for
RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get install -yq \
        ca-certificates curl && \
    # cleanup
    rm -rf /var/lib/apt/lists/*

# Change back to the knime user
USER knime


ENV KNIME_UPDATE_SITES=https://update.knime.com/analytics-platform/5.2,https://update.knime.com/community-contributions/trusted/5.2
# Install a feature from the Community Trusted update site
ENV KNIME_FEATURES="sdl.harvard.features.geospatial.feature.group"

# Execute extension installation script 
RUN ./install-extensions.sh

# set up the Python environment

# Install Python 3.9
# RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" 
# # /home/knime/
# RUN bash -c "bash Miniforge3-$(uname)-$(uname -m).sh -b -p /home/knime/condaforge"
# RUN rm -rf Miniforge3-$(uname)-$(uname -m).sh
# ENV PATH="/home/knime/condaforge/bin:$PATH"

# # Install Python packages
COPY py3_knime.yml /home/knime/py3_knime.yml
RUN /home/knime/miniconda3/condabin/conda env create -f /home/knime/py3_knime.yml
COPY knime_dl_cpu.yml /home/knime/knime_dl_cpu.yml
RUN /home/knime/miniconda3/condabin/conda env create -f /home/knime/knime_dl_cpu.yml
# RUN rm -rf /home/knime/py3_knime.yml