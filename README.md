# Mail-Downloader

Simple Docker container that uses getmail, procmail & munpack
in order to extract E-Mail attachments similar to the process
outlined in the following article: https://thej6s.com/articles/2019-01-03__automatic-email-attachement-extraction/

## Usage

This image assumes, that the following volumes are mounted:
* `/out` for the directory containing the output files
* `/getmail` for a temporary directory. getmail will keep track of which mails it has seen already here.

Additionally, the following environment variables must be supplied:
* `SMTP_SERVER`, `SMTP_USER`, `SMTP_PASSWORD`
* `RULE`: The procmailrc rule filtering the mails (e.g. `From: foo@bar.com`, `Reply-Top: foobar@test.com`)
  * See https://linux.die.net/man/5/procmailex
* `KEEP_BODY=1` can be used in order to keep the body of the mail. By default only attachments are being downloaded

An example usage of this image may look as follows (docker-compose):

```yaml
version: '3'
services:
  mail-downloader:
    image: thej6s/mail-downloader:mail
    environment:
      - 'SMTP_SERVER=mail.myprovider.com'
      - 'SMTP_USER=...'
      - 'SMTP_PASSWORD=...'
      - 'RULE=From: notes@me.com'
    # Note: These directories must belong to 1000:1000
    volumes:
      - './.data/getmail:/getmail'
      - './.data/out:/out'
```

Or as follows (bash script)

```bash
#!/bin/bash

mkdir -p $HOME/.getmail
docker run --rm \
	-e 'SMTP_SERVER=mail.myprovider.com' \
	-e 'SMTP_USER=...' \
	-e 'SMTP_PASSWORD=...' \
	-e 'RULE=From: notes@me.com' \
	-v "$HOME/.getmail:/getmail" \
	-v "$HOME/notes:/out" \
	thej6s/mail-downloader:main
```
