docker:
  pkg.installed:
    - name: docker.io

  service.running:
    - require:
        - pkg: docker


kubernetes:
  pkgrepo.managed:
    - humanname: Kubernetes
    - name: deb http://packages.cloud.google.com/apt/ kubernetes-xenial main
    - dist: kubernetes-xenial
    - file: /etc/apt/sources.list.d/kubernetes.list
    - gpgcheck: 1
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg

  pkg.installed:
    - pkgs:
        - kubeadm
        - kubelet
    - require:
        - pkgrepo: kubernetes
        - service: docker
