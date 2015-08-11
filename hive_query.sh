sudo -u hdfs hive -e 'INSERT OVERWRITE DIRECTORY "/output/hackathon/delivered/"
select "delivered" as event,reason as response,"None" as sg_event_id,msgid as sg_message_id,"delivered" as event,email,processed as timestamp,smtp_id as `smtp-id`,unique_args as unique_arg_key,category
from deliveredevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/unsubscribe/"
select "unsubscribe" as event,msgid as sg_message_id,email,processed as timestamp,unique_args as unique_arg_key,category,"unsubscribe" as event
from unsubscribeevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/processed/"
select "processed" as event,"None" as sg_event_id,msgid as sg_message_id,email,processed as timestamp,smtp_id as `smtp-id`,unique_args as unique_arg_key,category,"processed" as event
from processedevent_orc
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/deferred/"
select "deferred" as event,reason as response,"None" as sg_event_id,msgid as sg_message_id,"deferred" as event,email,processed as timestamp,smtp_id as `smtp-id`,unique_args as unique_arg_key,category,attempt
from deferredevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/spamreport/"
select "spamreport" as event,"None" as sg_event_id,"None" as sg_message_id,email,processed as timestamp,unique_args as unique_arg_key,category,"spamreport" as event
from spamreportevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/open/"
select "open" as event,email,processed as timestamp,http_remote_ip as ip,"None" as sg_event_id,msgid as sg_message_id,http_user_agent as useragent,"open" as event,unique_args as unique_arg_key,category
from openevent_orc
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/click/"
select "click" as event,"None" as sg_event_id,msgid as sg_message_id,http_remote_ip as ip,http_user_agent as useragent,"click" as event,email,processed as timestamp,url,unique_args as unique_arg_key,category
from clickevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/bounce/"
select "bounce" as event,status,sg_event_id,msgid as sg_message_id,"bounce" as event,email,processed as timestamp,smtp_id as `smtp-id`,unique_args as unique_arg_key,category,reason,type
from bounceevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
INSERT OVERWRITE DIRECTORY "/output/hackathon/dropped/"
select "dropped" as event,sg_event_id,sg_message_id,email,processed as timestamp,smtp_id as `smtp-id`,unique_args as unique_arg_key,category,reason,"dropped" as event
from dropevent
where userid='$1' and partd>="'$2'" and party>="'$3'";
'
sudo -u hdfs hadoop fs -rm -r /output/hackathonOutput
sudo -u hdfs /usr/bin/hadoop jar /opt/cloudera/parcels/CDH-5.3.5-1.cdh5.3.5.p0.4/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming.jar -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -D mapreduce.map.memory.mb=4096 -D mapreduce.map.output.key.field.separator=  -D mapreduce.map.output.compress=true -D mapreduce.partition.keycomparator.options="-k1,1 -k2,2 -k3,3n" -D mapreduce.output.fileoutputformat.compress=true -D stream.num.map.output.key.fields=3 -D mapreduce.job.queuename=root.Engagement -D mapreduce.output.fileoutputformat.compress.type=BLOCK -D mapreduce.reduce.speculative=false -D mapreduce.output.fileoutputformat.compress.codec=org.apache.hadoop.io.compress.GzipCodec -D mapreduce.map.speculative=false -D stream.map.output.field.separator=  -D mapred.child.java.opts=-Xmx4096m -D mapreduce.partition.keypartitioner.options="-k1,1" -D mapreduce.job.name="hackathonTest" -input /output/hackathon/*/* -output /output/hackathonOutput/ -mapper "/usr/bin/docker run -i --rm --log-driver none docker.sendgrid.net/hadoop_streaming json_translate" -reducer org.apache.hadoop.mapred.lib.IdentityReducer -partitioner "org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner"
rm -r hackathonOutput
hadoop fs -copyToLocal /output/hackathonOutput ./
rm hackathonOutput/_SUCCESS
s3cmd put ./hackathonOutput/* s3://sg-hack-kibana-ingest/$1/
