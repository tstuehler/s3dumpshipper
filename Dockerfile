FROM ubuntu

RUN mkdir /dumps; \
	apt update -y && \
	apt upgrade -y && \
	apt -y install inotify-tools wget && \
	(cd /usr/local/bin; wget https://dl.min.io/client/mc/release/linux-amd64/mc; chmod +x mc); \
	apt remove -y wget && \
	apt autoremove -y && \
	apt -y clean && \
	rm -r /var/cache/apt /var/lib/apt/lists/*

VOLUME ["/dumps"]
CMD ["/bin/sh", "-c", "mc config host add s3svc ${S3URL} ${S3ACCESS} ${S3SECRET} && inotifywait -m /dumps -e close_write | while read path action file; do mc cp \"$path$file\" \"s3svc/${S3BUCKET}/`date +%Y%m%dT%H%M%S`_`hostname`_$file\"; rm -f \"$path$file\"; done;"]

