FROM elixir:1.8.1

# --- Set Locale to en_US.UTF-8 ---

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y locales

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# --- Erlang ODBC ---

RUN apt-get install erlang-odbc -y

# --- MSSQL ODBC INSTALL ---

RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
&& curl https://packages.microsoft.com/config/debian/8/prod.list | tee -a /etc/apt/sources.list.d/mssql-release.list \
&& apt-get update \
&& ACCEPT_EULA=Y apt-get install msodbcsql=13.1.9.2-1 -y \
&& apt-get install unixodbc-dev -y

# Erlang dependencies

RUN apt-get install -y erlang-dialyzer erlang-parsetools erlang-xmerl erlang-ssl erlang-crypto xsltproc

# --- APP INSTALL ---

RUN mix local.hex --force && \
    mix local.rebar --force

