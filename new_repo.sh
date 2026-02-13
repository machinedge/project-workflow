if [ -z "$1" ]; then
        echo "Usage: newrepo <repo-name> <optional[claude | cursor>]"
        return 1
fi

REPO_NAME="$1"
REPO_DIR="$HOME/work/$REPO_NAME"

mkdir -p "$REPO_DIR" && \
pushd "$REPO_DIR" || return 1

touch README.md
touch .gitignore

# setup the project 
./setup.sh $2 $REPO_DIR


git init
git add .
git commit -m "Initial commit: add README and .gitignore"

gh repo create "machinedge/$REPO_NAME" --private || {
    echo "Failed to create GitHub repo"
    popd
    return 1
}
git remote add origin "git@github.com:machinedge/$REPO_NAME"
git branch -M main
git push -u origin main