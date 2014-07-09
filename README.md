# idobata-hooks

[![Build Status](https://travis-ci.org/idobata/idobata-hooks.png)](https://travis-ci.org/idobata/idobata-hooks)
[![Dependency Status](https://gemnasium.com/idobata/idobata-hooks.svg)](https://gemnasium.com/idobata/idobata-hooks)
[![Code Climate](https://codeclimate.com/github/idobata/idobata-hooks.png)](https://codeclimate.com/github/idobata/idobata-hooks)

A collection of [Idobata](https://idobata.io) hooks.

(see: [README written in Japanese](#idobata-hooks-japanese))

## How to add a new hook

First, you would create a new directory `my_hook` under `lib/hooks`.
`my_hook` is your new hook name.

The minimal requirements are:
* **hook.rb**: `lib/hooks/my_hook/hook.rb`

  ``` ruby
  module Idobata::Hook
    class MyHook < Base
      screen_name 'My Hook'
      identifier  :my_hook
      icon_url    'http://example.com/path/to/icon.png'
    end
  end
  ```

  * (required)
    * `screen_name`: The hook name. The is displayed as message sender.
    * `identifier`: The internal identifier. This should not be duplicated as other identifier.
    * `icon_url`: The icon url. The icon linked by URL is displayed as message sender.

  * (optional)
    * [`template_name`](#customizing-template)
    * [`form_json_key`](#treating-url-encoded-json)
    * [`forced_content_type`](#specifying-content-type-against-content-type-header)

* **templates/default.html.haml**: `lib/hooks/my_hook/templates/default.html.haml`

  ``` haml
  hi from #{payload.message}.
  ```

  You can access request body via `payload` in template.
  `payload` is like a `struct` that is automatically parsed by `Content-Type`.

* **instructions.js.hbs.hamlbars**: `lib/hooks/my_hook/instructions.js.hbs.hamlbars`

  ``` haml
  %dl
    %dt Usage
    %dd
      See <a href="http://my-service.com/webhook" target="_blank">Webhook | My Service</a>.
  ```

  This will be shown as an instruction for hook usage.

### Customizing template

You can customize template using `template_name` method.

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name   'My Hook'
    identifier    :my_hook
    icon_url      'http://example.com/path/to/icon.png'
    template_name { custom_template_name }

    private

    def custom_template_name
      if payload.is_urgent
        'alert.html.haml'
      else
        'default.html.haml'
      end
    end
  end
end
```

### Treating url-encoded JSON

You can use `form_json_key` for payload that is posted as url-encoded JSON.

When you want to treat :arrow_down:,

```
payload={"message":"hi"}
```

`form_json_key 'payload'` is required.

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name   'My Hook'
    identifier    :my_hook
    icon_url      'http://example.com/path/to/icon.png'
    form_json_key 'payload'
  end
end
```

### Specifying content type against `Content-Type` header

You can use `forced_content_type` for the service that lie about content type.

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name         'My Hook'
    identifier          :my_hook
    icon_url            'http://example.com/path/to/icon.png'
    forced_content_type :json
  end
end
```

The available values are:
* `:json`
* `:xml`

### Ignoring request

You can use `skip_processing!` at `before_render` callback to ignore posting message.

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name 'My Hook'
    identifier  :my_hook
    icon_url    'http://example.com/path/to/icon.png'

    before_render do
      skip_processing! if payload.is_bored
    end
  end
end
```

## Unit Test

```
$ rake
```

## Preview your hook

You can check a new hook on Idobata with actual HTTP request from 3rd party services.

1. Deploy idobata-hooks to a server which is accessible from the target service. (such as [Heroku](https://heroku.com) \* In Heroku the environment variable `BUNDLE_WITHOUT="test"` is required.)
2. Setup idobata-hooks URL to 3rd party services.
3. Set generic hook URL of your room to the environment variable `IDOBATA_HOOK_URL`.

When idobata-hooks receive a HTTP request, it posts a new message via generic hook to Idobata.

----

# idobata-hooks (Japanese)

## hookを追加するには

まずは新しいhookのためにディレクトリを作ります。
hookの名前が`my_hook`である場合、`lib/hooks`の下に`my_hook`を作ります。

このディレクトリ配下に必要なファイルは3つです:
* `hook.rb`
* `templates/default.html.haml`
* `instructions.js.hbs.hamlbars`

それぞれのファイルについて説明します:arrow_down:

* `hook.rb`

  hook特有の設定を記述します。

  ``` ruby
  module Idobata::Hook
    class MyHook < Base
      screen_name 'My Hook'
      identifier  :my_hook
      icon_url    'http://example.com/path/to/icon.png'
    end
  end
  ```

  * (必須設定)
    * `screen_name`: hookの名前です。hookが作成したメッセージの発言者として表示されます
    * `identifier`: 内部的にhookを特定するための識別子です。他のhookと重複してはいけません。
    * `icon_url`: hookのアイコンです。メッセージの発言者として表示されます。

  * (任意設定)
    * [`template_name`](#テンプレートを使い分ける)
    * [`form_json_key`](#urlencodedされたjsonを扱う)
    * [`forced_content_type`](#content-typeに依存せずリクエストを扱う)

* `templates/default.html.haml`

  このファイルは、リクエストからメッセージのHTMLを組み立てるためのテンプレートです。

  ``` haml
  hi from #{payload.message}.
  ```

  リクエストパラメータには`payload`メソッド経由でアクセスできます。
  `payload`は`Content-Type`に応じて自動的にパースされたStructっぽいものです。

* `instructions.js.hbs.hamlbars`

  hookの設定方法として表示されます。

  ``` haml
  %dl
    %dt Usage
    %dd
      See <a href="http://my-service.com/webhook" target="_blank">Webhook | My Service</a>.
  ```

### テンプレートを使い分ける

リクエストの種類によってテンプレートを切り替えたい場合、`template_name`メソッドを使うことができます。

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name   'My Hook'
    identifier    :my_hook
    icon_url      'http://example.com/path/to/icon.png'
    template_name { custom_template_name }

    private

    def custom_template_name
      if payload.is_urgent
        'alert.html.haml'
      else
        'default.html.haml'
      end
    end
  end
end
```

この例の場合、`lib/hooks/my_hook/templates/`の下に`alert.html.haml`と`default.html.haml`を作成する必要があります。

### urlencodedされたJSONを扱う

JSONをurlencodedした状態でリクエストを送ってくるサービスに対応するには`form_json_key`を設定します。

例えば:arrow_down:のようなリクエストを扱うためには

```
payload={"message":"hi"}
```

`form_json_key 'payload'`を指定します。

```ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name   'My Hook'
    identifier    :my_hook
    icon_url      'http://example.com/path/to/icon.png'
    form_json_key 'payload'
  end
end
```

### Content-Typeを強制する

`Content-Type`を偽ってリクエストを送ってくるサービスに対応するには`forced_content_type`を設定します。

```ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name         'My Hook'
    identifier          :my_hook
    icon_url            'http://example.com/path/to/icon.png'
    forced_content_type :json
  end
end
```

この設定を行うと、`Content-Type`に関係なくリクエストを扱うことができます。

設定可能な値は:arrow_down:です:
* `:json`
* `:xml`

### リクエストを無視する

リクエストの種類によってメッセージの投稿を無視したい場合、`before_render`の中で`skip_processing!`メソッドを呼び出します。

``` ruby
# lib/hooks/my_hook/hook.rb
module Idobata::Hook
  class MyHook < Base
    screen_name 'My Hook'
    identifier  :my_hook
    icon_url    'http://example.com/path/to/icon.png'

    before_render do
      skip_processing! if payload.is_bored
    end
  end
end
```

## テスト

```
$ rake
```

## フックを動作確認する

動作確認のために、実際のサービスからリクエストを受けてIdobataにメッセージを送ることができます。

1. idobata-hooksを外部からアクセス可能なサーバにデプロイします。 (例えば[Heroku](https://heroku.com)。\* Heroku では環境変数`BUNDLE_WITHOUT="test"`を設定する必要があります。)

2. idobata-hooksのホスト名を環境変数`IDOBATA_HOOK_HOST`に設定します。

3. サービスのwebhookにidobata-hooksのエンドポイントを指定します。
  idobata-hooksのデプロイ先が`http://example.com`の場合は`http://example.com/my_hook`がエンドポイントです。

4. 生成したメッセージの表示を確認するために、あなたが所属するroomの**generic hook**のURLを環境変数`IDOBATA_HOOK_URL`に設定してください。

この状態でidobata-hooksがサービスからのリクエストを受けると、generic hookによってIdobataにメッセージが投稿されます。
