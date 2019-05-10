rm -f ~/.kube/config; sudo rm -f /root/.kube/config; sudo rm -f /var/lib/dbus/machine-id; sudo rm -f /etc/machine-id; sudo rm -f /etc/weave/machine-uuid; sudo rm -f /etc/.regen-machine-id; sudo rm -f /root/.bash_history; sudo rm -f /home/ubuntu/.bash_history; sudo rm -f /etc/docker/key.json; sudo systemctl stop kubelet; sudo find /var/lib/kubelet | xargs -n 1 findmnt -n -t tmpfs -o TARGET -T | uniq | xargs -r sudo umount -v; sudo rm -r -f /etc/kubernetes /var/lib/kubelet /var/lib/etcd /etc/cni/net.d/* /var/lib/dockershim; true

sudo dbus-uuidgen --ensure
sudo dbus-uuidgen > /etc/machine-id
