FROM ruby:2.5
RUN apt-get update && \
    gem install icalendar nokogiri tzinfo
WORKDIR /data
CMD /data/work/run.sh
