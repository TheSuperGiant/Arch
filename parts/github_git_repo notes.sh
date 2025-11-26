#adding
#cd to location that must can add new files to repo
#git init
#git remote add origin (my repo https .git url that is standing in my github repo)

git push #uploading updated files to github repo
git add .
git commit -m "$1"
#git push -u (repo added name) stable
git push -u origin stable

git pull #updating updated files from github repo