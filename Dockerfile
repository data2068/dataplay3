FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN sed -i s#//.*archive.ubuntu.com#//mirrors.aliyun.com# /etc/apt/sources.list && \
    apt-get update -q && \
    # Dependencies
    apt-get install --no-install-recommends -y -q \
        python3-dev \
        python3-pip \
        build-essential \
        gcc \
        swig \
        curl \
        git \
        libgomp1 \
        ca-certificates && \
    pip3 install setuptools pip --upgrade && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends -y -q nodejs

RUN cd /home \
    &&  git config --global http.proxy 'socks5://10.10.8.66:1080' \
    &&  git config --global https.proxy 'socks5://10.10.8.66:1080' \
    && git clone https://github.com/data2068/dataplay3

WORKDIR /home/dataplay3

# build server
#RUN curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip3 install

RUN cd /home/dataplay3/server && \
    pip3 install -r automl_requirements.txt -i http://pypi.douban.com/simple --trusted-host pypi.douban.com && \
    pip3 install -r requirements.txt -i http://pypi.douban.com/simple --trusted-host pypi.douban.com

# override numpy version  
# refer to https://github.com/scikit-learn-contrib/hdbscan/issues/272
# override holidays version
# refer to https://github.com/facebook/prophet/issues/796 
RUN pip3 install numpy==1.16.0 holidays==0.9.8 --force-reinstall -i http://pypi.douban.com/simple --trusted-host pypi.douban.com

# build client
RUN cd /home/dataplay3/client && \
    mkdir /home/dataplay3/server/dataplay/static && \
    npm install  && \
    npm run build

EXPOSE 8000

COPY entrypoint.sh /home/dataplay3

RUN  find /usr/local/lib/python3.6/ -name 'tests' -exec rm -r '{}' + && \
    find /usr/local/lib/python3.6/ -name '*.pyc' -exec rm -r '{}' + && \
    rm -rf /home/dataplay3/client && \
    rm -rf /home/dataplay3/docs && \
    apt-get remove nodejs gcc git curl -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

CMD ["sh", "/home/dataplay3/entrypoint.sh"]
