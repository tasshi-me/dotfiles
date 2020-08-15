#------------#
# http proxy #
#------------#
# INFO: set your http_proxy_fqdn, http_proxy_port by direnv
function set_proxy_if_available() {
  export http_proxy=
  export https_proxy=
  export no_proxy=
  if [ -n "${http_proxy_fqdn}" -a -n "${http_proxy_port}" ]; then
    if ping -c 1 -W 1 -n -o ${http_proxy_fqdn} &> /dev/null; then
      echo "proxy: http://${http_proxy_fqdn}:${http_proxy_port}"
      export http_proxy=http://${http_proxy_fqdn}:${http_proxy_port}
      export https_proxy=${http_proxy}
      export no_proxy=127.0.0.1,localhost
    fi
  fi
}
function unset_proxy() {
  export http_proxy=
  export https_proxy=
  export no_proxy=
}
# commands which use proxy
alias curl='set_proxy_if_available; curl'
alias npm='set_proxy_if_available; npm'
alias npx='set_proxy_if_available; npx'
alias yarn='set_proxy_if_available; yarn'
