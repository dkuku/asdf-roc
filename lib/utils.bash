#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for roc.
GH_REPO="https://github.com/roc-lang/roc"
GH_NIGHTLY_REPO="https://github.com/roc-lang/nightlies"
TOOL_NAME="roc"
TOOL_TEST="roc -V"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if roc is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	local repo="${1:-$GH_NIGHTLY_REPO}"
	git ls-remote --tags --refs "$repo" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# List versions from both repos (nightly and stable releases)
	# Combine tags from both repos, sort, and remove duplicates
	{
		list_github_tags "$GH_NIGHTLY_REPO"
		list_github_tags "$GH_REPO"
	} | sort_versions | uniq
}

get_repo_for_version() {
	local version="$1"
	# Check if version exists in nightly repo
	if git ls-remote --tags --refs "$GH_NIGHTLY_REPO" | grep -q "refs/tags/v\?${version}$"; then
		echo "$GH_NIGHTLY_REPO"
	# Otherwise check stable repo
	elif git ls-remote --tags --refs "$GH_REPO" | grep -q "refs/tags/v\?${version}$"; then
		echo "$GH_REPO"
	else
		# Default to stable repo if not found
		echo "$GH_REPO"
	fi
}

download_release() {
	local version filename url repo asset_name
	version="$1"
	filename="$2"
	
	# Determine which repo to download from
	repo=$(get_repo_for_version "$version")
	
	arch=$(uname -m)
	os=$(uname)
	case $os in
	Linux)
		os="linux"
		;;
	Darwin)
		os="macos"
		;;
	*)
		os="unknown"
		;;
	esac

	if [ "$os" = "macos" ] && [ "$arch" = "arm64" ]; then
		arch="apple_silicon"
	fi

	# Construct download URL based on the repo
	if [ "$repo" = "$GH_NIGHTLY_REPO" ]; then
		# Nightly repo: roc_nightly-${os}_${arch}-${tag}.tar.gz
		asset_name="roc_nightly-${os}_${arch}-${version}.tar.gz"
	else
		# Stable repo: roc-${os}_${arch}-${tag}.tar.gz
		asset_name="roc-${os}_${arch}-${version}.tar.gz"
	fi
	url="${repo}/releases/download/${version}/${asset_name}"

	echo "* Downloading $TOOL_NAME release $version from $(basename "$repo")..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert roc executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
