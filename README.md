### クラスタ作成

```
kind create cluster --name go-dummy-api --config kind-multinode.yaml

export KUBECONFIG="$(kind get kubeconfig-path --name="go-dummy-api")"

kubectl cluster-info

kubectl create -f k8s-go-dummy-api.yaml

---

kubectl delete -f k8s-go-dummy-api.yaml

kind delete cluster --name go-dummy-api

```


### ポートフォワード作成

```
kubectl port-forward $(kubectl get pods -l "app=go-dummy-api-server" -oname) 3000:1323 &

curl -XGET http://go-dummy-api-server:3000
```



### telepresence操作

```
telepresence --run curl -XGET http://go-dummy-api-server:3000

telepresence --swap-deployment go-dummy-api-server --docker-run --rm -it go-dummy-api_web:latest

kubectl run access-go-dummy-api-server -it --rm --image=pstauffer/curl --restart=Never -- curl http://go-dummy-api-server:3000
```


### aks デプロイ

```
az group list

az group create --name test-aks --location japaneast

az acr create --resource-group test-aks --name 36raftsGoDummyApi --sku Basic --admin-enabled true

az acr show --name 36raftsGoDummyApi --query loginServer

az acr credential show --name 36raftsGoDummyApi --query 'passwords[0].value'

docker login --username=36raftsGoDummyApi --password=Cr3a3tGMfPof8eHWViLWm3N48ZV8=Qff 36raftsgodummyapi.azurecr.io

docker tag 36rafts/go-dummy-api:latest 36raftsgodummyapi.azurecr.io/web:v1

docker push 36raftsgodummyapi.azurecr.io/web:v1

az acr repository list --name 36raftsGoDummyApi --output table

az ad sp create-for-rbac --skip-assignment

az acr show --resource-group test-aks --name 36raftsGoDummyApi --query "id" --output tsv

az role assignment create --assignee 7d5063d0-3f93-4896-b925-db93a2342bc1 --scope /subscriptions/4efd3999-3e82-4718-9732-809cfbf0b18c/resourceGroups/test-aks/providers/Microsoft.ContainerRegistry/registries/36raftsGoDummyApi --role acrpull

az aks create --resource-group test-aks --location japaneast --name GoDummyApiCluster --node-count 1 --service-principal 7d5063d0-3f93-4896-b925-db93a2342bc1 --client-secret 923f161e-f5e1-449d-8137-719b1bce8f1c --generate-ssh-keys

az aks get-credentials --resource-group test-aks --name GoDummyApiCluster

az acr list --resource-group test-aks --query "[].{acrLoginServer:loginServer}" --output table

kubectl apply -f aks-go-dummy-api.yaml

kubectl get service go-dummy-api-server --watch
```
