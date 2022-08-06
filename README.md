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

An example usage of this image may look as follows (docker-compose):

```yaml
version: '3'
services:
  mail-downloader:
    image: thej6s/mail-downloader
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