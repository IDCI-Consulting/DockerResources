FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl xvfb chromium-browser firefox ruby ruby-dev npm

WORKDIR /usr/src/app

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists

RUN gem install sass

RUN npm install --global eslint bower gulp && echo '{ "allow_root": true }' > /root/.bowerrc

# Add Chromium and Firefox with xvfb for karma tests

ADD xvfb-chromium /usr/bin/xvfb-chromium
RUN chmod +x /usr/bin/xvfb-chromium
ENV CHROMIUM_BIN=/usr/bin/xvfb-chromium

ADD xvfb-firefox /usr/bin/xvfb-firefox
RUN chmod +x /usr/bin/xvfb-firefox
ENV FIREFOX_BIN=/usr/bin/xvfb-firefox
