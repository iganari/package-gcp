# Settings

## Project Number の確認方法

- Project ID を環境変数に入れる

```
export _gc_pj_id='Your Google Cloud Project ID'
```

- ghioe

```
gcloud projects describe ${_gc_pj_id} --format="value(projectNumber)"
```
