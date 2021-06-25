base:
  '*':
    - core
  'roles:etcd':
    - match: grain
    - kubernetes.etcd
  'roles:master':
    - match: grain
    - kubernetes.master
  'roles:worker':
    - match: grain
    - kubernetes.worker
