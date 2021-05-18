.PHONY: k3d-up
k3d-up:
		k3d cluster create secops

.PHONY: k3d-down
k3d-down:
		k3d cluster delete secops

.PHONY: starboard
starboard-init:
		kubectl starboard init -v 3
		kubectl create deployment nginx --image nginx:1.16 -n default

.PHONY: kube-bench		
kube-bench:
		kubectl starboard scan ciskubebenchreports -n default

.PHONY: trivy
trivy:
		kubectl starboard scan vulnerabilityreports deployment/nginx -n default

.PHONY: polaris
polaris:
		kubectl starboard scan configauditreports deployment/nginx -n default

.PHONY: kube-hunt
kube-hunt:
		kubectl starboard scan kubehunterreports -n default

.PHONY: scan
scan: kube-bench trivy polaris kube-hunt

.PHONY: report
report:
		kubectl get vulnerabilityreports -o wide -l starboard.resource.kind=Deployment,starboard.resource.name=nginx -n default; echo
		kubectl get configauditreports -o wide -l starboard.resource.kind=Deployment,starboard.resource.name=nginx -n default; echo
		kubectl get ciskubebenchreports -o wide -n default; echo
		kubectl get KubeHunterReport cluster -o wide -n default; echo
		kubectl starboard get report deployment/nginx -o html -n default > reports/deployment-nginx.html -n default
		kubectl starboard get report node/k3d-secops-server-0 -o html -n default > reports/k3d-secops-server-0.html
		kubectl get KubeHunterReport cluster -o yaml -n default > reports/kube-hunt.txt
		open reports/k3d-secops-server-0.html
		open reports/deployment-nginx.html
		open reports/kube-hunt.txt
