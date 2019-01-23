tarball_name=$(ls $downloads_dir | egrep "openjdk-${request_tarball_version}.*_linux-x64_bin\.tar\.gz$" | sort -r | head -1)
