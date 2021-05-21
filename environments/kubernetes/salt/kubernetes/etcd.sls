include:
  - kubernetes.base

/etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf:
  file.managed:
    - source: salt://kubernetes/files/kubelet-etcd.conf

kubelet:
  service.running:
    - watch:
        - file: /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
    - reload: true

/home/kubeadmcfg.yaml:
  file.managed:
    - source: salt://kubernetes/files/kubeadmcfg-etcd.yaml
    - template: jinja
