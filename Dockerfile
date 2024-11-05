# Define the base image
FROM knime/knime-full:r-5.3.2-564

# Change to the root user
USER root
# Install the ca-certificates package to avoid SSL certificate issues
RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get install -yq ca-certificates && \
    # cleanup
    rm -rf /var/lib/apt/lists/*

# Change back to the knime user
USER knime

ENV KNIME_UPDATE_SITES=https://update.knime.com/analytics-platform/5.2,https://update.knime.com/community-contributions/trusted/5.2
# Install a feature from the Community Trusted update site
ENV KNIME_FEATURES="sdl.harvard.features.geospatial.feature.group"
RUN ./install-extensions.sh


# # Install Python packages
COPY py3_knime.yml /home/knime/py3_knime.yml
RUN /home/knime/miniconda3/condabin/conda env create -f /home/knime/py3_knime.yml
RUN /home/knime/miniconda3/condabin/conda clean -ay
RUN rm -rf /home/knime/py3_knime.yml
# COPY knime_dl_cpu.yml /home/knime/knime_dl_cpu.yml
# RUN /home/knime/miniconda3/condabin/conda env create -f /home/knime/knime_dl_cpu.yml
# RUN /home/knime/miniconda3/condabin/conda clean -ay
# RUN rm -rf /home/knime/knime_dl_cpu.yml

