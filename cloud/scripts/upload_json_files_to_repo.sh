script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir/../..

sudo git config --global user.email "$1"
sudo git config --global user.name "$2"

sudo git add ./data/cloud_json
sudo git commit -m "Pushed annotated json data"
sudo git push
