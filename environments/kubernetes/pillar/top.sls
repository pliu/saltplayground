base:
  'roles:cluster1':
    - match: grain
    - kubernetes.cluster1
  'roles:cluster2':
    - match: grain
    - kubernetes.cluster2
