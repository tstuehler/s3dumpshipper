FROM alpine

RUN mkdir /dumps; \
	apk add --no-cache inotify-tools ca-certificates wget && \
	(cd /usr/local/bin; wget https://dl.min.io/client/mc/release/linux-amd64/mc; chmod +x mc); \
	apk del wget

VOLUME ["/dumps"]
CMD ["/bin/sh", "-c", "mc config host add s3svc ${S3URL} ${S3ACCESS} ${S3SECRET} && inotifywait -m /dumps -e close_write | while read path action file; do mc cp \"$path$file\" \"s3svc/${S3BUCKET}/`date +%Y%m%dT%H%M%S`_`hostname`_$file\"; rm -f \"$path$file\"; done;"]

