#!/usr/bin/env bash
: "${PASSWORD_SHARE_ENDPOINT:=https://password.exchange}"

upload_pass() {
	local -r content=$1
	local -r passphrase=$2
	local -r endpoint=$PASSWORD_SHARE_ENDPOINT
	if [[ -z $passphrase ]]; then
		RESULT=$(curl -d "content=$content&api=on" -L "${endpoint}" 2>&1 | grep -o '"url":"[^"]*' - | grep -o '[^"]*$')
	else
		RESULT=$(curl -d "content=$content&other_lastname=$passphrase&api=on" -L "${endpoint}" 2>&1 | grep -o '"url":"[^"]*' - | grep -o '[^"]*$')
	fi
	if [[ -z $RESULT ]]; then
		printf "something went wrong with uploading: %s" "${RESULT}"
	else
		printf "\n%s\n" "${RESULT}"
	fi
}
prepare_pass() {
	local _path="$1"
	local _password
	if [[ ${FIRST_LINE} -gt 0 ]]; then
		_password="$(pass show "${_path%%.gpg}" 2>/dev/null | head -n 1)"

	elif [[ ${LAST_LINE} -gt 0 ]]; then
	   	_password="$(pass show "${_path%%.gpg}" 2>/dev/null | tail -n 1)"
	else
		_password="$(pass show "${_path%%.gpg}" 2>/dev/null)"

	fi
	if [[ -z "$_password" ]]; then
		# Not testing empty passwords
		printf "%s is empty\n" "$_path"
		return 0
	else
		printf "uploading %s\n" "$_path"
		upload_pass "$_password" "$PASSPHRASE"
	fi
}
usage() {
	cat <<-EOF

	Make it easy to share passwords with anyone without an extra subscription or software so even your grandma can use it
	-p | --passphrase - passphrase to protect webpage
	-h | --help - Display this help
	-t | --tail - Only send the last line of the password store item
	-H | --head - Only send the first line of password store item
	EOF
}
cmd_share_pass() {

	local _path
	if [[ -n "$1" ]]; then
		for _path in "$@"; do
			prepare_pass "$_path"
		done
	else
		cd "$PREFIX" || exit 1
		for _path in **/*\.gpg; do
			prepare_pass "$_path"
		done
	fi

}

while getopts ":hp:Ht-:" opt; do
	case "${opt}" in
	h)
		usage
		;;
	p)
		PASSPHRASE="${OPTARG}"
		;;
	H)
		FIRST_LINE=1
		;;
	t)
	   LAST_LINE=1
	   ;;
	-)
		case "$OPTARG" in
		
		passphrase)
			PASSPHRASE="${2}"
			shift
			;;
		help)
			usage
			exit 0
			;;
		head)
			FIRST_LINE=1
			;;
		tail)
		    LAST_LINE=1
			;;
		*)
			echo >&2 "Invalid long option ${OPTARG}.  Use --help for a help menu."
			return 2
			;;
		esac
		;;
	:)
		echo >&2 "Invalid Option: $OPTARG requires an arguement. Use --help for a help menu."
		return 2
		;;

	*)
		echo >&2 "Invalid short option ${OPTARG}.  Use --help for a help menu."
		usage
		return 2
		;;
	esac
done
shift $((OPTIND - 1))
cmd_share_pass "$@"
