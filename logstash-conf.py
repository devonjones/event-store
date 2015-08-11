#!/usr/bin/env python
import os

def gen_logstash_conf(user_id, access_key, secret_key):
	print "input {"
	print "  http {"
	print "    port => 8080"
	print "    codec => json"
	print "  }"
	print "  s3 {"
	print "    bucket => \"sg-hack-kibana-ingest\""
	print "    access_key_id => \"%s\"" % access_key
	print "    secret_access_key => \"%s\"" % secret_key
	print "    prefix => \"%s/\"" % user_id
	print "    codec => json"
	print "  }"
	print "}"
	print ""
	print "###############################################################################"
	print "## filters"
	print "###############################################################################"
	print "filter {"
	print "  date {"
	print "    match => [ \"timestamp\", \"UNIX\" ]"
	print "  }"
	print "}"
	print ""
	print "###############################################################################"
	print "## output"
	print "###############################################################################"
	print "output {"
	print "  elasticsearch {"
	print "    protocol => http"
	print "    host => elasticsearch"
	print "  }"
	print "  stdout {"
	print "    codec => rubydebug"
	print "  }"
	print "}"

def main():
	gen_logstash_conf(os.environ['USER_ID'], os.environ['ACCESS_KEY'], os.environ['SECRET_KEY'])

if __name__ == '__main__':
	main()

