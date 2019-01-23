tarball_name=$(ls $downloads_dir | egrep "^jdk-${request_tarball_version}.*-linux-x64\.tar\.gz$" | sort -r | head -1)
