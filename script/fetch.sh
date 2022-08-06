#!/bin/bash
set -euo pipefail
set -x

if [ -z "${SMTP_SERVER}" ] || [ -z "${SMTP_USER}" ] || [ -z "${SMTP_PASSWORD}" ] || [ -z "${RULE}" ]; then
	echo "SMTP_SERVER, SMTP_USER, SMTP_PASSWORD, RULE are required";
	exit 1;
fi;

DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(realpath "${DIR}")"

OUT_DIR=/out
TMP_DIR=/getmail

export PROCMAILRC_PATH=$(mktemp)
GETMAILRC_PATH=$(mktemp)

cat "${DIR}/getmailrc.template" \
	| sed -e "s|__SMTP_SERVER__|${SMTP_SERVER}|g"\
	| sed -e "s|__SMTP_USER__|${SMTP_USER}|g"\
	| sed -e "s|__SMTP_PASSWORD__|${SMTP_PASSWORD}|g"\
	| sed -e "s|__PROCMAILRC_PATH__|${PROCMAILRC_PATH}|g"\
	> ${GETMAILRC_PATH}

cat "${DIR}/procmailrc.template" \
	| sed -e "s|__OUT_DIR__|${OUT_DIR}|g" \
	| sed -e "s|__RULE__|${RULE}|g" \
	> ${PROCMAILRC_PATH}

cat ${GETMAILRC_PATH}
cat ${PROCMAILRC_PATH}

getmail --rcfile=${GETMAILRC_PATH} --getmaildir=${TMP_DIR} -vvv

for f in $(find ${OUT_DIR} -iname 'part*'); do
	rm -v "${f}"
done;
rm -v ${GETMAILRC_PATH} ${PROCMAILRC_PATH}
