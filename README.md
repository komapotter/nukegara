### クラスタ作成

```
kind create cluster --name nukegara --config kind-multinode.yaml

export KUBECONFIG="$(kind get kubeconfig-path --name="nukegara")"

kubectl cluster-info

kubectl create -f k8s-nukegara.yaml

---

kubectl delete -f k8s-nukegara.yaml

kind delete cluster --name nukegara

```


### ポートフォワード作成

```
kubectl port-forward $(kubectl get pods -l "app=nukegara-server" -oname) 3000:1323 &

curl -XGET http://nukegara-server:3000
```



### telepresence操作

```
telepresence --run curl -XGET http://nukegara-server:3000

telepresence --swap-deployment nukegara-server --docker-run --rm -it nukegara_web:latest

kubectl run access-nukegara-server -it --rm --image=pstauffer/curl --restart=Never -- curl http://nukegara-server:3000
```


### aks デプロイ

```
az group list

az group create --name test-aks --location japaneast

az acr create --resource-group test-aks --name 36raftsNukegara --sku Basic --admin-enabled true

az acr show --name 36raftsNukegara --query loginServer

az acr credential show --name 36raftsNukegara --query 'passwords[0].value'

docker login --username=36raftsNukegara --password=Cr3a3tGMfPof8eHWViLWm3N48ZV8=Qff 36raftsnukegara.azurecr.io

docker tag 36rafts/nukegara:latest 36raftsnukegara.azurecr.io/web:v1

docker push 36raftsnukegara.azurecr.io/web:v1

az acr repository list --name 36raftsNukegara --output table

az ad sp create-for-rbac --skip-assignment

az acr show --resource-group test-aks --name 36raftsNukegara --query "id" --output tsv

az role assignment create --assignee 7d5063d0-3f93-4896-b925-db93a2342bc1 --scope /subscriptions/4efd3999-3e82-4718-9732-809cfbf0b18c/resourceGroups/test-aks/providers/Microsoft.ContainerRegistry/registries/36raftsNukegara --role acrpull

az aks create --resource-group test-aks --location japaneast --name NukegaraCluster --node-count 1 --service-principal 7d5063d0-3f93-4896-b925-db93a2342bc1 --client-secret 923f161e-f5e1-449d-8137-719b1bce8f1c --generate-ssh-keys

az aks get-credentials --resource-group test-aks --name NukegaraCluster

az acr list --resource-group test-aks --query "[].{acrLoginServer:loginServer}" --output table

kubectl apply -f aks-nukegara.yaml

kubectl get service nukegara-server --watch
```
