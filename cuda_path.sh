cuda_bin_path="/usr/local/cuda/bin"
if [ -n "${PATH##*${cuda_bin_path}}" -a -n "${PATH##*${cuda_bin_path}:*}" ]; then
    export PATH=$PATH:${cuda_bin_path}
fi
