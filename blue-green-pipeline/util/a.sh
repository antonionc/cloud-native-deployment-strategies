#!/usr/bin/env bash
cd /tmp/deployment
cd cloud-native-deployment-strategies
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.0.1 --param MODE=online --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog

cd blue-green-pipeline/pipelines/run-products
oc create -f 1-pipelinerun-products-new-version.yaml -n gitops

oc get service products-umbrella-offline -n gitops --output="jsonpath={.spec.selector.version}" > color
replicas=-1
while [ $replicas != 0 ]
do
    sleep 5
    replicas=$(oc get deployments products-$(cat color) -n gitops --output="jsonpath={.spec.replicas}" 2>&1)
    echo $replicas
done
while [ $replicas != 2 ]
do
    sleep 5
    replicas=$(oc get deployments products-$(cat color) -n gitops --output="jsonpath={.spec.replicas}" 2>&1)
    echo $replicas

done

tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=online --param MODE=offline --param LABEL=.mode --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.products[0].discountInfo.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.1.1 --param MODE=offline --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog

oc create -f 2-pipelinerun-products-switch.yaml -n gitops
sleep 20s
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.1.1 --param MODE=online --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog

#Rollback
oc create -f 2-pipelinerun-products-switch-rollback.yaml -n gitops
sleep 20s
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.0.1 --param MODE=online --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog


oc create -f 2-pipelinerun-products-switch.yaml -n gitops
sleep 20s
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.1.1 --param MODE=online --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog


oc create -f 3-pipelinerun-products-scale-down.yaml -n gitops
sleep 30s

tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=online --param MODE=online --param LABEL=.mode --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.products[0].discountInfo.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.1.1 --param MODE=offline --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog
tkn pipeline start pipeline-blue-green-e2e-test --param NEW_IMAGE_TAG=v1.1.1 --param MODE=online --param LABEL=.version --param APP=products --param NAMESPACE=gitops  --param MESH=False --param JQ_PATH=.metadata --workspace name=app-source,claimName=workspace-pvc-shop-cd-e2e-tests -n gitops --showlog


