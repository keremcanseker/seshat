# Seshat CLI

Seshat'i terminalden kullanmak için küçük bir kılavuz.

## Kurulum

`.app` paketinin içindeki shim'i `PATH`'inde olan bir yere bağla:

```sh
"$(find ~/Library/Developer/Xcode/DerivedData -name 'Seshat.app' -path '*/Debug/*' -type d | head -1)/Contents/Resources/seshat" install ~/.local/bin/seshat
```

`/usr/local/bin` yerine `~/.local/bin` öneriyoruz — sudo istemez.

## Komutlar

| Komut | Ne yapar |
|---|---|
| `seshat open <dosya.md>` | Dosyayı kendi pencerede açar |
| `seshat global <dosya.md>` | Workspace penceresinde dosyayı seçer |
| `seshat help` | Komut listesini gösterir |

## Örnekler

```sh
# tek bir notu aç
seshat open ~/notes/today.md

# workspace'i aç ve içinde bir dosya seç
seshat global ~/Seshat/work/spec.md

# repo'daki örnek dosyayla dene
seshat open samples/stress.md
```

## URL şeması

CLI aslında `seshat://` URL'leri tetikliyor. Aynı şeyi doğrudan da yapabilirsin:

```sh
open "seshat://open?path=$HOME/notes/today.md"
open "seshat://global?path=$HOME/Seshat/work/spec.md"
```

## Kütüphane

Tüm dosyalar `~/Seshat/` altında yaşar. Üst seviye klasörler birer **workspace**'tir; sidebar bunları gösterir. Yeni klasörü Finder'dan eklemen yeterli — FSEvents değişikliği yakalar.
