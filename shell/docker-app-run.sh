# -d background activate
# --name container name setting
# -p Host_Port:Docker_Port
# -v Host_Folder:Docker_Folder
source `dirname $0`/project.sh
docker run -d --name container-name -p 4000:4000 -v $ROOT:/root/SkynetLearn skynet-learn:latest