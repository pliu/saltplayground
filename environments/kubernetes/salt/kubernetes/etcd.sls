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

/etc/kubernetes/pki/etcd/ca.crt:
  file.managed:
    - source: salt://kubernetes/files/ca.crt

/etc/kubernetes/pki/etcd/ca.key:
  file.managed:
    - source: salt://kubernetes/files/ca.key

generate_server_cert:
  cmd.run:
    - name: kubeadm init phase certs etcd-server --config=/home/kubeadmcfg.yaml
    - require:
        - sls: kubernetes.base
        - file: /home/kubeadmcfg.yaml
        - file: /etc/kubernetes/pki/etcd/ca.crt
        - file: /etc/kubernetes/pki/etcd/ca.key
    - creates:
        - /etc/kubernetes/pki/etcd/server.crt
        - /etc/kubernetes/pki/etcd/server.key

generate_peer_cert:
  cmd.run:
    - name: kubeadm init phase certs etcd-peer --config=/home/kubeadmcfg.yaml
    - require:
        - sls: kubernetes.base
        - file: /home/kubeadmcfg.yaml
        - file: /etc/kubernetes/pki/etcd/ca.crt
        - file: /etc/kubernetes/pki/etcd/ca.key
    - creates:
        - /etc/kubernetes/pki/etcd/peer.crt
        - /etc/kubernetes/pki/etcd/peer.key

generate_healthcheck_client_cert:
  cmd.run:
    - name: kubeadm init phase certs etcd-healthcheck-client --config=/home/kubeadmcfg.yaml
    - require:
        - sls: kubernetes.base
        - file: /home/kubeadmcfg.yaml
        - file: /etc/kubernetes/pki/etcd/ca.crt
        - file: /etc/kubernetes/pki/etcd/ca.key
    - creates:
        - /etc/kubernetes/pki/etcd/healthcheck-client.crt
        - /etc/kubernetes/pki/etcd/healthcheck-client.key

generate_apiserver_client_cert:
  cmd.run:
    - name: kubeadm init phase certs apiserver-etcd-client --config=/home/kubeadmcfg.yaml
    - require:
        - sls: kubernetes.base
        - file: /home/kubeadmcfg.yaml
        - file: /etc/kubernetes/pki/etcd/ca.crt
        - file: /etc/kubernetes/pki/etcd/ca.key
    - creates:
        - /etc/kubernetes/pki/apiserver-etcd-client.crt
        - /etc/kubernetes/pki/apiserver-etcd-client.key

generate_etcd_manifest:
  cmd.run:
    - name: kubeadm init phase etcd local --config=/home/kubeadmcfg.yaml
    - require:
        - cmd: generate_server_cert
        - cmd: generate_peer_cert
        - cmd: generate_healthcheck_client_cert
        - cmd: generate_apiserver_client_cert
    - creates:
        - /etc/kubernetes/manifests/etcd.yaml
