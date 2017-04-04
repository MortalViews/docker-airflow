# VERSION 1.8.0
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

FROM debian:jessie
MAINTAINER Puckel_

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.8.0
ARG AIRFLOW_HOME=/usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        python-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python-pip \
        python-requests \
        apt-utils \
        curl \
        netcat \
        locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && python -m pip install -U pip \
    && pip install Cython \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 
    
#RUN pip install airflow[crypto,celery,postgres]==$AIRFLOW_VERSION 
 #RUN  pip install celery[redis]==3.1.17 \
#    && apt-get remove --purge -yqq $buildDeps \
#    && apt-get clean \
#RUN rm -rf \
#        /var/lib/apt/lists/* \
#        /tmp/* \
#        /var/tmp/* \
#        /usr/share/man \
#        /usr/share/doc \
#        /usr/share/doc-base
RUN apt-get -yqq --no-install-recommends install vim 
RUN apt-get -yqq --no-install-recommends install less 

RUN pip install alembic==0.8.10\
				amqp==2.1.4\
				appdirs==1.4.3\
				asn1crypto==0.22.0\
				Babel==2.4.0\
				billiard==3.5.0.2\
				bleach==2.0.0\
				celery==4.0.2\
				cffi==1.10.0\
				click==6.7\
				configparser==3.5.0\
				croniter==0.3.16\
				cryptography==1.8.1\
				dill==0.2.6\
				docutils==0.13.1\
				Flask==0.11.1\
				Flask-Admin==1.4.1\
				Flask-Cache==0.13.1\
				Flask-Login==0.2.11\
				flask-swagger==0.2.13\
				Flask-WTF==0.12\
				flower==0.9.1\
				funcsigs==1.0.0\
				future==0.15.2\
				gitdb2==2.0.0\
				GitPython==2.1.3\
				gunicorn==19.3.0\
				html5lib==0.999999999\
				idna==2.5\
				itsdangerous==0.24\
				Jinja2==2.8.1\
				kombu==4.0.2\
				lockfile==0.12.2\
				lxml==3.7.3\
				Mako==1.0.6\
				Markdown==2.6.8\
				MarkupSafe==1.0\
				numpy==1.12.1\
				ordereddict==1.1\
				packaging==16.8\
				pandas==0.19.2\
				psutil==4.4.2\
				psycopg2==2.7.1\
				pycparser==2.17\
				Pygments==2.2.0\
				pyparsing==2.2.0\
				python-daemon==2.1.2\
				python-dateutil==2.6.0\
				python-editor==1.0.3\
				python-nvd3==0.14.2\
				python-slugify==1.1.4\
				pytz==2017.2\
				PyYAML==3.12\
				requests==2.13.0\
				setproctitle==1.1.10\
				six==1.10.0\
				smmap2==2.0.1\
				SQLAlchemy==1.1.7\
				tabulate==0.7.7\
				thrift==0.9.3\
				tornado==4.2\
				Unidecode==0.4.20\
				vine==1.1.3\
				webencodings==0.5\
				Werkzeug==0.12.1\
				WTForms==2.1\
				zope.deprecation==4.2.0

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME}

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
