FROM logstash:1.5.3

# Temporary workaround for https://github.com/logstash-plugins/logstash-input-http/commit/c20c01c73bdf38f657b8dfbd6262840fba7e1cf1
RUN /opt/logstash/bin/plugin update logstash-input-http
RUN /opt/logstash/bin/plugin update logstash-output-elasticsearch
RUN /opt/logstash/bin/plugin update logstash-input-s3
RUN /opt/logstash/bin/plugin update logstash-filter-date
RUN /opt/logstash/bin/plugin update logstash-codec-json
RUN /opt/logstash/bin/plugin update logstash-codec-json_lines

# Use custom entrypoint shell script
COPY docker-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["logstash"]
