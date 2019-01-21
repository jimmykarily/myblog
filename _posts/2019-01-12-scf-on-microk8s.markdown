---
layout: default
title: "SUSE CloudFoundry on microk8s"
description: A guide on how to setup scf on microk8s for development or demo
date:   2019-01-12
#image: /images/lake_reflections.jpg
tags: [microk8s, cloudfoundry, scf, suse, kubernetes]
---

# SUSE Cloud Application Platform (CAP) on Microk8s

Unless you've been living under a rock, you probably know what [kubernetes](https://kubernetes.io/) is. If you have been living under a rock (which is nothing to be ashamed of), kubernetes is a production-grade container orchestrator or in simple words a way to use containers in production to deploy applications and services.

There are a number of ways to try kubernetes locally (check [this link](https://kubernetes.io/docs/setup/pick-right-solution/#local-machine-solutions)). A couple of weeks ago I decided to give microk8s a try. The idea of microk8s was very appealing to me because they use your machine's resources without you having to decide on a VM size beforehand. I remember there was a project that run Kubernetes containerized but it was abandoned in favor of minikube (can't find a link to that original project anymore, sorry). Microk8s is the closest I could get to that solution.
(Bonus link: [microk8s - minikube comparison by Thomas Pliakas](https://codefresh.io/kubernetes-tutorial/local-kubernetes-linux-minikube-vs-microk8s/))

My goal was to run [SUSE Cloud Application Platform](https://github.com/suse/scf) on top of MicroK8S and see if I could use it for local development on [scf](https://github.com/SUSE/scf) or demonstration reasons. Everything worked fine in the end and below you can find the steps I followed to achieve that.

## Set up microk8s

microk8s run on [Snap](https://snapcraft.io/). To install Snap on openSUSE Tumbleweed I followed the instructions here: https://forum.snapcraft.io/t/installing-snap-on-opensuse/8375

- Start snapd:

```bash
$ sudo systemctl start snapd
$ # Consider enabling the snapd service to automatically start it after reboots
$ # sudo systemctl enable snapd 
```

- Add snap bin directory to your path (add this to your bashrc or similar):

```bash
$ export PATH=$PATH:/snap/bin
```

- Install microk8s:

```bash
$ snap install microk8s --classic
```

- Start microk8s:

```bash
$ microk8s.start
```

- Enable kube dns and the default storage class:

```bash
$ microk8s.enable dns storage
```

- Point kubectl to your cluster:

```bash
$ microk8s.config > microk8s_kubeconfig
$ export KUBECONFIG=$PWD/microk8s_kubeconfig
```

- Check that dns and storage work:

```bash
$ watch kubectl get pods -n kube-system
```

Wait until both pods become ready (`hostpath-provisioner-*` and `kube-dns-*`). In my case I had to open my firewall and also permit the communication between the pods using the fix mentioned [here](https://microk8s.io/docs/#my-pods-cant-reach-the-internet-but-my-microk8s-host-machine-can):

```bash
$ sudo iptables -P FORWARD ACCEPT
```

## Prepare for CAP

Before we deploy SUSE Cloud Application Platform on our fresh cluster there are a couple of changes we need to make in the configuration of docker and kubelet in microk8s.

### Fix ulimit in containers

There is a script that calls `ulimit` inside a container and it will fail with the following error unless we change docker's settings:

```
[2019-01-07 12:08:27+0000] /var/vcap/jobs/uaa/bin/uaa_ctl: line 47:
ulimit: open files: cannot modify limit: Operation not permitted
```

Open the file `/var/snap/microk8s/current/args/docker-daemon.json` and set the content to this:

```
{
  "insecure-registries" : ["localhost:32000"],
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 65536,
      "Soft": 65536
     }
  }
}
```

Apply the change with: 

```bash
$ sudo systemctl restart snap.microk8s.daemon-docker.service
```

If you are interested to know more, here are some links:

- [docker docs](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)
- [stack overflow](https://stackoverflow.com/questions/24318543/how-to-set-ulimit-file-descriptor-on-docker-container-the-image-tag-is-phusion)
- [the offending code](https://github.com/cloudfoundry/uaa-release/blob/master/jobs/uaa/templates/bin/uaa_ctl.erb#L46)

### Don't inherit DNS

In my system's `/etc/resolv.conf` I had this line:

```
search suse.de
```

This (by default) was inherited inside the pods resolv.conf file (See here why: [kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/#introduction), [microk8s](https://github.com/ubuntu/microk8s/blob/master/microk8s-resources/actions/dns.yaml#L209))

This resulted in router-0 pod to fail to become ready (it was adding suse.de in the routing-api-0 hostname).
To avoid this (or other similar) problem, open `/var/snap/microk8s/current/args/kubelet` and add this line in the existing options:

```
--resolv-conf=""
```

Apply the change with:

```bash
$ sudo systemctl restart snap.microk8s.daemon-kubelet.service
```

### Enable swap accounting

One more thing you need to ensure is that you have swapaccount enabled on your host system (since this is the kernel that is being used by all the containers). All you need to do is to add `swapaccount=1` in your kernel options. Here is how I did that but you should use whatever works for your system:

- Edit `/etc/default/grub` and add `swapaccount=1` in the `GRUB_CMDLINE_LINUX_DEFAULT` (or `GRUB_CMDLINE_LINUX`)
- Update grub: `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`
- Reboot your system to apply the change

## Deploy SUSE Cloud Application Platform

Our cluster is ready so we can follow [the official documentation to deploy CAP](https://www.suse.com/documentation/cloud-application-platform-1/singlehtml/book_cap_guides/book_cap_guides.html#sec.cap.helm-deploy-prod):

Install tiller:

```bash
$ helm init --upgrade
$ watch helm version
```
(wait until the tiller version appears)


Setup the suse helm registry:

```bash
$ helm repo add suse https://kubernetes-charts.suse.com/
```

Create the scf-config-value.yaml (replace `192.168.1.152` everywhere in the file
with the one returned by `microk8s.config | grep server`):

```yaml

env:
  DOMAIN: 192.168.1.152.nip.io


  # UAA host and port
  UAA_HOST: uaa.192.168.1.152.nip.io
  UAA_PORT: 2793

sizing:
  cc_uploader:
    capabilities: ["SYS_RESOURCE"]
  diego_api:
    capabilities: ["SYS_RESOURCE"]
  diego_brain:
    capabilities: ["SYS_RESOURCE"]
  diego_ssh:
    capabilities: ["SYS_RESOURCE"]
  nats:
    capabilities: ["SYS_RESOURCE"]
  router:
    capabilities: ["SYS_RESOURCE"]
  routing_api:
    capabilities: ["SYS_RESOURCE"]

kube:
  # The IP address assigned to the kube node pointed to by the domain.
  external_ips: ["192.168.1.152"]

  # Run kubectl get storageclasses
  # to view your available storage classes
  storage_class:
    persistent: "microk8s-hostpath"
    shared: "shared"

  # The registry the images will be fetched from.
  # The values below should work for
  # a default installation from the SUSE registry.
  registry:
    hostname: "registry.suse.com"
    username: ""
    password: ""
  organization: "cap"
  auth: none

secrets:
  # Create a password for your CAP cluster
  CLUSTER_ADMIN_PASSWORD: password

  # Create a password for your UAA client secret
  UAA_ADMIN_CLIENT_SECRET: password
```

Wait until UAA pods become ready:

```bash
$ wait kubectl get pods -n uaa
```

Install scf:

```bash
$ SECRET=$(kubectl get pods --namespace uaa \
-o jsonpath='{.items[?(.metadata.name=="uaa-0")].spec.containers[?(.name=="uaa")].env[?(.name=="INTERNAL_CA_CERT")].valueFrom.secretKeyRef.name}')

$ CA_CERT="$(kubectl get secret $SECRET --namespace uaa \
-o jsonpath="{.data['internal-ca-cert']}" | base64 --decode -)"

$ helm install suse/cf \
--name susecf-scf \
--namespace scf \
--values scf-config-values.yaml \
--set "secrets.UAA_CA_CERT=${CA_CERT}"
```

Wait until all pods become ready:

```bash
$ wait kubectl get pods -n scf
```

Your ClouFoundry cluster is now ready to be used. Setup the api (replace `192.168.1.152` with the correct ip as before):

```bash
$ cf api --skip-ssl-validation https://api.192.168.1.152.nip.io
```

```bash
$ cf login
```

(credentials are `admin` and `password` if you used the scf-config-values.yaml from above)

Enjoy!


## Conclusion

- You can run applications and services locally (e.g. concourse)
