## SWFPacker

作成した SWF をまとめて Embed すると同一 ApplicationDomain 内にまとめてくれるやつ。

## 使い方

SWFPacker を継承したクラスで複数の SWF を Embed する。
※ public で Embed すると自動で準備対象となる。

SWFPacker を使って一纏めになった SWF を別 SWF からロードする場合は
ロードする際に ApplicationDomain を指定する。

準備が完了すると Loader が Event.COMPLETE を送出する。
※ Loader.contentLoaderInfo じゃないよ。

あとは　ApllicationDomain.currentDomain.getDefinition() でクラスを呼び出すなり、
ロードする側にあったクラスを動的に上書きするなりして使ってください。

## 対象

FlashPlayer9 以上


