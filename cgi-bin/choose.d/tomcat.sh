tarball_name=$(ls $downloads_dir | egrep "^apache-tomcat-${request_tarball_version}.*\.tar\.gz$" | sort -r | head -1)
