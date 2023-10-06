# Filestore

## 概要

下記は間違い

クラウドホスト型の NoSQL ドキュメント指向データベース

```
公式ドキュメント
https://firebase.google.com/docs/firestore/data-model
```

[![](https://img.youtube.com/vi/v_hR4K4auoQ/0.jpg)](https://www.youtube.com/watch?v=v_hR4K4auoQ)


---> Firebase の再生リスト [Get to know Cloud Firestore](https://www.youtube.com/playlist?list=PLl-K7zZEsYLluG5MCVEzXAQ7ACZBCuZgZ)

## API の有効化

```
gcloud beta services enable file.googleapis.com --project ${_gc_pj_id}
```

## パフォーマンスについて

Filestore の予想される平均パフォーマンスと推奨パフォーマンスは以下を参照

https://cloud.google.com/filestore/docs/performance?hl=en

## memo

```
Instance ID の制約
unique in its zone. Use lowercase letters, numbers, and hyphens. Start with a letter.
そのゾーンでユニーク。 小文字、数字、およびハイフンを使用します。 文字から始めます。
```

```
File share name の制約
Use lowercase letters, numbers, and underscores. Start with a letter.
小文字、数字、および下線を使用します。 文字から始めます。
```


```
Cloud Functions と Cloud Scheduler を用いたバックアップのスケジュール設定
https://cloud.google.com/filestore/docs/scheduling-backups
```
