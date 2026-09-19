# Google Cloud プロジェクトについて


## Google Cloud プロジェクトの作成

![](./_img/01.png)

## 必要な Role

+ Google Cloud プロジェクトを作成する権限
  + Project Creator( プロジェクト作成者 )
    + `roles/resourcemanager.projectCreator`
    + 組織配下でもいいし、フォルダ配下でも良い
    + 組織直下でつけると、組織の名前が見える
    + フォルダにつけると、フォルダ配下が見えるし、そのフォルダ配下のフォルダを見れる


https://cloud.google.com/resource-manager/docs/creating-managing-projects?hl=en


## Gooogle Cloud Project の Project Number を調べるコマンド

- Project ID を環境変数にいれる

```
export _gc_pj_id='Google Cloud Project ID'
```

- Project の情報を表示する

```
gcloud beta projects describe ${_gc_pj_id}
OR
gcloud beta projects describe ${_gc_pj_id} --format json
```

- Project Number だけを出す

```
gcloud beta projects describe ${_gc_pj_id} --format="value(projectNumber)"
OR
gcloud beta projects describe ${_gc_pj_id} --format json | jq -r .projectNumber
```
