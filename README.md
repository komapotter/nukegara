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
