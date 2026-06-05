
FROM rocker/r-ver:4.5.2
ENV RENV_CONFIG_REPOS_OVERRIDE=https://packagemanager.rstudio.com/cran/latest

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  cmake \
  libcurl4-openssl-dev \
  libicu-dev \
  libsodium-dev \
  libssl-dev \
  libuv1-dev \
  libx11-dev \
  libxml2-dev \
  make \
  zlib1g-dev \
  && apt-get clean
  
RUN Rscript -e "install.packages(c('plumber', 'pins', 'vetiver', 'aws.s3', 'duckdb'), repos='https://packagemanager.posit.co/cran/__linux__/jammy/latest')"

# Crucial fix: Make sure this copies whatever your API file is named in your repo
COPY plumber.R /opt/ml/plumber.R

EXPOSE 46261

# FIXED: Explicitly forcing Plumber to host on all interfaces (0.0.0.0) and stay alive
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('/opt/ml/plumber.R'); pr$run(host = '0.0.0.0', port = 46261, block = TRUE)"]