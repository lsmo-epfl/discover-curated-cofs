# using https://github.com/materialscloud-org/mc-docker-stack/tree/discover
#
FROM aiidalab/aiidalab-docker-stack:discover
USER root
WORKDIR /project

# Install jsmol
RUN wget https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.29/Jmol%2014.29.22/Jmol-14.29.22-binary.zip/download --output-document jmol.zip
RUN unzip jmol.zip && cd jmol-14.29.22 && unzip jsmol.zip

# Install nodejs for jsmol-bokeh-extension
RUN apt-get update && apt-get install -y --no-install-recommends nodejs

# Copy bokeh app
WORKDIR /project/discover-cofs
COPY figure ./figure
COPY detail ./detail
COPY select-figure ./select-figure
RUN ln -s /project/jmol-14.29.22/jsmol ./detail/static/jsmol
COPY setup.py ./
RUN pip install -e .
COPY .docker/serve-app.sh /opt/
COPY .docker/config.json /project/.aiida/

RUN useradd --home /project --uid 1000 --shell /bin/bash ubuntu && \
    chown -R ubuntu:ubuntu /project
#RUN chown -R scientist:scientist /project

USER ubuntu

# start bokeh server
EXPOSE 5006
CMD ["/opt/serve-app.sh"]

#EOF
