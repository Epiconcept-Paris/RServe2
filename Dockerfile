FROM debian:buster

RUN echo "export TERM=xterm" >> /root/.bashrc
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG rsutils_version


RUN apt-get install -y debconf apt-transport-https && \
	apt-get update && apt-get upgrade -y && \
	apt-get  install -y apt-utils debconf-utils gnupg 

# Install de R base et devel
# ---------------------------------------------------------------------------------------------------------------------
RUN echo "locales locales/default_environment_locale select fr_FR.UTF-8" | debconf-set-selections && \
	echo "locales locales/locales_to_be_generated multiselect All locales" | debconf-set-selections && \
	echo "deb http://cran.univ-paris1.fr/bin/linux/debian buster-cran35/" >/etc/apt/sources.list.d/R.list && \
	apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' && \
	apt-get update --allow-unauthenticated && \
	apt-get install --allow-unauthenticated -y r-base r-base-dev locales

# Install JAVA
# ---------------------------------------------------------------------------------------------------------------------
RUN apt-get install -y default-jre default-jdk

# Install des librairies et programmes système nécessaires au packages R
# ---------------------------------------------------------------------------------------------------------------------
RUN apt-get install -y curl pandoc libgdal-dev libgeos-dev libproj-dev \
	vim-tiny procps nano \
	libssl-dev libudunits2-dev libcairo2-dev libmagick++-dev && \
	apt-get clean -y && rm -rf /var/lib/apt/lists/*


# Install des dépendances (packages R)
# Les nouveaux packages doivent être déclarés dans le fichier packages/packages_01.R
# --------------------------------------------------------------------------------------------
COPY packages/packages_01.R /
RUN R CMD javareconf && \
    Rscript --slave --no-restore --no-save --no-restore-history /packages_01.R

COPY packages/packages_02.R /
RUN R CMD javareconf && \
    Rscript --slave --no-restore --no-save --no-restore-history /packages_02.R

COPY packages/packages_03.R /
RUN R CMD javareconf && \
    Rscript --slave --no-restore --no-save --no-restore-history /packages_03.R

COPY packages/packages_03.R /
RUN R CMD javareconf && \
    Rscript --slave --no-restore --no-save --no-restore-history /packages_03.R

COPY packages/packages_04.R  /
RUN R CMD javareconf && \
    Rscript --slave --no-restore --no-save --no-restore-history /packages_04.R


# Installation des packages custom
# --------------------------------------------------------------------------------------------

# RServerUtils
# --------------------------------------------------------------------------------------------

RUN mkdir -p /tmp/RServerUtils && \
		curl -L https://github.com/Epiconcept-Paris/RServerUtils/tarball/${rsutils_version} | \
		tar -xzf - --strip-components=1 -C /tmp/RServerUtils && \
		cd /tmp && \
		R CMD build /tmp/RServerUtils && \
		R CMD INSTALL /tmp/RServerUtils_${rsutils_version}.tar.gz && \
		rm -rf /tmp/RServerUtils /tmp/RServerUtils_${rsutils_version}.tar.gz


# RServe : https://rforge.net/src/contrib/
# --------------------------------------------------------------------------------------------
RUN mkdir /rserver
VOLUME /rserver


# RServe : configuration file
# --------------------------------------------------------------------------------------------
RUN mkdir -p /var/www/r_storage/RExec
COPY Rserv.conf /etc/Rserv.conf 

RUN mkdir -p /usr/local/bin

COPY runrserver.sh /usr/local/bin/runrserver.sh

EXPOSE 6312

CMD ["runrserver.sh"]

ADD Dockerfile /
LABEL fr.epiconcept.application="stat-rserv"
LABEL fr.epiconcept.rsutils_version="${rsutils_version}"

