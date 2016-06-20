# common params wraps variables pass from fastcgi

# e.g. http://localhost:8080/tarball-repo/cgi-bin/choose?java=8&d=y
# echo $APP_PATH          #   /tarball-repo
# echo $APP_DIR           #   /var/website/tarball-repo
# echo $APP_BASEURL       #   http://localhost:8080/tarball-repo/
# echo $DOCUMENT_PATH     #   /cgi-bin/choose
# echo $REQUEST_URL       #   http://localhost:8080/tarball-repo/cgi-bin/choose?java=8&d=y
# echo $REQUEST_URI       #   /tarball-repo/cgi-bin/choose?java=8&d=y
# echo $QUERY_STRING      #   java=8&d=y
# echo ${PARAM_NANES[@]}  #   (java d)
# echo $PARAM[java]       #   8

# custom param pass from fcgi which represents app path in uri, a bit like getContexPath in servlet
APP_PATH=$APP_PATH

# directory of the app on the file system, a bit like request.getServletContext().getRealPath("/") in servlet
# all bash cgi script must use this variable to locate resources on file system
APP_DIR=$DOCUMENT_ROOT$APP_PATH


# the BASE URL of the app
if [[ ${SERVER_PORT} != 80 ]]; then
  PORT_STRING=:${SERVER_PORT}
fi
APP_URL=${REQUEST_SCHEME}://${HTTP_HOST}${PORT_STRING}$APP_PATH

# a part of uri of followed APP_PATH, a bit like getServletPath in servlet
#DOCUMENT_PATH  #TODO: implement it

# REQUEST_URL ,a bit lile getRequestURL in servlet
REQUEST_URL=${REQUEST_SCHEME}://${HTTP_HOST}${PORT_STRING}$REQUEST_URI

# the param is tailed with QUERY_STRING , getQueryString in servlet is not tailed with that
REQUEST_URI=$REQUEST_URI

QUERY_STRING=$QUERY_STRING

# a associate array of params. see http://stackoverflow.com/questions/3919755/how-to-parse-query-string-from-a-bash-cgi-script
OIFS=$IFS
IFS='&'
PARAM_P=($QUERY_STRING)
declare -A PARAM
IFS='='
for ((i=0; i<${#PARAM_P[@]}; i+=1)); do
    PARAM_KV=(${PARAM_P[i]})
    PARAM[${PARAM_KV[0]}]=${PARAM_KV[1]}
done
IFS=$OIFS
unset i PARAM_P PARAM_KV
# TODO: implement post parameter

#array contain the names of request parameters
PARAM_NANES=(${!PARAM[@]})


# encode & decode url
# see https://gist.github.com/cdown/1163649
urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
