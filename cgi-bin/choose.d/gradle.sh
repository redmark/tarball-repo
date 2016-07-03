tarball_name=$(ls $downloads_dir | egrep "^gradle-${request_tarball_version}.*-(all|bin)\.zip$" | sort -r | head -1)
