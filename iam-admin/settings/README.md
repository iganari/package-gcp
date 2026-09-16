# Settings

## Project Number の確認方法

- Project ID を環境変数に入れる

```
export _gc_pj_id='Your Google Cloud Project ID'
```

- gcloud コマンドで Project Number を表示する

```
gcloud projects describe ${_gc_pj_id} --format="value(projectNumber)"
```
