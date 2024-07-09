init:
	terraform -chdir=terraform/init/ apply

plan:
	helmfile -f helmfiles/quest.yaml --selector release=quest diff upgrade

deploy:
	helmfile -f helmfiles/quest.yaml --selector release=quest sync