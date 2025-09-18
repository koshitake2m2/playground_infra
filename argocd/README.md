# ArgoCD

## Setup

### 1. Install

```bash
brew install minikube
brew install argocd
brew install kustomize
```

### 2. minikubeクラスターの起動

```bash
# minikubeクラスターを起動
minikube start
minikube dashboard --url
```

### 3. ArgoCD構築

```bash

kubectx minikube

# ArgoCD用のネームスペースを作成
kubectl create namespace argocd

# ArgoCDをデプロイ
kubectl kustomize ./argocd-config | kubectl apply -f -
```

```bash
# ポッドの状態を確認
kubectl get pods -n argocd

# すべてのポッドがRunning状態になるまで待機（通常1-2分程度）
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=300s
```

### 4. ArgoCDへアクセス

```bash
# ArgoCDの初期パスワードを取得
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# ArgoCDサーバーにポートフォワード（別ターミナルで実行）
kubectl port-forward svc/argocd-server -n argocd 18080:443

# ブラウザで https://localhost:18080 にアクセス
# ユーザー名: admin
# パスワード: 上記コマンドで取得した値

# ArgoCD CLIでのログイン
argocd login localhost:18080
```

## Deploy Sample App

### Build image and upload to minikube

```bash
cd sample-app
docker compose build

# imageアップロード
minikube image ls | grep sample-app-api
minikube image load sample-app-api:latest
```

### Deploy

```bash
# sample-app-configを修正してpush
git push
```

### Test

```bash
# Access to sample-app-api
kubectl port-forward -n sample-app-dev service/sample-app-service 28080:28080
curl 'http://localhost:28080'

# Access to helloweb
kubectl port-forward -n sample-app-dev service/helloweb-service 38080:38080
curl 'http://localhost:38080'
```

## Debug

```bash
# Access to pods from cluster.
kubectl run -n sample-app-dev netshoot --image=nicolaka/netshoot --restart=Never -it --rm -- bash
curl 'http://sample-app-service.sample-app-dev.svc.cluster.local:28080'
curl 'http://helloweb-service.sample-app-dev.svc.cluster.local:38080'
```

## Cleanup

```bash
# ArgoCDを削除
kubectl delete namespace argocd

# minikubeを停止
minikube stop

# minikubeを完全に削除（必要に応じて）
minikube delete
```

## Setup Memo

```bash
cd argocd-config
# ArgoCDの公式マニフェストをダウンロード
curl -o argocd-install.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## 参考リンク

- [ArgoCD公式ドキュメント](https://argo-cd.readthedocs.io/)
- [ArgoCD GitHub](https://github.com/argoproj/argo-cd)
- [minikube公式ドキュメント](https://minikube.sigs.k8s.io/docs/)
